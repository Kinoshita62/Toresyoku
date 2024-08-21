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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

