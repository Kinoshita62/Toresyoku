//
//  ProfileSettingView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct ProfileSettingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var profiles: [ProfileModel]
    @Query private var ImageColor: [ImageColorModel]
    
    @State private var UserDataAddDate: Date = Date()
    @State private var UserTall: String = ""
    @State private var UserWeight: String = ""
    @State private var UserBMI: String = ""
    @State private var UserFatPercentage: String = ""
    @State private var UserLeanBodyMass: String = ""
    @State private var UserMuscleMass: String = ""
    
    @State private var TargetWeight: String = ""
    @State private var TargetFatPercentage: String = ""
    @State private var TargetMealKcal: String = ""
    @State private var TargetMealProtein: String = ""
    @State private var TargetMealFat: String = ""
    @State private var TargetMealCarbohydrate: String = ""
    
    @State private var ProteinRatio: Int = 3
    @State private var FatRatio: Int = 2
    @State private var CarbohydrateRatio: Int = 5
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 1
    
    @Binding var refreshGraph: UUID
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                DatePicker("", selection: $UserDataAddDate, displayedComponents: [.date])
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                Text("時点")
            }
            
            HStack {
                Text("身長")
                Spacer()
                TextField("", text: $UserTall)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("cm  ")
            }
            .onChange(of: UserTall) {
                calculateBMI()
            }
            
            
            HStack {
                Text("体重")
                Spacer()
                TextField("", text: $UserWeight)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("kg   ")
            }
            .onChange(of: UserWeight) {
                calculateBMI()
                calculateLeanBodyMass()
                calculateMuscleMass()
            }
            
            HStack {
                Text("体脂肪率")
                Spacer()
                TextField("", text: $UserFatPercentage)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("%    ")
            }
            .onChange(of: UserFatPercentage) {
                calculateLeanBodyMass()
                calculateMuscleMass()
            }
            
            HStack {
                Spacer()
                Text("BMI")
                Text(UserBMI)
                Spacer()
                Text("除脂肪体重")
                Text(UserLeanBodyMass)
                Spacer()
                Text("筋肉量")
                Text(UserMuscleMass)
                Spacer()
            }
            .foregroundColor(.gray)
            
            HStack {
                Text("目標体重")
                Spacer()
                TextField("", text: $TargetWeight)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("kg   ")
            }
            
            HStack {
                Text("目標体脂肪率")
                Spacer()
                TextField("", text: $TargetFatPercentage)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("%   ")
            }
            
            HStack {
                Text("目標摂取カロリー（一日あたり）")
                Spacer()
                TextField("", text: $TargetMealKcal)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("kcal")
            }
            
            HStack {
                Spacer()
                Text("PFCを自動計算")
                    .foregroundColor(.gray)
                Button("3：2：5") {
                    calculate325()
                }
                .padding(5)
                .foregroundColor(Color("Text"))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                Button("3：1：6") {
                    calculate316()
                }
                .padding(5)
                .foregroundColor(Color("Text"))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            HStack {
                Text("たんぱく質の目標摂取量（一日あたり）")
                Spacer()
                TextField("", text: $TargetMealProtein)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g    ")
            }
            
            HStack {
                Text("脂質の目標摂取量（一日あたり）")
                Spacer()
                TextField("", text: $TargetMealFat)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g    ")
            }
            
            HStack {
                Text("炭水化物の目標摂取量（一日あたり）")
                Spacer()
                TextField("", text: $TargetMealCarbohydrate)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g    ")
                    
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("決定") {
                        hideKeyboard()
                    }
                    .foregroundColor(.black)
                }
            }
            
            Button("決定") {
                addUpdateProfile()
                refreshGraph = UUID()
                dismiss()
            }
            .padding()
            .frame(width: 200, height: 35)
            .foregroundColor(.black)
            .background(Color(
                red: ImageColor.first?.R ?? 0,
                green: ImageColor.first?.G ?? 1,
                blue: ImageColor.first?.B ?? 1,
                opacity: ImageColor.first?.A ?? 1
            ))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .onAppear {
            // profiles配列を日付でソートし、一番最新のデータを取得
            if let latestProfile = profiles.sorted(by: { $0.UserDataAddDate > $1.UserDataAddDate }).first {
                UserTall = String(latestProfile.UserTall)
                UserWeight = String(latestProfile.UserWeight)
                UserBMI = String(latestProfile.UserBMI)
                UserFatPercentage = String(latestProfile.UserFatPercentage)
                UserLeanBodyMass = String(latestProfile.UserLeanBodyMass)
                UserMuscleMass = String(latestProfile.UserMuscleMass)
                TargetWeight = String(latestProfile.TargetWeight)
                TargetFatPercentage = String(latestProfile.TargetFatPercentage)
                TargetMealKcal = String(latestProfile.TargetMealKcal)
                TargetMealProtein = String(latestProfile.TargetMealProtein)
                TargetMealFat = String(latestProfile.TargetMealFat)
                TargetMealCarbohydrate = String(latestProfile.TargetMealCarbohydrate)
            }
        }

    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateBMI() {
        let userTall = Double(UserTall) ?? 0
        let userWeight = Double(UserWeight) ?? 0
        guard userTall > 0, userWeight > 0 else {
            UserBMI = "0.0"
            return
        }
        let heightInMeters = userTall / 100
        UserBMI = String(round(userWeight / (heightInMeters * heightInMeters) * 10) / 10)


    }
    
    private func calculateLeanBodyMass() {
        let userWeight = Double(UserWeight) ?? 0
        let userFatPercentage = Double(UserFatPercentage) ?? 0
        
        guard userWeight > 0, userFatPercentage > 0 else {
            UserLeanBodyMass = "0.0"
            return
        }
        let fatAmount = userWeight * (userFatPercentage / 100)
        UserLeanBodyMass = String(round((userWeight - fatAmount) * 10) / 10)
    }
    
    private func calculateMuscleMass() {
        let userWeight = Double(UserWeight) ?? 0
        let userFatPercentage = Double(UserFatPercentage) ?? 0
        let userLeanBodyMass = Double(UserLeanBodyMass) ?? 0
        guard userWeight > 0, userFatPercentage > 0 else {
            UserMuscleMass = "0.0"
            return
        }
        UserMuscleMass = String(round((userLeanBodyMass / 2) * 10) / 10)
    }
    
    private func calculate325() {
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        guard targetMealKcal > 0 else {
            TargetMealProtein = "0"
            TargetMealFat = "0"
            TargetMealCarbohydrate = "0"
            return
        }
        TargetMealProtein = String(round((targetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        TargetMealFat = String(round((targetMealKcal / 10 * 2 / 9) * 10) / 10)
        TargetMealCarbohydrate = String(round((targetMealKcal / 10 * 5 / 4) * 10) / 10)
    }
    
    private func calculate316() {
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        guard targetMealKcal > 0 else {
            TargetMealProtein = "0"
            TargetMealFat = "0"
            TargetMealCarbohydrate = "0"
            return
        }
        TargetMealProtein = String(round((targetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        TargetMealFat = String(round((targetMealKcal / 10 * 1 / 9) * 10) / 10)
        TargetMealCarbohydrate = String(round((targetMealKcal / 10 * 6 / 4) * 10) / 10)
    }
    
    private func addUpdateProfile() {
        let userTall = Double(UserTall) ?? 0
        let userWeight = Double(UserWeight) ?? 0
        let userBMI = Double(UserBMI) ?? 0
        let userFatPercentage = Double(UserFatPercentage) ?? 0
        let userLeanBodyMass = Double(UserLeanBodyMass) ?? 0
        let userMuscleMass = Double(UserMuscleMass) ?? 0
        let targetWeight = Double(TargetWeight) ?? 0
        let targetFatPercentage = Double(TargetFatPercentage) ?? 0
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        let targetMealProtein = Double(TargetMealProtein) ?? 0
        let targetMealFat = Double(TargetMealFat) ?? 0
        let targetMealCarbohydrate = Double(TargetMealCarbohydrate) ?? 0
        // 既存のデータがあるか確認する
        if let existingProfile = profiles.first(where: { $0.UserDataAddDate == UserDataAddDate }) {
            // 既存のデータを更新する
            existingProfile.UserTall = userTall
            existingProfile.UserWeight = userWeight
            existingProfile.UserBMI = userBMI
            existingProfile.UserFatPercentage = userFatPercentage
            existingProfile.UserLeanBodyMass = userLeanBodyMass
            existingProfile.UserMuscleMass = userMuscleMass
            existingProfile.TargetWeight = targetWeight
            existingProfile.TargetFatPercentage = targetFatPercentage
            existingProfile.TargetMealKcal = targetMealKcal
            existingProfile.TargetMealProtein = targetMealProtein
            existingProfile.TargetMealFat = targetMealFat
            existingProfile.TargetMealCarbohydrate = targetMealCarbohydrate
        } else {
            // 新しいデータを挿入する
            let newProfile = ProfileModel(
                UserDataAddDate: UserDataAddDate,
                UserTall: userTall,
                UserWeight: userWeight,
                UserBMI: userBMI,
                UserFatPercentage: userFatPercentage,
                UserLeanBodyMass: userLeanBodyMass,
                UserMuscleMass: userMuscleMass,
                TargetWeight: targetWeight,
                TargetFatPercentage: targetFatPercentage,
                TargetMealKcal: targetMealKcal,
                TargetMealProtein: targetMealProtein,
                TargetMealFat: targetMealFat,
                TargetMealCarbohydrate: targetMealCarbohydrate)
            context.insert(newProfile)
        }
        do {
            try context.save()
            refreshGraph = UUID()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }

}

struct ProfileSettingView_Previews: PreviewProvider {
    @State static var refreshGraph = UUID()
    static var previews: some View {
        ProfileSettingView(refreshGraph: $refreshGraph)
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}

