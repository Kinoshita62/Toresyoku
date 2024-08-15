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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var UserTall: Double = 0.0
    @State private var UserWeight: Double = 0.0
    @State private var UserBMI: Double = 0.0
    @State private var UserFatPercentage: Double = 0.0
    @State private var UserLeanBodyMass: Double = 0.0
    @State private var UserMuscleMass: Double = 0.0
    
    @State private var TargetWeight: Double = 0.0
    @State private var TargetMealKcal: Double = 0.0
    @State private var TargetMealProtein: Double = 0.0
    @State private var TargetMealFat: Double = 0.0
    @State private var TargetMealCarbohydrate: Double = 0.0
    
    @State private var ProteinRatio: Int = 3
    @State private var FatRatio: Int = 2
    @State private var CarbohydrateRatio: Int = 5
    
    @Query private var profiles: [ProfileModel]
    
    var body: some View {
        VStack {
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
                Text("cm   ")
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
                Text("%   ")
            }
            .onChange(of: UserFatPercentage) {
                calculateLeanBodyMass()
                calculateMuscleMass()
            }
            
            HStack {
                Text("BMI")
                Spacer()
                TextField("", value: $UserBMI, format: .number)
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
                Text("       ")
            }
            
            HStack {
                Text("除脂肪体重")
                Spacer()
                TextField("", value: $UserLeanBodyMass, format: .number)
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
                Text("筋肉量")
                Spacer()
                TextField("", value: $UserMuscleMass, format: .number)
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
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(width: 200, height: 35)
            .foregroundColor(.black)
            .background(Color(red: 0/255, green: 255/255, blue: 255/255))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .onAppear {
            if let profile = profiles.first {
                UserTall = profile.UserTall
                UserWeight = profile.UserWeight
                UserBMI = profile.UserBMI
                UserFatPercentage = profile.UserFatPercentage
                UserLeanBodyMass = profile.UserLeanBodyMass
                UserMuscleMass = profile.UserMuscleMass
                TargetWeight = profile.TargetWeight
                TargetMealKcal = TargetMealKcal
                TargetMealProtein = profile.TargetMealProtein
                TargetMealFat = profile.TargetMealFat
                TargetMealCarbohydrate = profile.TargetMealCarbohydrate
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
        if let profile = profiles.first {
            profile.UserTall = UserTall
            profile.UserWeight = UserWeight
            profile.UserBMI = UserBMI
            profile.UserFatPercentage = UserFatPercentage
            profile.UserLeanBodyMass = UserLeanBodyMass
            profile.UserMuscleMass = UserMuscleMass
            profile.TargetWeight = TargetWeight
            profile.TargetMealKcal = TargetMealKcal
            profile.TargetMealProtein = TargetMealProtein
            profile.TargetMealFat = TargetMealFat
            profile.TargetMealCarbohydrate = TargetMealCarbohydrate
        } else {
            let newProfile = ProfileModel(
                UserTall: UserTall,
                UserWeight: UserWeight,
                UserBMI: UserBMI,
                UserFatPercentage: UserFatPercentage,
                UserLeanBodyMass: UserLeanBodyMass,
                UserMuscleMass: UserMuscleMass,
                TargetWeight: TargetWeight,
                TargetMealKcal: TargetMealKcal,
                TargetMealProtein: TargetMealProtein,
                TargetMealFat: TargetMealFat,
                TargetMealCarbohydrate: TargetMealCarbohydrate)
            context.insert(newProfile)
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView()
            .modelContainer(for: ProfileModel.self/*, inMemory: true*/)
    }
}

