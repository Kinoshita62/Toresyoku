//
//  MyPageMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MyPageMainView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [ProfileModel]
    @Query private var imageColor: [ImageColorModel]
    
    @Binding var theDate: Date
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    var latestProfile: ProfileModel? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let profile = latestProfile {
                        HStack {
                            Spacer()
                            Text(dateFormat.string(from: profile.userDataAddDate))
                            Text("時点")
                        }
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text("基本情報")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.gray .opacity(0.05))
                                .frame(height: 200)
                            VStack{
                                ProfileRowView(title: "年齢", value: profile.userAge, unit: "歳")
                                ProfileRowView(title: "身長", value: profile.userTall, unit: "cm")
                                ProfileRowView(title: "体重", value: profile.userWeight, unit: "kg")
                                ProfileRowView(title: "体脂肪率", value: profile.userFatPercentage, unit: "%")
                                
                                HStack {
                                    Spacer()
                                    Text("BMI")
                                    Text("\(profile.userBMI, specifier: "%.1f")")
                                    Spacer()
                                    Text("除脂肪体重")
                                    Text("\(profile.userLeanBodyMass, specifier: "%.1f") kg")
                                    Spacer()
                                    Text("筋肉量")
                                    Text("\(profile.userMuscleMass, specifier: "%.1f") kg")
                                    Spacer()
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .padding(5)
                            }
                            .padding(5)
                        }
                        
                        Text("目標")
                            .font(.title2)
                            .bold()
                            .padding(.top, 15 )
                        
                        ZStack {
                            Rectangle()
                                .foregroundStyle(colorManager(from: imageColor.first, opacity: 0.03))
                                .frame(height: 80)
                            VStack {
                                ProfileRowView(title: "目標体重", value: profile.targetWeight, unit: "kg")
                                ProfileRowView(title: "目標体脂肪率", value: profile.targetFatPercentage, unit: "%")
                            }
                            .padding(5)
                        }
                        
                        Text("身体情報")
                            .font(.title2)
                            .bold()
                            .padding(.top, 15)
                        
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.gray .opacity(0.05))
                                .frame(height: 120)
                            VStack {
                                ProfileRowView(title: "基礎代謝量", value: profile.userBMR, unit: "kcal", specifier: "%.0f")
                                HStack {
                                    Text("活動レベル")
                                        .font(.title3)
                                    Spacer()
                                    if profile.userActivityLevel == 0 {
                                        Text("低い")
                                            .font(.title3)
                                    } else if profile.userActivityLevel == 1 {
                                        Text("やや低い")
                                            .font(.title3)
                                    } else if profile.userActivityLevel == 2 {
                                        Text("普通")
                                            .font(.title3)
                                    } else if profile.userActivityLevel == 3 {
                                        Text("やや高い")
                                            .font(.title3)
                                    } else if profile.userActivityLevel == 4 {
                                        Text("高い")
                                            .font(.title3)
                                    }
                                }
                                .padding(5)
                                ProfileRowView(title: "消費カロリー", value: profile.userConsumeKcal, unit: "kcal", specifier: "%.0f")
                            }
                            .padding(5)
                        }
                        
                        Text("1日の目標")
                            .font(.title2)
                            .bold()
                            .padding(.top, 15)
                        
                        
                        ZStack {
                            Rectangle()
                                .foregroundStyle(colorManager(from: imageColor.first, opacity: 0.03))
                                .frame(height: 170)
                            VStack {
                                ProfileRowView(title: "目標摂取カロリー", value: profile.targetMealKcal, unit: "kcal", specifier: "%.0f")
                                ProfileRowView(title: "たんぱく質目標摂取量", value: profile.targetMealProtein, unit: "g")
                                ProfileRowView(title: "脂質目標摂取量", value: profile.targetMealFat, unit: "g")
                                ProfileRowView(title: "炭水化物目標摂取量", value: profile.targetMealCarbohydrate, unit: "g")
                            }
                            .padding(5)
                        }
                        .padding(.bottom, 30)
                        
                    } else {
                        Spacer()
                        Text("プロフィール情報がありません")
                            .font(.title3)
                            .padding(.top, 250)
                    }
                    
                    NavigationLink(destination: ProfileSettingView(theDate: $theDate)) {
                        Text("プロフィールの編集")
                            .font(.title3)
                            .bold()
                            .padding()
                            .frame(width: 250, height: 35)
                            .cornerRadius(10)
                            .foregroundStyle(.black)
                            .background(colorManager(from: imageColor.first, opacity: 0.2))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 50)
                    Spacer()
                }
            }
        }
    }
}

struct MyPageMainView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MyPageMainView(theDate: $theDate)
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}
