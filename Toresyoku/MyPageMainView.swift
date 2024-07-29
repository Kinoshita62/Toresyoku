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
        NavigationView {
            VStack {
//                Text("ユーザーネーム: \(profiles.UserName)")
//                    .padding()
                if let profile = profiles.first {
                                    Text("ユーザーネーム: \(profile.UserName)")
                                        .padding()
                                } else {
                                    Text("プロフィールが設定されていません")
                                        .padding()
                                }
                NavigationLink(destination: ProfileSettingView()) {
                    Text("プロフィール設定")
                }
            }
        }
    }
}

struct MyPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageMainView()
            .modelContainer(for: ProfileModel.self, inMemory: true)
    }
}
