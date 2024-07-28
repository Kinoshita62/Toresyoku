//
//  MyPageMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct MyPageMainView: View {
    @StateObject var profileModel: ProfileModel

    var body: some View {
        NavigationView {
            VStack {
                Text("ユーザーネーム: \(profileModel.UserName)")
                    .padding()
                
                NavigationLink(destination: ProfileSettingView(profile: profileModel)) {
                    Text("プロフィール設定")
                }
            }
        }
    }
}

struct MyPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageMainView(profileModel: ProfileModel())
    }
}
