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
            HStack {
                Text("カロリー")
                Text("\(String(format: "%.f", mealKcalProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingKcal)) Kcal")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                Rectangle()
                    .foregroundStyle(colorManager(from: imageColor.first, opacity: 1))
//                    .foregroundStyle(Color(
//                        red: imageColor.first?.imageColorRed ?? 0,
//                        green: imageColor.first?.imageColorGreen ?? 1,
//                        blue: imageColor.first?.imageColorBlue ?? 1,
//                        opacity: 1
//                    ))
                    .scaleEffect(x: mealKcalProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            
            HStack {
                Text("たんぱく質")
                Text("\(String(format: "%.f", mealProteinProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingProtein)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                Rectangle()
                    .foregroundStyle(colorManager(from: imageColor.first, opacity: 1))
//                    .foregroundStyle(Color(
//                        red: imageColor.first?.imageColorRed ?? 0,
//                        green: imageColor.first?.imageColorGreen ?? 1,
//                        blue: imageColor.first?.imageColorBlue ?? 1,
//                        opacity: 1
//                    ))
                    .scaleEffect(x: mealProteinProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("脂質")
                Text("\(String(format: "%.f", mealFatProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingFat)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                Rectangle()
                    .foregroundStyle(colorManager(from: imageColor.first, opacity: 1))
//                    .foregroundStyle(Color(
//                        red: imageColor.first?.imageColorRed ?? 0,
//                        green: imageColor.first?.imageColorGreen ?? 1,
//                        blue: imageColor.first?.imageColorBlue ?? 1,
//                        opacity: 1
//                    ))
                    .scaleEffect(x: mealFatProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("炭水化物")
                Text("\(String(format: "%.f", mealCarbohydrateProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingCarbohydrate)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                Rectangle()
                    .foregroundStyle(colorManager(from: imageColor.first, opacity: 1))
//                    .foregroundStyle(Color(
//                        red: imageColor.first?.imageColorRed ?? 0,
//                        green: imageColor.first?.imageColorGreen ?? 1,
//                        blue: imageColor.first?.imageColorBlue ?? 1,
//                        opacity: 1
//                    ))
                    .scaleEffect(x: mealCarbohydrateProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
        }
        .padding(.bottom, 5)
        .background(colorManager(from: imageColor.first, opacity: 0.03))
//        .background(Color(
//            red: imageColor.first?.imageColorRed ?? 0,
//            green: imageColor.first?.imageColorGreen ?? 1,
//            blue: imageColor.first?.imageColorBlue ?? 1,
//            opacity: 0.03
//        ))
        .onChange(of: refreshID) {
            calculateProgress()
        }
        .onAppear {
            refreshID = UUID()
            calculateProgress()
        }
    }
    
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
