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
    @State private var UserName: String = ""
    @State private var UserGender: Int = 0
    let gender = ["男性", "女性"]
    
    var body: some View {
        VStack {
            HStack {
                Text("ユーザーネーム")
                Spacer()
                TextField("", text: $UserName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
            }
            .padding()
            
            HStack {
                Text("性別")
                Spacer()
                Picker(selection: $UserGender, label: Text("")) {
                    ForEach(0..<gender.count) { index in
                        Text(self.gender[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200, height: 30)
            }
            .padding()
            
            Button("追加") {
                addProfile()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
    
    private func addProfile() {
        let newProfile = ProfileModel(UserName: UserName, UserGender: UserGender)
        context.insert(newProfile)
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView()
            .modelContainer(for: ProfileModel.self, inMemory: true)
    }
}

