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
    
    @State private var newUserDataAddDate: Date
    
    @State private var newUserAge: String = ""
    @State private var newUserSex: Int = 0
    @State private var newUserBMR: String = ""
    
    @State private var newUserTall: String = ""
    @State private var newUserWeight: String = ""
    @State private var newUserBMI: String = ""
    @State private var newUserFatPercentage: String = ""
    @State private var newUserLeanBodyMass: String = ""
    @State private var newUserMuscleMass: String = ""
    
    @State private var newUserConsumeKcal: String = ""
    
    @State private var newTargetWeight: String = ""
    @State private var newTargetFatPercentage: String = ""
    @State private var newTargetMealKcal: String = ""
    @State private var newTargetMealProtein: String = ""
    @State private var newTargetMealFat: String = ""
    @State private var newTargetMealCarbohydrate: String = ""

    @State private var newUserActivityLevel: Int = 2

    @State private var dateSelectPresented: Bool = false
    @State private var activityLevelExplanationPresented: Bool = false
    @State private var targetKcalGuidePresented: Bool = false
    
    @Binding var theDate: Date
    
    init(theDate: Binding<Date>) {
            self._theDate = theDate
            self._newUserDataAddDate = State(initialValue: theDate.wrappedValue)
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
                            TextField("", text: $newUserAge)
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
                        .onChange(of: newUserAge) {
                            calculateBMR()
                        }
                        .padding(5)
                        
                        HStack {
                            Text("性別")
                                .font(.title3)
                            Spacer()
                            Picker("", selection: $newUserSex) {
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
                            TextField("", text: $newUserTall)
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
                        .onChange(of: newUserTall) {
                            calculateBMI()
                            calculateBMR()
                        }
                        .padding(5)
                        
                        
                        HStack {
                            Text("体重")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $newUserWeight)
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
                        .onChange(of: newUserWeight) {
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
                            TextField("", text: $newUserFatPercentage)
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
                        .onChange(of: newUserFatPercentage) {
                            calculateLeanBodyMass()
                            calculateMuscleMass()
                        }
                        .padding(5)
                        
                        HStack {
                            Spacer()
                            Text("BMI")
                            Text(newUserBMI)
                            Spacer()
                            Text("除脂肪体重")
                            Text(newUserLeanBodyMass)
                            Spacer()
                            Text("筋肉量")
                            Text(newUserMuscleMass)
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
                            TextField("", text: $newTargetWeight)
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
                            TextField("", text: $newTargetFatPercentage)
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
                            TextField("", text: $newUserBMR)
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
                                .onChange(of: newUserBMR) {
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
                            Picker("", selection: $newUserActivityLevel) {
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
                            .onChange(of: newUserActivityLevel) {
                                calculateConsumeKcal()
                            }
                        }
                        .padding(5)
                        
                        HStack {
                            Text("1日の消費カロリー")
                                .font(.title3)
                            Spacer()
                            TextField("", text: $newUserConsumeKcal)
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
                            TextField("", text: $newTargetMealKcal)
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
                            TextField("", text: $newTargetMealProtein)
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
                            TextField("", text: $newTargetMealFat)
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
                            TextField("", text: $newTargetMealCarbohydrate)
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
                            newUserDataAddDate = theDate
                        }
                .onAppear {
                    if let latestProfile = profiles.first {
                        newUserAge = String(latestProfile.userAge)
                        newUserSex = latestProfile.userSex
                        newUserTall = String(latestProfile.userTall)
                        newUserWeight = String(latestProfile.userWeight)
                        newUserBMI = String(latestProfile.userBMI)
                        newUserFatPercentage = String(latestProfile.userFatPercentage)
                        newUserLeanBodyMass = String(latestProfile.userLeanBodyMass)
                        newUserMuscleMass = String(latestProfile.userMuscleMass)
                        newTargetWeight = String(latestProfile.targetWeight)
                        newTargetFatPercentage = String(latestProfile.targetFatPercentage)
                        newTargetMealKcal = String(latestProfile.targetMealKcal)
                        newTargetMealProtein = String(latestProfile.targetMealProtein)
                        newTargetMealFat = String(latestProfile.targetMealFat)
                        newTargetMealCarbohydrate = String(latestProfile.targetMealCarbohydrate)
                        newUserActivityLevel = latestProfile.userActivityLevel
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
        let castingUserTall = Double(newUserTall) ?? 0
        let castingUserWeight = Double(newUserWeight) ?? 0
        guard castingUserTall > 0, castingUserWeight > 0 else {
            newUserBMI = ""
            return
        }
        let heightInMeters = castingUserTall / 100
        newUserBMI = String(round(castingUserWeight / (heightInMeters * heightInMeters) * 10) / 10)
    }
    
    private func calculateLeanBodyMass() {
        let castingUserWeight = Double(newUserWeight) ?? 0
        let castingUserFatPercentage = Double(newUserFatPercentage) ?? 0
        
        guard castingUserWeight > 0, castingUserFatPercentage > 0 else {
            newUserLeanBodyMass = "0.0"
            return
        }
        let fatAmount = castingUserWeight * (castingUserFatPercentage / 100)
        newUserLeanBodyMass = String(round((castingUserWeight - fatAmount) * 10) / 10)
    }
    
    private func calculateMuscleMass() {
        let castingUserWeight = Double(newUserWeight) ?? 0
        let castingUserFatPercentage = Double(newUserFatPercentage) ?? 0
        let castingUserLeanBodyMass = Double(newUserLeanBodyMass) ?? 0
        guard castingUserWeight > 0, castingUserFatPercentage > 0 else {
            newUserMuscleMass = "0.0"
            return
        }
        newUserMuscleMass = String(round((castingUserLeanBodyMass / 2) * 10) / 10)
    }
    
    
    
    
    
    
    
    private func calculateBMR() {
        let castingUserWeight = Double(newUserWeight) ?? 0
        let castingUserTall = Double(newUserTall) ?? 0
        let castingUserAge = Double(newUserAge) ?? 0
        guard castingUserWeight > 0, castingUserTall > 0, castingUserAge > 0 else {
            newUserBMR = ""
            return
        }
        if newUserSex == 0 {
            newUserBMR = String(format: "%.f",88.362 + (13.397 * castingUserWeight) + (4.799 * castingUserTall) - (5.677 * castingUserAge))
        } else if newUserSex == 1 {
            newUserBMR = String(format: "%.f",447.593 + (9.247 * castingUserWeight) + (3.098 * castingUserTall) - (4.33 * castingUserAge))
        } else {
            newUserBMR = ""
            return
        }
    }
    
    
    private func calculateConsumeKcal() {
        let castingUserBMR = Double(newUserBMR) ?? 0
        guard castingUserBMR > 0 else {
            return
        }
        if newUserActivityLevel == 0 {
            newUserConsumeKcal = String(format: "%.f", castingUserBMR * 1.2)
        } else if newUserActivityLevel == 1 {
            newUserConsumeKcal = String(format: "%.f", castingUserBMR * 1.375)
        } else if newUserActivityLevel == 2 {
            newUserConsumeKcal = String(format: "%.f", castingUserBMR * 1.55)
        } else if newUserActivityLevel == 3 {
            newUserConsumeKcal = String(format: "%.f", castingUserBMR * 1.725)
        } else if newUserActivityLevel == 4 {
            newUserConsumeKcal = String(format: "%.f", castingUserBMR * 1.9)
        } else {
            return
        }
    }
    
    
    private func calculate334() {
        let castingTargetMealKcal = Double(newTargetMealKcal) ?? 0
        guard castingTargetMealKcal > 0 else {
            newTargetMealProtein = ""
            newTargetMealFat = ""
            newTargetMealCarbohydrate = ""
            return
        }
        newTargetMealProtein = String(round((castingTargetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        newTargetMealFat = String(round((castingTargetMealKcal / 10 * 3 / 9) * 10) / 10)
        newTargetMealCarbohydrate = String(round((castingTargetMealKcal / 10 * 4 / 4) * 10) / 10)
    }
    
    
    private func calculate325() {
        let castingTargetMealKcal = Double(newTargetMealKcal) ?? 0
        guard castingTargetMealKcal > 0 else {
            newTargetMealProtein = ""
            newTargetMealFat = ""
            newTargetMealCarbohydrate = ""
            return
        }
        newTargetMealProtein = String(round((castingTargetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        newTargetMealFat = String(round((castingTargetMealKcal / 10 * 2 / 9) * 10) / 10)
        newTargetMealCarbohydrate = String(round((castingTargetMealKcal / 10 * 5 / 4) * 10) / 10)
    }
    
    private func calculate316() {
        let castingTargetMealKcal = Double(newTargetMealKcal) ?? 0
        guard castingTargetMealKcal > 0 else {
            newTargetMealProtein = ""
            newTargetMealFat = ""
            newTargetMealCarbohydrate = ""
            return
        }
        newTargetMealProtein = String(round((castingTargetMealKcal / 10 * 3 / 4) * 10 ) / 10)
        newTargetMealFat = String(round((castingTargetMealKcal / 10 * 1 / 9) * 10) / 10)
        newTargetMealCarbohydrate = String(round((castingTargetMealKcal / 10 * 6 / 4) * 10) / 10)
    }
    
    private func addUpdateProfile() {
        let castingUserAge = Int(newUserAge) ?? 0
//        let castingUserSex = newUserSex
        let castingUserTall = Double(newUserTall) ?? 0
        let castingUserWeight = Double(newUserWeight) ?? 0
        let castingUserBMI = Double(newUserBMI) ?? 0
        let castingUserFatPercentage = Double(newUserFatPercentage) ?? 0
        let castingUserLeanBodyMass = Double(newUserLeanBodyMass) ?? 0
        let castingUserMuscleMass = Double(newUserMuscleMass) ?? 0
        let castingUserConsumeKcal = Double(newUserConsumeKcal) ?? 0
        let castingUserBMR = Double(newUserBMR) ?? 0
        let castingTargetWeight = Double(newTargetWeight) ?? 0
        let castingTargetFatPercentage = Double(newTargetFatPercentage) ?? 0
        let castingTargetMealKcal = Double(newTargetMealKcal) ?? 0
        let castingTargetMealProtein = Double(newTargetMealProtein) ?? 0
        let castingTargetMealFat = Double(newTargetMealFat) ?? 0
        let castingTargetMealCarbohydrate = Double(newTargetMealCarbohydrate) ?? 0
        if let existingProfile = profiles.first {
            existingProfile.userDataAddDate = newUserDataAddDate
            existingProfile.userAge = castingUserAge
            existingProfile.userSex = newUserSex
            existingProfile.userTall = castingUserTall
            existingProfile.userWeight = castingUserWeight
            existingProfile.userBMI = castingUserBMI
            existingProfile.userFatPercentage = castingUserFatPercentage
            existingProfile.userLeanBodyMass = castingUserLeanBodyMass
            existingProfile.userMuscleMass = castingUserMuscleMass
            existingProfile.userConsumeKcal = castingUserConsumeKcal
            existingProfile.userBMR = castingUserBMR
            existingProfile.targetWeight = castingTargetWeight
            existingProfile.targetFatPercentage = castingTargetFatPercentage
            existingProfile.targetMealKcal = castingTargetMealKcal
            existingProfile.targetMealProtein = castingTargetMealProtein
            existingProfile.targetMealFat = castingTargetMealFat
            existingProfile.targetMealCarbohydrate = castingTargetMealCarbohydrate
            existingProfile.userActivityLevel = newUserActivityLevel
        } else {
            let newProfile = ProfileModel(
                userDataAddDate: newUserDataAddDate,
                userAge: castingUserAge,
                userSex: newUserSex,
                userTall: castingUserTall,
                userWeight: castingUserWeight,
                userBMI: castingUserBMI,
                userFatPercentage: castingUserFatPercentage,
                userLeanBodyMass: castingUserLeanBodyMass,
                userMuscleMass: castingUserMuscleMass,
                userConsumeKcal: castingUserConsumeKcal,
                userBMR: castingUserBMR,
                targetWeight: castingTargetWeight,
                targetFatPercentage: castingTargetFatPercentage,
                targetMealKcal: castingTargetMealKcal,
                targetMealProtein: castingTargetMealProtein,
                targetMealFat: castingTargetMealFat,
                targetMealCarbohydrate: castingTargetMealCarbohydrate,
                userActivityLevel: newUserActivityLevel)
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
    @Binding var newUserDataAddDate: Date
    var body: some View {
        DatePicker("", selection: $newUserDataAddDate, displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
            .onChange(of: newUserDataAddDate) {
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

