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
    var id: String
    var UserDataAddDate: Date
    
    var UserAge: Int
    var UserSex: Int

    var UserTall: Double
    var UserWeight: Double
    var UserBMI: Double
    var UserFatPercentage: Double
    var UserLeanBodyMass: Double
    var UserMuscleMass: Double
    
    var UserConsumeKcal: Double
    var UserBMR: Double
    
    var TargetWeight: Double
    var TargetFatPercentage: Double
    var TargetMealKcal: Double
    var TargetMealProtein: Double
    var TargetMealFat: Double
    var TargetMealCarbohydrate: Double
    
    init(UserDataAddDate: Date,UserAge: Int, UserSex: Int, UserTall: Double, UserWeight: Double, UserBMI: Double, UserFatPercentage: Double, UserLeanBodyMass: Double, UserMuscleMass: Double, UserConsumeKcal: Double, UserBMR: Double, TargetWeight: Double, TargetFatPercentage: Double, TargetMealKcal: Double, TargetMealProtein: Double, TargetMealFat: Double, TargetMealCarbohydrate: Double) {
        self.id = UUID().uuidString
        self.UserDataAddDate = UserDataAddDate
        self.UserAge = UserAge
        self.UserSex = UserSex
        self.UserTall = UserTall
        self.UserWeight = UserWeight
        self.UserBMI = UserBMI
        self.UserFatPercentage = UserFatPercentage
        self.UserLeanBodyMass = UserLeanBodyMass
        self.UserMuscleMass = UserMuscleMass
        self.UserConsumeKcal = UserConsumeKcal
        self.UserBMR = UserBMR
        self.TargetWeight = TargetWeight
        self.TargetFatPercentage = TargetFatPercentage
        self.TargetMealKcal = TargetMealKcal
        self.TargetMealProtein = TargetMealProtein
        self.TargetMealFat = TargetMealFat
        self.TargetMealCarbohydrate = TargetMealCarbohydrate
    }
}

