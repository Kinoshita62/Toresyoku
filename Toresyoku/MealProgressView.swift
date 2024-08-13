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

    @State private var MealKcalProgress: Double = 0.0
    @State private var MealProteinProgress: Double = 0.0
    @State private var MealFatProgress: Double = 0.0
    @State private var MealCarbohydrateProgress: Double = 0.0
    
    @State private var remainingKcal: Double = 0.0
    @State private var remainingProtein: Double = 0.0
    @State private var remainingFat: Double = 0.0
    @State private var remainingCarbohydrate: Double = 0.0

    
    var selectedDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("カロリー")
                Text("\(String(format: "%.f", MealKcalProgress * 100))%")
                    .font(.system(size: 25))
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingKcal)) Kcal")
                    .font(.system(size: 25))
            }
            .padding(.horizontal)
            ZStack {
                Rectangle().stroke(.gray)
                Rectangle()
                    .foregroundColor(.orange.opacity(0.2))
                    .scaleEffect(x: MealKcalProgress, y: 1.0, anchor: .leading)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("たんぱく質")
                Text("\(String(format: "%.f", MealProteinProgress * 100))%")
                    .font(.system(size: 25))
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingProtein)) g")
                    .font(.system(size: 25))
            }
            .padding(.horizontal)
            ZStack {
                Rectangle().stroke(.gray)
                Rectangle()
                    .foregroundColor(.orange.opacity(0.2))
                    .scaleEffect(x: MealProteinProgress, y: 1.0, anchor: .leading)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("脂質")
                Text("\(String(format: "%.f", MealFatProgress * 100))%")
                    .font(.system(size: 25))
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingFat)) g")
                    .font(.system(size: 25))
            }
            .padding(.horizontal)
            ZStack {
                Rectangle().stroke(.gray)
                Rectangle()
                    .foregroundColor(.orange.opacity(0.2))
                    .scaleEffect(x: MealFatProgress, y: 1.0, anchor: .leading)
            }
            .frame(width: 300, height: 20)
            
            HStack {
                Text("炭水化物")
                Text("\(String(format: "%.f", MealCarbohydrateProgress * 100))%")
                    .font(.system(size: 25))
                Spacer()
                Text("残り")
                Text("\(String(format: "%.f", remainingCarbohydrate)) g")
                    .font(.system(size: 25))
            }
            .padding(.horizontal)
            ZStack {
                Rectangle().stroke(.gray)
                Rectangle()
                    .foregroundColor(.orange.opacity(0.2))
                    .scaleEffect(x: MealCarbohydrateProgress, y: 1.0, anchor: .leading)
            }
            .frame(width: 300, height: 20)
        }
//            .background(Color.white)
        .onAppear(perform: {
            calculateMealKcalProgress()
        })
        .id(refreshID)
    }
    
    private func calculateMealKcalProgress() {
            guard let profile = profiles.first else {
                return
            }
            
            let targetKcal = profile.TargetMealKcal
            let filteredMealContents = mealContents.filter { mealContent in
                Calendar.current.isDate(mealContent.MealDate, inSameDayAs: selectedDate)
            }
            let totalKcal = filteredMealContents.reduce(0) { $0 + $1.MealKcal }
            if targetKcal > 0 {
                MealKcalProgress = min(totalKcal / targetKcal, 1.0)
                remainingKcal = max(targetKcal - totalKcal, 0)
            } else {
                MealKcalProgress = 0.0
                remainingKcal = 0.0
            }

            let targetProtein = profile.TargetMealProtein
            let totalProtein = filteredMealContents.reduce(0) { $0 + $1.MealProtein }
            if targetProtein > 0 {
                MealProteinProgress = min(totalProtein / targetProtein, 1.0)
                remainingProtein = max(targetProtein - totalProtein, 0)
            } else {
                MealProteinProgress = 0.0
                remainingProtein = 0.0
            }

            let targetFat = profile.TargetMealFat
            let totalFat = filteredMealContents.reduce(0) { $0 + $1.MealFat }
            if targetFat > 0 {
                MealFatProgress = min(totalFat / targetFat, 1.0)
                remainingFat = max(targetFat - totalFat, 0)
            } else {
                MealFatProgress = 0.0
                remainingFat = 0.0
            }

            let targetCarbohydrate = profile.TargetMealCarbohydrate
            let totalCarbohydrate = filteredMealContents.reduce(0) { $0 + $1.MealCarbohydrate }
            if targetCarbohydrate > 0 {
                MealCarbohydrateProgress = min(totalCarbohydrate / targetCarbohydrate, 1.0)
                remainingCarbohydrate = max(targetCarbohydrate - totalCarbohydrate, 0)
            } else {
                MealCarbohydrateProgress = 0.0
                remainingCarbohydrate = 0.0
            }
        }
}

struct MealProgressView_Previews: PreviewProvider {
    static var previews: some View {
        MealProgressView(selectedDate: Date(), refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self])
    }
}
