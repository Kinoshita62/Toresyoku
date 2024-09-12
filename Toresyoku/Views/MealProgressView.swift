//
//  MealProgressStatusView.swift
//  Toresyoku
//
//  Created by USER on 2024/08/06.
//

import SwiftUI
import SwiftData

struct MealProgressView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var mealContents: [MealContentModel]
    @Query private var profiles: [ProfileModel]
    @Query private var imageColor: [ImageColorModel]
    
    @State private var mealKcalProgress: Double = 0.0
    @State private var mealProteinProgress: Double = 0.0
    @State private var mealFatProgress: Double = 0.0
    @State private var mealCarbohydrateProgress: Double = 0.0
    
    @State private var remainingKcal: Double = 0.0
    @State private var remainingProtein: Double = 0.0
    @State private var remainingFat: Double = 0.0
    @State private var remainingCarbohydrate: Double = 0.0
    
    @Binding var theDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
            VStack(spacing: 5) {
                progressView(title: "カロリー", progress: mealKcalProgress, remaining: remainingKcal, unit: "Kcal")
                progressView(title: "たんぱく質", progress: mealProteinProgress, remaining: remainingProtein, unit: "g")
                progressView(title: "脂質", progress: mealFatProgress, remaining: remainingFat, unit: "g")
                progressView(title: "炭水化物", progress: mealCarbohydrateProgress, remaining: remainingCarbohydrate, unit: "g")
            }
            .padding(.bottom, 5)
            .background(colorManager(from: imageColor.first, opacity: 0.03))
            .onChange(of: refreshID) {
                calculateProgress()
            }
            .onAppear {
                refreshID = UUID()
                calculateProgress()
            }
        }
    
    @ViewBuilder
    private func progressView(title: String, progress: Double, remaining: Double, unit: String) -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(title)
                Text("\(String(format: "%.f", progress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remaining)) \(unit)")
            }
            .font(.title2)
            .padding(.horizontal)
            
            ZStack {
                Rectangle().foregroundStyle(.white)
                Rectangle()
                    .foregroundStyle(colorManager(from: imageColor.first, opacity: 1))
                    .scaleEffect(x: progress, y: 1.0, anchor: .leading)
                Rectangle().stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
        }
    }
}

extension MealProgressView {
    private func calculateProgress(target: Double, total: Double) -> (progress: Double, remaining: Double) {
        if target > 0 {
            let progress = min(total / target, 1.0)
            let remaining = max(target - total, 0)
            return (progress, remaining)
        } else {
            return (0.0, 0.0)
        }
    }
    private func calculateProgress() {
        guard let profile = profiles.first else {
            resetProgress()
            return
        }
        
        let filteredMealContents = mealContents.filter { mealContent in
            Calendar.current.isDate(mealContent.mealDate, inSameDayAs: theDate)
        }
        
        let totalKcal = filteredMealContents.reduce(0) { $0 + $1.mealKcal }
        (mealKcalProgress, remainingKcal) = calculateProgress(target: profile.targetMealKcal, total: totalKcal)
        
        let totalProtein = filteredMealContents.reduce(0) { $0 + $1.mealProtein }
        (mealProteinProgress, remainingProtein) = calculateProgress(target: profile.targetMealProtein, total: totalProtein)
        
        let totalFat = filteredMealContents.reduce(0) { $0 + $1.mealFat }
        (mealFatProgress, remainingFat) = calculateProgress(target: profile.targetMealFat, total: totalFat)
        
        let totalCarbohydrate = filteredMealContents.reduce(0) { $0 + $1.mealCarbohydrate }
        (mealCarbohydrateProgress, remainingCarbohydrate) = calculateProgress(target: profile.targetMealCarbohydrate, total: totalCarbohydrate)
    }
    
    private func resetProgress() {
        mealKcalProgress = 0.0
        remainingKcal = 0.0
        mealProteinProgress = 0.0
        remainingProtein = 0.0
        mealFatProgress = 0.0
        remainingFat = 0.0
        mealCarbohydrateProgress = 0.0
        remainingCarbohydrate = 0.0
    }
}

struct MealProgressView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MealProgressView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, ImageColorModel.self])
    }
}
