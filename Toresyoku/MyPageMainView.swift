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
                    
                    HStack {
                        Text("身長")
                        Spacer()
                        Text(" \(profile.UserTall, specifier: "%.1f") cm")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("体重")
                        Spacer()
                        Text(" \(profile.UserWeight, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("BMI")
                        Spacer()
                        Text("\(profile.UserBMI, specifier: "%.1f")")
                    }
                    .padding(.vertical, 5)

                    HStack {
                        Text("体脂肪率")
                        Spacer()
                        Text("\(profile.UserFatPercentage, specifier: "%.1f") %")
                    }
                    .padding(.vertical, 5)
                   
                    HStack {
                        Text("除脂肪体重")
                        Spacer()
                        Text("\(profile.UserLeanBodyMass, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("筋肉量")
                        Spacer()
                        Text("\(profile.UserMuscleMass, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("目標体重")
                        Spacer()
                        Text("\(profile.TargetWeight, specifier: "%.1f") kg")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("目標体脂肪率")
                        Spacer()
                        Text("\(profile.TargetFatPercentage, specifier: "%.1f") %")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("目標摂取カロリー（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealKcal, specifier: "%.f") kcal")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("たんぱく質の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealProtein, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("脂質の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealFat, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("炭水化物の目標摂取量（一日あたり）")
                        Spacer()
                        Text("\(profile.TargetMealCarbohydrate, specifier: "%.1f") g")
                    }
                    .padding(.vertical, 5)
                    Spacer()
                    
                } else {
                    Spacer()
                    Text("プロフィール情報がありません")
                }
                
                NavigationLink(destination: ProfileSettingView(refreshGraph: $refreshGraph)) {
                    Text("プロフィール編集")
                }
                Spacer()
            }
            .padding()
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
            .modelContainer(for: ProfileModel.self)
    }
}
