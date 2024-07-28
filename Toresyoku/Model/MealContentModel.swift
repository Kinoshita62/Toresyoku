//
//  MealContentModel.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import Foundation

class MealContentModel: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var MealName: String = ""
    @Published var MealProtein: Double = 0.0
    @Published var MealFat: Double = 0.0
    @Published var MealCarbohydrate: Double = 0.0
    @Published var MealKcal: Double = 0.0
    @Published var MealDate = Date()
    @Published var isValidProtein: Bool = true
    @Published var isValidFat: Bool = true
    @Published var isValidCarbohydrate: Bool = true
}
