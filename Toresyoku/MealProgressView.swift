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

    @State private var MealKcalProgress: Double = 0.0
    @State private var MealProteinProgress: Double = 0.0
    @State private var MealFatProgress: Double = 0.0
    @State private var MealCarbohydrateProgress: Double = 0.0
    
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
                Text("\(String(format: "%.f", MealKcalProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingKcal)) Kcal")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                Rectangle()
                .foregroundColor(Color(
                    red: imageColor.first?.R ?? 0,
                    green: imageColor.first?.G ?? 1,
                    blue: imageColor.first?.B ?? 1,
                    opacity: 1
                ))
                .scaleEffect(x: MealKcalProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            
            HStack {
                Text("たんぱく質")
                Text("\(String(format: "%.f", MealProteinProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingProtein)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                Rectangle()
                    .foregroundColor(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: 1
                    ))
                    .scaleEffect(x: MealProteinProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("脂質")
                Text("\(String(format: "%.f", MealFatProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingFat)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                Rectangle()
                    .foregroundColor(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: 1
                    ))
                    .scaleEffect(x: MealFatProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("炭水化物")
                Text("\(String(format: "%.f", MealCarbohydrateProgress * 100))%")
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingCarbohydrate)) g")
            }
            .font(.title2)
            .padding(.horizontal)
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                Rectangle()
                    .foregroundColor(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: 1
                    ))
                    .scaleEffect(x: MealCarbohydrateProgress, y: 1.0, anchor: .leading)
                Rectangle()
                    .stroke(.gray)
            }
            .frame(width: 300, height: 20)
        }
        .padding(.bottom, 5)
        .background(Color(
            red: imageColor.first?.R ?? 0,
            green: imageColor.first?.G ?? 1,
            blue: imageColor.first?.B ?? 1,
            opacity: 0.03
        ))
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
            Calendar.current.isDate(mealContent.MealDate, inSameDayAs: theDate)
        }
        
        let totalKcal = filteredMealContents.reduce(0) { $0 + $1.MealKcal }
        (MealKcalProgress, remainingKcal) = calculateProgress(target: profile.TargetMealKcal, total: totalKcal)

        let totalProtein = filteredMealContents.reduce(0) { $0 + $1.MealProtein }
        (MealProteinProgress, remainingProtein) = calculateProgress(target: profile.TargetMealProtein, total: totalProtein)

        let totalFat = filteredMealContents.reduce(0) { $0 + $1.MealFat }
        (MealFatProgress, remainingFat) = calculateProgress(target: profile.TargetMealFat, total: totalFat)

        let totalCarbohydrate = filteredMealContents.reduce(0) { $0 + $1.MealCarbohydrate }
        (MealCarbohydrateProgress, remainingCarbohydrate) = calculateProgress(target: profile.TargetMealCarbohydrate, total: totalCarbohydrate)
    }
    
    private func resetProgress() {
        MealKcalProgress = 0.0
        remainingKcal = 0.0
        MealProteinProgress = 0.0
        remainingProtein = 0.0
        MealFatProgress = 0.0
        remainingFat = 0.0
        MealCarbohydrateProgress = 0.0
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
