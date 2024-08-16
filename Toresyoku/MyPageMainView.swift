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

    var body: some View {
        NavigationStack {
            VStack {
                if let profile = profiles.first {
                    
                    HStack {
                        Text("身長")
                        Spacer()
                        Text(" \(profile.UserTall, specifier: "%.1f") cm")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("体重")
                        Spacer()
                        Text(" \(profile.UserWeight, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("BMI")
                        Spacer()
                        Text("\(profile.UserBMI, specifier: "%.1f")")
                    }
                    .padding(.vertical, 10)

                    HStack {
                        Text("体脂肪率")
                        Spacer()
                        Text("\(profile.UserFatPercentage, specifier: "%.1f") %")
                    }
                    .padding(.vertical, 10)
                   
                    HStack {
                        Text("除脂肪体重")
                        Spacer()
                        Text("\(profile.UserLeanBodyMass, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("筋肉量")
                        Spacer()
                        Text("\(profile.UserMuscleMass, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("目標体重")
                        Spacer()
                        Text("\(profile.TargetWeight, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("目標摂取カロリー（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealKcal, specifier: "%.f") kcal")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("たんぱく質の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealProtein, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("脂質の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealFat, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("炭水化物の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealCarbohydrate, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 10)
                    
                } else {
                    Text("プロフィール情報がありません")
                }
                
                NavigationLink(destination: ProfileSettingView()){
                    Text("プロフィール編集")
                }
            }
            .padding()
        }
    }
}

struct MyPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageMainView()
            .modelContainer(for: ProfileModel.self)
    }
}
