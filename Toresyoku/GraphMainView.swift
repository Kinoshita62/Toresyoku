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
    @Query private var imageColor: [ImageColorModel]
    
    @State private var kcalScrollPosition: Date = Date()
    @State private var proteinScrollPosition: Date = Date()
    @State private var fatScrollPosition: Date = Date()
    @State private var carbohydrateScrollPosition: Date = Date()

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
    
    private var dailyCalories: [(date: Date, totalKcal: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) ?? today
        
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })

        return allDates
            .filter { $0 >= thirtyDaysAgo }
            .map { date in
                let totalKcal = groupedMeals[date]?.reduce(0) { $0 + $1.MealKcal } ?? 0
                return (date: date, totalKcal: totalKcal)
            }
    }
    
    private var dailyProtein: [(date: Date, totalProtein: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) ?? today
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates
            .filter { $0 >= thirtyDaysAgo }
            .map { date in
                let totalProtein = groupedMeals[date]?.reduce(0) { $0 + $1.MealProtein } ?? 0
                return (date: date, totalProtein: totalProtein)
            }
    }
    
    private var dailyFat: [(date: Date, totalFat: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) ?? today
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates
            .filter { $0 >= thirtyDaysAgo }
            .map { date in
                let totalFat = groupedMeals[date]?.reduce(0) { $0 + $1.MealFat } ?? 0
                return (date: date, totalFat: totalFat)
            }
    }
    
    private var dailyCarbohydrate: [(date: Date, totalCarbohydrate: Double)] {
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) ?? today
        let allDates = stride(from: calendar.startOfDay(for: firstMealDate), through: today, by: 60 * 60 * 24).map { $0 }
        
        let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
        return allDates
            .filter { $0 >= thirtyDaysAgo }
            .map { date in
                let totalCarbohydrate = groupedMeals[date]?.reduce(0) { $0 + $1.MealCarbohydrate } ?? 0
                return (date: date, totalCarbohydrate: totalCarbohydrate)
            }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("1日のカロリー摂取量")
                    .font(.title3)
                    .bold()
                    .padding(.top, 25)
                Chart {
                    ForEach(dailyCalories, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("kcal", data.totalKcal)
                        )
                        .foregroundStyle(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 1
                        ))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetKcal))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(Color(.black))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("目標")
                                .font(.caption)
                            .foregroundColor(Color(.black))}
                }
                .padding(5)
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 1)) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: Date.FormatStyle()
                            .month(.defaultDigits)
                            .day(.defaultDigits)
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
                                    if let lastDate = dailyCalories.last?.date {
                                        kcalScrollPosition = lastDate
                                    }
                                }
                .frame(height: 250)
                
                Text("1日のたんぱく質摂取量")
                    .font(.title3)
                    .bold()
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyProtein, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalProtein)
                        )
                        .foregroundStyle(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 1
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
                            .month(.defaultDigits)
                            .day(.defaultDigits)
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
                                    if let lastDate = dailyProtein.last?.date {
                                        proteinScrollPosition = lastDate
                                    }
                                }
                .frame(height: 250)
            
                Text("1日の脂質摂取量")
                    .font(.title3)
                    .bold()
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyFat, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalFat)
                        )
                        .foregroundStyle(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 1
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
                            .month(.defaultDigits)
                            .day(.defaultDigits)
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
                                    if let lastDate = dailyFat.last?.date {
                                        fatScrollPosition = lastDate
                                    }
                                }
                .frame(height: 250)
       
                
                Text("1日の炭水化物摂取量")
                    .font(.title3)
                    .bold()
                    .padding(.top, 50)
                Chart {
                    ForEach(dailyCarbohydrate, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalCarbohydrate)
                        )
                        .foregroundStyle(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 1
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
                            .month(.defaultDigits)
                            .day(.defaultDigits)
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
                                    if let lastDate = dailyCarbohydrate.last?.date {
                                        carbohydrateScrollPosition = lastDate
                                    }
                                }
                .frame(height: 250)
            }
        }
    }
}

struct GraphMainView_Previews: PreviewProvider {
    static var previews: some View {
        GraphMainView(refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, ImageColorModel.self])
    }
}
