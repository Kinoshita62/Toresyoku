//
//  ProfileModel.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import Foundation
import SwiftData

@Model
final class ProfileModel {
    let id: String
    var UserTall: Double
    var UserWeight: Double
    var UserBMI: Double
    var UserFatPercentage: Double
    var UserLeanBodyMass: Double
    var UserMuscleMass: Double
    
    var TargetWeight: Double
    var TargetMealKcal: Double
    var TargetMealProtein: Double
    var TargetMealFat: Double
    var TargetMealCarbohydrate: Double
    
    init(UserTall: Double, UserWeight: Double, UserBMI: Double, UserFatPercentage: Double, UserLeanBodyMass: Double, UserMuscleMass: Double, TargetWeight: Double, TargetMealKcal: Double, TargetMealProtein: Double, TargetMealFat: Double, TargetMealCarbohydrate: Double) {
        self.id = UUID().uuidString
        self.UserTall = UserTall
        self.UserWeight = UserWeight
        self.UserBMI = UserBMI
        self.UserFatPercentage = UserFatPercentage
        self.UserLeanBodyMass = UserLeanBodyMass
        self.UserMuscleMass = UserMuscleMass
        self.TargetWeight = TargetWeight
        self.TargetMealKcal = TargetMealKcal
        self.TargetMealProtein = TargetMealProtein
        self.TargetMealFat = TargetMealFat
        self.TargetMealCarbohydrate = TargetMealCarbohydrate
    }
}

