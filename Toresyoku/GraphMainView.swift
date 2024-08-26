//
//  GraphMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//
//

import SwiftUI
import SwiftData
import Charts

struct GraphMainView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var profiles: [ProfileModel]
    @Query private var mealContents: [MealContentModel]
    @Query private var ImageColor: [ImageColorModel]
    
    @State private var kcalScrollPosition: TimeInterval = 0
    @State private var proteinScrollPosition: TimeInterval = 0
    @State private var fatScrollPosition: TimeInterval = 0
    @State private var carbohydrateScrollPosition: TimeInterval = 0
    @State private var UserWeightScrollPosition: TimeInterval = 0
    @State private var UserFatPercentageScrollPosition: TimeInterval = 0
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 1
    
    @Binding var refreshGraph: UUID
    @Binding var refreshID: UUID
    
    
    let calendar = Calendar.current
    
    var targetKcal: Double {
        profiles.first?.TargetMealKcal ?? 0
    }
    
    var targetProtein: Double {
        profiles.first?.TargetMealProtein ?? 0
    }
    
    var targetFat: Double {
        profiles.first?.TargetMealFat ?? 0
    }
    
    var targetCarbohydrate: Double {
        profiles.first?.TargetMealCarbohydrate ?? 0
    }
    
    var targetUserWeight: Double {
        profiles.first?.TargetWeight ?? 0
    }
    
    var targetFatPercentage: Double {
        profiles.first?.TargetFatPercentage ?? 0
    }
    
    private var dailyCalories: [(date: Date, totalKcal: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
            
        return allDates.map { date in
            let totalKcal = groupedMeals[date]?.reduce(0) { $0 + $1.MealKcal } ?? 0
            return (date: date, totalKcal: totalKcal)
        }
    }
    
    private var dailyProtein: [(date: Date, totalProtein: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates.map { date in
            let totalProtein = groupedMeals[date]?.reduce(0) { $0 + $1.MealProtein} ?? 0
            return (date: date, totalProtein: totalProtein)
        }
    }
    
    private var dailyFat: [(date: Date, totalFat: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates.map { date in
            let totalFat = groupedMeals[date]?.reduce(0) { $0 + $1.MealFat} ?? 0
            return (date: date, totalFat: totalFat)
        }
    }
    
    private var dailyCarbohydrate: [(date: Date, totalCarbohydrate: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates.map { date in
            let totalCarbohydrate = groupedMeals[date]?.reduce(0) { $0 + $1.MealCarbohydrate} ?? 0
            return (date: date, totalCarbohydrate: totalCarbohydrate)
        }
    }
    
    private var dailyUserWeight: [(date: Date, userWeight: Double)] {
        profiles
            .filter { $0.UserWeight > 0 }
            .map { profile in
                (date: calendar.startOfDay(for: profile.UserDataAddDate), userWeight: profile.UserWeight)
            }
    }
    
    private var dailyUserFatPercentage: [(date: Date, userFatPercentage: Double)] {
        profiles
            .filter { $0.UserFatPercentage > 0 }
            .map { profile in
                (date: calendar.startOfDay(for: profile.UserDataAddDate), userFatPercentage: profile.UserFatPercentage)
            }
    }

    
    var body: some View {
        ScrollView {
            VStack {
                Text("カロリー摂取量（一日あたり）")
                    .padding(.top, 25)
                Chart {
                    ForEach(dailyCalories, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("kcal", data.totalKcal)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetKcal))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $kcalScrollPosition)
                .onAppear {
                    kcalScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)
                
                Text("たんぱく質摂取量（一日あたり）")
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyProtein, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalProtein)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetProtein))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $proteinScrollPosition)
                .onAppear {
                    proteinScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)
            
                Text("脂質摂取量（一日あたり）")
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyFat, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalFat)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetFat))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $fatScrollPosition)
                .onAppear {
                    fatScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)
       
                
                Text("炭水化物摂取量（一日あたり）")
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyCarbohydrate, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalCarbohydrate)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetCarbohydrate))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $carbohydrateScrollPosition)
                .onAppear {
                    carbohydrateScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)
                
                Text("体重")
                    .padding(.top, 50)
                Spacer()
                Chart {
                    ForEach(dailyUserWeight, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("体重", data.userWeight)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("目標体重", targetUserWeight))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis() {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $UserWeightScrollPosition)
                .onChange(of: refreshGraph) {
                    UserWeightScrollPosition = Date().timeIntervalSince1970
                }
                .onAppear {
                    UserWeightScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)


                Text("体脂肪率")
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyUserFatPercentage, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("体脂肪率", data.userFatPercentage)
                        )
                        .foregroundStyle(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 1
                        ))
                    }
                    RuleMark(y: .value("目標体脂肪率", targetFatPercentage))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color("Text"))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color("Text"))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .locale(Locale(identifier: "ja_JP")))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $UserFatPercentageScrollPosition)
                .onChange(of: refreshGraph) {
                    UserFatPercentageScrollPosition = Date().timeIntervalSince1970
                }
                .onAppear {
                    UserFatPercentageScrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 200)
            }
        }
    }
}

struct GraphMainView_Previews: PreviewProvider {
    static var previews: some View {
        GraphMainView(refreshGraph: .constant(UUID()), refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, ImageColorModel.self])
    }
}
