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
    @State private var UserTall: Double = 0.0
    @State private var UserWeight: Double = 0.0
    @State private var UserBMI: Double = 0.0
    @State private var UserFatPercentage: Double = 0.0
    @State private var UserLeanBodyMass: Double = 0.0
    @State private var UserMuscleMass: Double = 0.0
    
    @State private var TargetWeight: Double = 0.0
    @State private var TargetFatPercentage: Double = 0.0
    @State private var TargetMealKcal: Double = 0.0
    @State private var TargetMealProtein: Double = 0.0
    @State private var TargetMealFat: Double = 0.0
    @State private var TargetMealCarbohydrate: Double = 0.0
    
    @State private var ProteinRatio: Int = 3
    @State private var FatRatio: Int = 2
    @State private var CarbohydrateRatio: Int = 5
    
    @State var R: Double = 0
    @State var G: Double = 255
    @State var B: Double = 255
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
                TextField("", value: $UserTall, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
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
                TextField("", value: $UserWeight, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
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
                TextField("", value: $UserFatPercentage, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
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
                Text("\(UserBMI, specifier: "%.1f")")
                Spacer()
                Text("除脂肪体重")
                Text("\(UserLeanBodyMass, specifier: "%.1f")kg")
                Spacer()
                Text("筋肉量")
                Text("\(UserMuscleMass, specifier: "%.1f")kg")
                Spacer()
            }
            .foregroundColor(.gray)
            
            HStack {
                Text("目標体重")
                Spacer()
                TextField("", value: $TargetWeight, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("kg   ")
            }
            
            HStack {
                Text("目標体脂肪率")
                Spacer()
                TextField("", value: $TargetFatPercentage, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("%   ")
            }
            
            HStack {
                Text("目標摂取カロリー（一日あたり）")
                Spacer()
                TextField("", value: $TargetMealKcal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
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
                TextField("", value: $TargetMealProtein, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g    ")
            }
            
            HStack {
                Text("脂質の目標摂取量（一日あたり）")
                Spacer()
                TextField("", value: $TargetMealFat, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g    ")
            }
            
            HStack {
                Text("炭水化物の目標摂取量（一日あたり）")
                Spacer()
                TextField("", value: $TargetMealCarbohydrate, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
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
                red: ImageColor.first?.R ?? 0 / 255,
                green: ImageColor.first?.G ?? 255 / 255,
                blue: ImageColor.first?.B ?? 255 / 255,
                opacity: ImageColor.first?.A ?? 1
            ))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .onAppear {
            // profiles配列を日付でソートし、一番最新のデータを取得
            if let latestProfile = profiles.sorted(by: { $0.UserDataAddDate > $1.UserDataAddDate }).first {
                UserTall = latestProfile.UserTall
                UserWeight = latestProfile.UserWeight
                UserBMI = latestProfile.UserBMI
                UserFatPercentage = latestProfile.UserFatPercentage
                UserLeanBodyMass = latestProfile.UserLeanBodyMass
                UserMuscleMass = latestProfile.UserMuscleMass
                TargetWeight = latestProfile.TargetWeight
                TargetFatPercentage = latestProfile.TargetFatPercentage
                TargetMealKcal = latestProfile.TargetMealKcal
                TargetMealProtein = latestProfile.TargetMealProtein
                TargetMealFat = latestProfile.TargetMealFat
                TargetMealCarbohydrate = latestProfile.TargetMealCarbohydrate
            }
        }

    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateBMI() {
        guard UserTall > 0, UserWeight > 0 else {
            UserBMI = 0.0
            return
        }
        let heightInMeters = UserTall / 100
        UserBMI = round(UserWeight / (heightInMeters * heightInMeters) * 10)/10
    }
    
    private func calculateLeanBodyMass() {
        guard UserWeight > 0, UserFatPercentage > 0 else {
            UserLeanBodyMass = 0.0
            return
        }
        let fatAmount = UserWeight * (UserFatPercentage / 100)
        UserLeanBodyMass = round((UserWeight - fatAmount) * 10) / 10
    }
    
    private func calculateMuscleMass() {
        guard UserWeight > 0, UserFatPercentage > 0 else {
            UserMuscleMass = 0.0
            return
        }
        UserMuscleMass = round((UserLeanBodyMass / 2) * 10) / 10
    }
    
    private func calculate325() {
        guard TargetMealKcal > 0 else {
            TargetMealProtein = 0
            TargetMealFat = 0
            TargetMealCarbohydrate = 0
            return
        }
        TargetMealProtein = round((TargetMealKcal / 10 * 3 / 4) * 10 ) / 10
        TargetMealFat = round((TargetMealKcal / 10 * 2 / 9) * 10) / 10
        TargetMealCarbohydrate = round((TargetMealKcal / 10 * 5 / 4) * 10) / 10
    }
    
    private func calculate316() {
        guard TargetMealKcal > 0 else {
            TargetMealProtein = 0
            TargetMealFat = 0
            TargetMealCarbohydrate = 0
            return
        }
        TargetMealProtein = round((TargetMealKcal / 10 * 3 / 4) * 10 ) / 10
        TargetMealFat = round((TargetMealKcal / 10 * 1 / 9) * 10) / 10
        TargetMealCarbohydrate = round((TargetMealKcal / 10 * 6 / 4) * 10) / 10
    }
    
    private func addUpdateProfile() {
        // 既存のデータがあるか確認する
        if let existingProfile = profiles.first(where: { $0.UserDataAddDate == UserDataAddDate }) {
            // 既存のデータを更新する
            existingProfile.UserTall = UserTall
            existingProfile.UserWeight = UserWeight
            existingProfile.UserBMI = UserBMI
            existingProfile.UserFatPercentage = UserFatPercentage
            existingProfile.UserLeanBodyMass = UserLeanBodyMass
            existingProfile.UserMuscleMass = UserMuscleMass
            existingProfile.TargetWeight = TargetWeight
            existingProfile.TargetFatPercentage = TargetFatPercentage
            existingProfile.TargetMealKcal = TargetMealKcal
            existingProfile.TargetMealProtein = TargetMealProtein
            existingProfile.TargetMealFat = TargetMealFat
            existingProfile.TargetMealCarbohydrate = TargetMealCarbohydrate
        } else {
            // 新しいデータを挿入する
            let newProfile = ProfileModel(
                UserDataAddDate: UserDataAddDate,
                UserTall: UserTall,
                UserWeight: UserWeight,
                UserBMI: UserBMI,
                UserFatPercentage: UserFatPercentage,
                UserLeanBodyMass: UserLeanBodyMass,
                UserMuscleMass: UserMuscleMass,
                TargetWeight: TargetWeight,
                TargetFatPercentage: TargetFatPercentage,
                TargetMealKcal: TargetMealKcal,
                TargetMealProtein: TargetMealProtein,
                TargetMealFat: TargetMealFat,
                TargetMealCarbohydrate: TargetMealCarbohydrate)
            context.insert(newProfile)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
        refreshGraph = UUID()
    }

}

struct ProfileSettingView_Previews: PreviewProvider {
    @State static var refreshGraph = UUID()
    static var previews: some View {
        ProfileSettingView(refreshGraph: $refreshGraph)
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}

