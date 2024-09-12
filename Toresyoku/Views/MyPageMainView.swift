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
                                HStack {
                                    Text("年齢")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(String(profile.userAge)) 歳")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("身長")
                                        .font(.title3)
                                    Spacer()
                                    Text(" \(profile.userTall, specifier: "%.1f") cm")
                                        .font(.title3)
                                }
                                .padding(5)
                                HStack {
                                    Text("体重")
                                        .font(.title3)
                                    Spacer()
                                    Text(" \(profile.userWeight, specifier: "%.1f") kg")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("体脂肪率")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.userFatPercentage, specifier: "%.1f") %")
                                        .font(.title3)
                                }
                                .padding(5)
                                
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
                                HStack {
                                    Text("目標体重")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetWeight, specifier: "%.1f")kg")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("目標体脂肪率")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetFatPercentage, specifier: "%.1f") %")
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
                                .foregroundStyle(.gray .opacity(0.05))
                                .frame(height: 120)
                            VStack {
                                HStack {
                                    Text("基礎代謝量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.userBMR, specifier: "%.f") kcal")
                                        .font(.title3)
                                }
                                .padding(5)
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
                                HStack {
                                    Text("消費カロリー")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.userConsumeKcal, specifier: "%.f") kcal")
                                        .font(.title3)
                                }
                                .padding(5)
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
                                HStack {
                                    Text("目標摂取カロリー")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetMealKcal, specifier: "%.f") kcal")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("たんぱく質目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetMealProtein, specifier: "%.1f") g")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("脂質目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetMealFat, specifier: "%.1f") g")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("炭水化物目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.targetMealCarbohydrate, specifier: "%.1f") g")
                                        .font(.title3)
                                }
                                .padding(5)
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
