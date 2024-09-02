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
    @Query private var imageColor: [ImageColorModel]
    
    @State private var UserDataAddDate: Date
    
    @State private var UserAge: String = ""
    @State private var UserSex: Int = 0
    @State private var UserBMR: String = ""
    
    @State private var UserTall: String = ""
    @State private var UserWeight: String = ""
    @State private var UserBMI: String = ""
    @State private var UserFatPercentage: String = ""
    @State private var UserLeanBodyMass: String = ""
    @State private var UserMuscleMass: String = ""
    
    @State private var UserConsumeKcal: String = ""
    
    @State private var TargetWeight: String = ""
    @State private var TargetFatPercentage: String = ""
    @State private var TargetMealKcal: String = ""
    @State private var TargetMealProtein: String = ""
    @State private var TargetMealFat: String = ""
    @State private var TargetMealCarbohydrate: String = ""

    @State private var activityLevel: Int = 2

    @State private var dateSelectPresented: Bool = false
    @State private var activityLevelExplanationPresented: Bool = false
    @State private var targetKcalGuidePresented: Bool = false
    
    @Binding var theDate: Date
    
    init(theDate: Binding<Date>) {
            self._theDate = theDate
            self._UserDataAddDate = State(initialValue: theDate.wrappedValue)
        }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("基本情報")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray .opacity(0.05))
                    VStack {
                        HStack {
                            Text("年齢")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserAge)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("歳    ")
                                .font(.title3)
                        }
                        .onChange(of: UserAge) {
                            calculateBMR()
                        }
                        .padding(5)
                        
                        HStack {
                            Text("性別")
                                .font(.title3)
                            Spacer()
                            Picker("", selection: $UserSex) {
                                Text("男性").tag(0)
                                    .font(.title3)
                                Text("女性").tag(1)
                                    .font(.title3)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 170, height: 50)
                        }
                        .padding(5)
                        
                        
                        
                        HStack {
                            Text("身長")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserTall)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("cm  ")
                                .font(.title3)
                        }
                        .onChange(of: UserTall) {
                            calculateBMI()
                            calculateBMR()
                        }
                        .padding(5)
                        
                        
                        HStack {
                            Text("体重")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserWeight)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("kg   ")
                                .font(.title3)
                        }
                        .onChange(of: UserWeight) {
                            calculateBMI()
                            calculateLeanBodyMass()
                            calculateMuscleMass()
                            calculateBMR()
                        }
                        .padding(5)
                        
                        HStack {
                            Text("体脂肪率")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserFatPercentage)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("%   ")
                                .font(.title3)
                        }
                        .onChange(of: UserFatPercentage) {
                            calculateLeanBodyMass()
                            calculateMuscleMass()
                        }
                        .padding(5)
                        
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
                        
                    }
                    .padding(5)
                }
                
                Text("目標設定")
                    .font(.title2)
                    .bold()
                    .padding(.top, 15)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 0.03
                        ))
                    VStack {
                        HStack {
                            Text("目標体重")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $TargetWeight)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("kg   ")
                                .font(.title3)
                        }
                        .padding(5)
                        
                        HStack {
                            Text("目標体脂肪率")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $TargetFatPercentage)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("%   ")
                                .font(.title3)
                        }
                        .padding(5)
                        
                    }
                    .padding(5)
                }
                
                Text("身体情報")
                    .font(.title2)
                    .bold()
                    .padding(.top, 15)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray .opacity(0.05))
                    VStack {
                        HStack {
                            Text("基礎代謝量")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserBMR)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 90)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .onChange(of: UserBMR) {
                                    calculateConsumeKcal()
                                }
                            Text("kcal")
                                .font(.title3)
                        }
                        .padding(5)
                        
                        HStack {
                            Text("活動レベル")
                                .font(.title3)
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title3)
                                .onTapGesture {
                                    activityLevelExplanationPresented = true
                                    hideKeyboard()
                                }
                                .popover(isPresented: $activityLevelExplanationPresented) {
                                    activityLevelExplanationView()
                                        .presentationCompactAdaptation(PresentationAdaptation.popover)
                                }
                            
                            Spacer()
                            Picker("", selection: $activityLevel) {
                                Text("低い").tag(0)
                                    .font(.title3)
                                Text("やや低い").tag(1)
                                    .font(.title3)
                                Text("普通").tag(2)
                                    .font(.title3)
                                Text("やや高い").tag(3)
                                    .font(.title3)
                                Text("高い").tag(4)
                                    .font(.title3)
                            }
                            .pickerStyle(.menu)
                            .frame(width: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing, 25)
                            .onChange(of: activityLevel) {
                                calculateConsumeKcal()
                            }
                        }
                        .padding(5)
                        
                        HStack {
                            Text("1日の消費カロリー")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $UserConsumeKcal)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 90)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("kcal")
                                .font(.title3)
                        }
                        .padding(5)
                    }
                    .padding(5)
                }
                
                Text("1日の目標設定")
                    .font(.title2)
                    .bold()
                    .padding(.top, 15)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(
                            red: imageColor.first?.R ?? 0,
                            green: imageColor.first?.G ?? 1,
                            blue: imageColor.first?.B ?? 1,
                            opacity: 0.03
                        ))
                    VStack {
                        HStack {
                            Text("目標摂取カロリー")
                                .font(.title3)
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title3)
                                .onTapGesture {
                                    targetKcalGuidePresented = true
                                    hideKeyboard()
                                }
                                .popover(isPresented: $targetKcalGuidePresented) {
                                    TargetKcalGuideView()
                                        .presentationCompactAdaptation(PresentationAdaptation.popover)
                                }
                            Spacer()
                            TextField("", text: $TargetMealKcal)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 90)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("kcal")
                                .font(.title3)
                        }
                        .padding(5)
                        .padding(.bottom, 10)
                        
                        Text("内訳を自動入力（たんぱく質：脂質：炭水化物）")
                        HStack {
                            Spacer()
                            Button("3：3：4") {
                                calculate334()
                            }
                            .padding(5)
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            Spacer()
                            Button("3：2：5") {
                                calculate325()
                            }
                            .padding(5)
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            Spacer()
                            Button("3：1：6") {
                                calculate316()
                            }
                            .padding(5)
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            Spacer()
                        }
                        
                        HStack {
                            Text("目標たんぱく質摂取量")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $TargetMealProtein)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("g    ")
                                .font(.title3)
                        }
                        .padding(5)
                        
                        HStack {
                            Text("目標脂質摂取量")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $TargetMealFat)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("g    ")
                                .font(.title3)
                        }
                        .padding(5)
                        
                        HStack {
                            Text("目標炭水化物摂取量")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $TargetMealCarbohydrate)
                                .font(.title3)
                                .multilineTextAlignment(.trailing)
                                .padding(4)
                                .frame(width: 80)
                                .background(.white, in: .rect(cornerRadius: 6))
                                .foregroundColor(.black)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("g    ")
                                .font(.title3)
                            
                        }
                        .padding(5)
                    }
                    .padding(5)
                }
                .padding(.bottom, 30)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("決定") {
                            hideKeyboard()
                        }
                        .foregroundColor(.black)
                    }
                }
                
                HStack {
                    Spacer()
                    Button("戻る") {
                        dismiss()
                    }
                    .font(.title3)
                    .bold()
                    .padding()
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
                    .background(Color.gray .opacity(0.8))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    Spacer()
                    Button("決定") {
                        addUpdateProfile()
                        dismiss()
                    }
                    .font(.title3)
                    .bold()
                    .padding()
                    .frame(width: 150, height: 35)
                    .foregroundColor(.black)
                    .background(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: imageColor.first?.A ?? 0.2
                    ))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .onChange(of: theDate) {
                            UserDataAddDate = theDate
                        }
                .onAppear {
                    if let latestProfile = profiles.first {
                        UserAge = String(latestProfile.UserAge)
                        UserSex = latestProfile.UserSex
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
        }
    }
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateBMI() {
        let userTall = Double(UserTall) ?? 0
        let userWeight = Double(UserWeight) ?? 0
        guard userTall > 0, userWeight > 0 else {
            UserBMI = ""
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
    
    
    
    
    
    
    
    private func calculateBMR() {
        let weight = Double(UserWeight) ?? 0
        let tall = Double(UserTall) ?? 0
        let age = Double(UserAge) ?? 0
        guard weight > 0, tall > 0, age > 0 else {
            UserBMR = ""
            return
        }
        if UserSex == 0 {
            UserBMR = String(format: "%.f",88.362 + (13.397 * weight) + (4.799 * tall) - (5.677 * age))
        } else if UserSex == 1 {
            UserBMR = String(format: "%.f",447.593 + (9.247 * weight) + (3.098 * tall) - (4.33 * age))
        } else {
            UserBMR = ""
            return
        }
    }
    
    
    private func calculateConsumeKcal() {
        let userBMR = Double(UserBMR) ?? 0
        guard userBMR > 0 else {
            return
        }
        if activityLevel == 0 {
            UserConsumeKcal = String(format: "%.f", userBMR * 1.2)
        } else if activityLevel == 1 {
            UserConsumeKcal = String(format: "%.f", userBMR * 1.375)
        } else if activityLevel == 2 {
            UserConsumeKcal = String(format: "%.f", userBMR * 1.55)
        } else if activityLevel == 3 {
            UserConsumeKcal = String(format: "%.f", userBMR * 1.725)
        } else if activityLevel == 4 {
            UserConsumeKcal = String(format: "%.f", userBMR * 1.9)
        } else {
            return
        }
    }
    
    
    private func calculate334() {
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        guard targetMealKcal > 0 else {
            TargetMealProtein = ""
            TargetMealFat = ""
            TargetMealCarbohydrate = ""
            return
        }
        TargetMealProtein = String(round((targetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        TargetMealFat = String(round((targetMealKcal / 10 * 3 / 9) * 10) / 10)
        TargetMealCarbohydrate = String(round((targetMealKcal / 10 * 4 / 4) * 10) / 10)
    }
    
    
    private func calculate325() {
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        guard targetMealKcal > 0 else {
            TargetMealProtein = ""
            TargetMealFat = ""
            TargetMealCarbohydrate = ""
            return
        }
        TargetMealProtein = String(round((targetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        TargetMealFat = String(round((targetMealKcal / 10 * 2 / 9) * 10) / 10)
        TargetMealCarbohydrate = String(round((targetMealKcal / 10 * 5 / 4) * 10) / 10)
    }
    
    private func calculate316() {
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        guard targetMealKcal > 0 else {
            TargetMealProtein = ""
            TargetMealFat = ""
            TargetMealCarbohydrate = ""
            return
        }
        TargetMealProtein = String(round((targetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        TargetMealFat = String(round((targetMealKcal / 10 * 1 / 9) * 10) / 10)
        TargetMealCarbohydrate = String(round((targetMealKcal / 10 * 6 / 4) * 10) / 10)
    }
    
    private func addUpdateProfile() {
        let userAge = Int(UserAge) ?? 0
        let userSex = UserSex
        let userTall = Double(UserTall) ?? 0
        let userWeight = Double(UserWeight) ?? 0
        let userBMI = Double(UserBMI) ?? 0
        let userFatPercentage = Double(UserFatPercentage) ?? 0
        let userLeanBodyMass = Double(UserLeanBodyMass) ?? 0
        let userMuscleMass = Double(UserMuscleMass) ?? 0
        let userConsumeKcal = Double(UserConsumeKcal) ?? 0
        let userBMR = Double(UserBMR) ?? 0
        let targetWeight = Double(TargetWeight) ?? 0
        let targetFatPercentage = Double(TargetFatPercentage) ?? 0
        let targetMealKcal = Double(TargetMealKcal) ?? 0
        let targetMealProtein = Double(TargetMealProtein) ?? 0
        let targetMealFat = Double(TargetMealFat) ?? 0
        let targetMealCarbohydrate = Double(TargetMealCarbohydrate) ?? 0
        if let existingProfile = profiles.first {
            existingProfile.UserDataAddDate = UserDataAddDate
            existingProfile.UserAge = userAge
            existingProfile.UserSex = userSex
            existingProfile.UserTall = userTall
            existingProfile.UserWeight = userWeight
            existingProfile.UserBMI = userBMI
            existingProfile.UserFatPercentage = userFatPercentage
            existingProfile.UserLeanBodyMass = userLeanBodyMass
            existingProfile.UserMuscleMass = userMuscleMass
            existingProfile.UserConsumeKcal = userConsumeKcal
            existingProfile.UserBMR = userBMR
            existingProfile.TargetWeight = targetWeight
            existingProfile.TargetFatPercentage = targetFatPercentage
            existingProfile.TargetMealKcal = targetMealKcal
            existingProfile.TargetMealProtein = targetMealProtein
            existingProfile.TargetMealFat = targetMealFat
            existingProfile.TargetMealCarbohydrate = targetMealCarbohydrate
        } else {
            let newProfile = ProfileModel(
                UserDataAddDate: UserDataAddDate,
                UserAge: userAge,
                UserSex: userSex,
                UserTall: userTall,
                UserWeight: userWeight,
                UserBMI: userBMI,
                UserFatPercentage: userFatPercentage,
                UserLeanBodyMass: userLeanBodyMass,
                UserMuscleMass: userMuscleMass,
                UserConsumeKcal: userConsumeKcal,
                UserBMR: userBMR,
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
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }

}

struct DateSelectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var UserDataAddDate: Date
    var body: some View {
        DatePicker("", selection: $UserDataAddDate, displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
            .onChange(of: UserDataAddDate) {
                dismiss()
            }
    }
}

struct activityLevelExplanationView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query private var imageColor: [ImageColorModel]
    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: 0.05
                    ))
                    
                VStack(alignment: .leading) {
                    Text("•低い")
                        .padding(.leading, 30)
                    Text("座っていることがほとんど")
                        .padding(.horizontal)
                        
                    Text("•やや低い")
                        .padding(.top, 5)
                        .padding(.leading, 30)
                    Text("座っていることが多いが、週1、2回は軽い運動をする")
                        .padding(.horizontal)
                        
                    Text("•普通")
                        .padding(.top, 5)
                        .padding(.leading, 30)
                    Text("通勤や買い物、家事などで一日中動いている、または週2、3回激しい運動をする")
                        .padding(.horizontal)
                
                    Text("•やや高い")
                        .padding(.top, 5)
                        .padding(.leading, 30)
                    Text("週4、5回激しい運動をする")
                        .padding(.horizontal)
                         
                    Text("•高い")
                        .padding(.top, 5)
                        .padding(.leading, 30)
                    Text("毎日のように非常に激しい運動をする")
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Spacer()
                        Text("閉じる")
                            .frame(width: 100, height: 25)
                            .background(Color.gray .opacity(0.8))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                    }
                }
            }
            .frame(height: 400)
    }
}

struct TargetKcalGuideView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query private var imageColor: [ImageColorModel]
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(
                    red: imageColor.first?.R ?? 0,
                    green: imageColor.first?.G ?? 1,
                    blue: imageColor.first?.B ?? 1,
                    opacity: 0.05
                ))
            VStack(alignment: .leading) {
                Text("増量するには摂取カロリーが消費カロリーを上回る必要があります")
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                Text("消費カロリー ＋ ２００〜５００kcalを目安に摂取カロリーを設定しましょう")
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                Text("減量するには摂取カロリーが消費カロリーを下回る必要があります")
                    .padding(.horizontal, 5)
                    .padding(.top, 20)
                Text("消費カロリー ー ３００〜7００kcalを目安に摂取カロリーを設定しましょう")
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                Text("（ただし、基礎代謝量を下回る設定は控えましょう）")
                    .padding(.horizontal, 5)
                
                HStack {
                    Spacer()
                    Text("閉じる")
                        .frame(width: 100, height: 25)
                        .background(Color.gray .opacity(0.8))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                }
                
            }
        }
        .frame(height: 400)
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        ProfileSettingView(theDate: $theDate)
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}

