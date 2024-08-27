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
    @Query private var ImageColor: [ImageColorModel]
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 0.2
    
    @Binding var refreshGraph: UUID
    
    var latestProfile: ProfileModel? {
        profiles.sorted(by: { $0.UserDataAddDate > $1.UserDataAddDate }).first
    }
    
    var body: some View {
        NavigationStack {
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
                    List {
                        HStack {
                            Text("身長")
                            Spacer()
                            Text(" \(profile.UserTall, specifier: "%.1f") cm")
                        }
                        HStack {
                            Text("体重")
                            Spacer()
                            Text(" \(profile.UserWeight, specifier: "%.1f") kg")
                        }
                        
                        HStack {
                            Text("体脂肪率")
                            Spacer()
                            Text("\(profile.UserFatPercentage, specifier: "%.1f") %")
                        }
                        
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
        
                        HStack {
                            Text("目標体重")
                            Spacer()
                            Text("\(profile.TargetWeight, specifier: "%.1f")kg")
                        }
                        
                        HStack {
                            Text("目標体脂肪率")
                            Spacer()
                            Text("\(profile.TargetFatPercentage, specifier: "%.1f") %")
                        }
                        
                        HStack {
                            Text("1日の目標摂取カロリー")
                            Spacer()
                            Text("\(profile.TargetMealKcal, specifier: "%.f") kcal")
                        }
                        .padding(.vertical, 5)
                        
                        HStack {
                            Text("1日のたんぱく質目標摂取量")
                            Spacer()
                            Text("\(profile.TargetMealProtein, specifier: "%.1f") g")
                        }
                        
                        HStack {
                            Text("1日の脂質目標摂取量")
                            Spacer()
                            Text("\(profile.TargetMealFat, specifier: "%.1f") g")
                        }
                        
                        HStack {
                            Text("1日の炭水化物目標摂取量")
                            Spacer()
                            Text("\(profile.TargetMealCarbohydrate, specifier: "%.1f") g")
                        }
                    }
                    .font(.title3)
                    .listStyle(.plain)
                } else {
                    Spacer()
                    Text("プロフィール情報がありません")
                        .font(.title3)
                }
                
                NavigationLink(destination: ProfileSettingView(refreshGraph: $refreshGraph)) {
                    Text("プロフィールの編集・更新")
                        .font(.title3)
                        .padding()
                        .frame(width: 270, height: 35)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .background(Color(
                            red: ImageColor.first?.R ?? 0,
                            green: ImageColor.first?.G ?? 1,
                            blue: ImageColor.first?.B ?? 1,
                            opacity: ImageColor.first?.A ?? 0.2
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
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
}

struct MyPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageMainView(refreshGraph: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, ImageColorModel.self])
    }
}
