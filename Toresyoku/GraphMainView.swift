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
    @State private var kcalScrollPosition: TimeInterval = 0
    @State private var proteinScrollPosition: TimeInterval = 0
    @State private var fatScrollPosition: TimeInterval = 0
    @State private var carbohydrateScrollPosition: TimeInterval = 0
    
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
//        let calendar = Calendar.current
        // mealContentsから一番古い日付を取得
        guard let firstMealDate = mealContents.min(by: { $0.MealDate < $1.MealDate })?.MealDate else {
            return []
        }
        // その日付から今日までのすべての日付を生成
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
    
    var body: some View {
        ScrollView {
            VStack {
                Text("カロリー摂取量（一日あたり）")
                    .padding(.top, 20)
                Chart {
                    ForEach(dailyCalories, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("kcal", data.totalKcal)
                        )
                        .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 255/255))
                    }
                    // ターゲットカロリーの水平線を追加
                    RuleMark(y: .value("ターゲットkcal", targetKcal))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.orange)
                }
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
                    .padding(.top, 20)
                Chart {
                    ForEach(dailyProtein, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalProtein)
                        )
                        .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 255/255))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetProtein))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.orange)
                }
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
                    .padding(.top, 20)
                Chart {
                    ForEach(dailyFat, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalFat)
                        )
                        .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 255/255))
                    }
                    RuleMark(y: .value("ターゲットkcal", targetFat))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.orange)
                }
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
                    .padding(.top, 20)
                Chart {
                    ForEach(dailyCarbohydrate, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("g", data.totalCarbohydrate)
                        )
                        .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 255/255)
)
                    }
                    RuleMark(y: .value("ターゲットkcal", targetCarbohydrate))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.orange)
                }
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

                
                HStack {
                    Text("データの追加")
                    Spacer()
                }
                HStack {
                    Text("体重")
                    Spacer()
                }
                HStack {
                    Text("BMI")
                    Spacer()
                }
                HStack {
                    Text("除脂肪体重")
                    Spacer()
                }
                HStack {
                    Text("筋肉量")
                    Spacer()
                }
            }
        }
    }

}

#Preview {
    GraphMainView(refreshID: .constant(UUID()))
        .modelContainer(for: [ProfileModel.self, MealContentModel.self])
}
