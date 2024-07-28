//
//  MealListModel.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import Foundation

class MealListModel: ObservableObject {
    @Published var meals: [MealContentModel] = []
    
    init() {
        // サンプルデータの追加（必要に応じて）
        let meal1 = MealContentModel()
        meal1.MealName = "サンプル食事1"
        meal1.MealProtein = 20
        meal1.MealFat = 10
        meal1.MealCarbohydrate = 30
        
        let meal2 = MealContentModel()
        meal2.MealName = "サンプル食事2"
        meal2.MealProtein = 25
        meal2.MealFat = 15
        meal2.MealCarbohydrate = 35
        
        meals.append(meal1)
        meals.append(meal2)
    }
    
    func addMeal(_ meal: MealContentModel) {
        meals.append(meal)
    }
}
