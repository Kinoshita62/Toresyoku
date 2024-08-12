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
    @State private var scrollPosition: TimeInterval = 0
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short  // 日付のみを表示するスタイル
        formatter.timeStyle = .none   // 時間を表示しない
        formatter.locale = Locale(identifier: "ja_JP") // 日本のフォーマット
        return formatter
    }
    
    private var dailyCalories: [(date: Date, totalKcal: Double)] {
           let calendar = Calendar.current
           
           // 今日までの過去30日分のすべての日付を生成
           let today = calendar.startOfDay(for: Date())
           let allDates = (0..<30).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed()
           
           let groupedMeals = Dictionary(grouping: mealContents, by: { calendar.startOfDay(for: $0.MealDate) })
           
           return allDates.map { date in
               let totalKcal = groupedMeals[date]?.reduce(0) { $0 + $1.MealKcal } ?? 0
               return (date: date, totalKcal: totalKcal)
           }
       }
    
    var targetKcal: Double {
        profiles.first?.TargetMealKcal ?? 0
    }
    
    var body: some View {
        VStack {
            Text("カロリー摂取量（一日あたり）")
                Chart {
                    ForEach(dailyCalories, id: \.date) { data in
                        LineMark(
                            x: .value("日", data.date),
                            y: .value("kcal", data.totalKcal)
                        )
                    }
                    
                    // ターゲットカロリーの水平線を追加
                    RuleMark(y: .value("ターゲットkcal", targetKcal))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.red)
                }
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(values: dailyCalories.map { $0.date }) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month().day()) // 月日表示（MM/dd形式）
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartScrollPosition(x: $scrollPosition) // chartScrollPositionをバインド
                .onAppear {
                    scrollPosition = Date().timeIntervalSince1970
                }
                .frame(height: 300)
            
            HStack {
                Text("たんぱく質摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("脂肪摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("炭水化物摂取量（一日あたり）")
                Spacer()
            }
            
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

#Preview {
    GraphMainView()
        .modelContainer(for: [ProfileModel.self, MealContentModel.self])
}
