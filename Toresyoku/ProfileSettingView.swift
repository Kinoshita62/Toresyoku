//
//  ProfileSettingView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct ProfileSettingView: View {
    @ObservedObject var profile: ProfileModel
    let gender = ["男性", "女性"]
    
    var body: some View {
        VStack {
            HStack {
                Text("ユーザーネーム")
                Spacer()
                TextField("", text: $profile.UserName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
            }
            .padding()
            
            HStack {
                Text("性別")
                Spacer()
                Picker(selection: $profile.UserGender, label: Text("")) {
                    ForEach(0..<gender.count) { index in
                        Text(self.gender[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200, height: 30)
            }
            .padding()
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView(profile: ProfileModel())
    }
}

