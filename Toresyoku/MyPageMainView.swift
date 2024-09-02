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
                            Text(dateFormat.string(from: profile.UserDataAddDate))
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
                                    Text(" \(profile.UserAge, specifier: "%.f") 歳")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("身長")
                                        .font(.title3)
                                    Spacer()
                                    Text(" \(profile.UserTall, specifier: "%.1f") cm")
                                        .font(.title3)
                                }
                                .padding(5)
                                HStack {
                                    Text("体重")
                                        .font(.title3)
                                    Spacer()
                                    Text(" \(profile.UserWeight, specifier: "%.1f") kg")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("体脂肪率")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.UserFatPercentage, specifier: "%.1f") %")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Spacer()
                                    Text("BMI")
                                    Text("\(profile.UserBMI, specifier: "%.1f")")
                                    Spacer()
                                    Text("除脂肪体重")
                                    Text("\(profile.UserLeanBodyMass, specifier: "%.1f") kg")
                                    Spacer()
                                    Text("筋肉量")
                                    Text("\(profile.UserMuscleMass, specifier: "%.1f") kg")
                                    Spacer()
                                }
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
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
                                .foregroundColor(Color(
                                    red: imageColor.first?.R ?? 0,
                                    green: imageColor.first?.G ?? 1,
                                    blue: imageColor.first?.B ?? 1,
                                    opacity: 0.03
                                ))
                                .frame(height: 80)
                            VStack {
                                HStack {
                                    Text("目標体重")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetWeight, specifier: "%.1f")kg")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("目標体脂肪率")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetFatPercentage, specifier: "%.1f") %")
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
                                .frame(height: 80)
                            VStack {
                                HStack {
                                    Text("基礎代謝量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.UserBMR, specifier: "%.f") kcal")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("消費カロリー")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.UserConsumeKcal, specifier: "%.f") kcal")
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
                                .foregroundColor(Color(
                                    red: imageColor.first?.R ?? 0,
                                    green: imageColor.first?.G ?? 1,
                                    blue: imageColor.first?.B ?? 1,
                                    opacity: 0.03
                                ))
                                .frame(height: 170)
                            VStack {
                                HStack {
                                    Text("目標摂取カロリー")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetMealKcal, specifier: "%.f") kcal")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("たんぱく質目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetMealProtein, specifier: "%.1f") g")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("脂質目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetMealFat, specifier: "%.1f") g")
                                        .font(.title3)
                                }
                                .padding(5)
                                
                                HStack {
                                    Text("炭水化物目標摂取量")
                                        .font(.title3)
                                    Spacer()
                                    Text("\(profile.TargetMealCarbohydrate, specifier: "%.1f") g")
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
                    }
                    .padding(.bottom, 50)
                    Spacer()
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
}

struct MyPageMainView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MyPageMainView(theDate: $theDate)
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}
