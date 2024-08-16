//
//  MyMealContentModel.swift
//  Toresyoku
//
//  Created by USER on 2024/08/15.
//

import Foundation
import SwiftData

@Model
final class MyMealContentModel {
    let id: String
    var MyMealName: String
    var MyMealProtein: Double
    var MyMealFat: Double
    var MyMealCarbohydrate: Double
    var MyMealKcal: Double
    
    init(MyMealName: String, MyMealProtein: Double, MyMealFat: Double, MyMealCarbohydrate: Double, MyMealKcal: Double) {
        self.id = UUID().uuidString
        self.MyMealName = MyMealName
        self.MyMealProtein = MyMealProtein
        self.MyMealFat = MyMealFat
        self.MyMealCarbohydrate = MyMealCarbohydrate
        self.MyMealKcal = MyMealKcal
    }
}
