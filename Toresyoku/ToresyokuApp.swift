//
//  ToresyokuApp.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

@main
struct ToresyokuApp: App {
    var sharedModelContainer: ModelContainer? = {
        do {
            let container = try ModelContainer(for: ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self)
            print("ModelContainer initialized successfully")
            return container
        } catch {
            print("Error initializing ModelContainer: \(error.localizedDescription)")
            return nil
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if let _ = sharedModelContainer {
                MainView()
            } else {
                Text("データの初期化に失敗しました。アプリを再起動してください。")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}


