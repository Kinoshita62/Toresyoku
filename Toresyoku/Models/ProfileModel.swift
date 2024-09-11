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
    var userDataAddDate: Date
    
    var userAge: Int
    var userSex: Int

    var userTall: Double
    var userWeight: Double
    var userBMI: Double
    var userFatPercentage: Double
    var userLeanBodyMass: Double
    var userMuscleMass: Double
    
    var userConsumeKcal: Double
    var userBMR: Double
    
    var targetWeight: Double
    var targetFatPercentage: Double
    var targetMealKcal: Double
    var targetMealProtein: Double
    var targetMealFat: Double
    var targetMealCarbohydrate: Double
    
    var userActivityLevel: Int
    
    init(userDataAddDate: Date, userAge: Int, userSex: Int, userTall: Double, userWeight: Double, userBMI: Double, userFatPercentage: Double, userLeanBodyMass: Double, userMuscleMass: Double, userConsumeKcal: Double, userBMR: Double, targetWeight: Double, targetFatPercentage: Double, targetMealKcal: Double, targetMealProtein: Double, targetMealFat: Double, targetMealCarbohydrate: Double, userActivityLevel: Int) {
        self.id = UUID().uuidString
        self.userDataAddDate = userDataAddDate
        self.userAge = userAge
        self.userSex = userSex
        self.userTall = userTall
        self.userWeight = userWeight
        self.userBMI = userBMI
        self.userFatPercentage = userFatPercentage
        self.userLeanBodyMass = userLeanBodyMass
        self.userMuscleMass = userMuscleMass
        self.userConsumeKcal = userConsumeKcal
        self.userBMR = userBMR
        self.targetWeight = targetWeight
        self.targetFatPercentage = targetFatPercentage
        self.targetMealKcal = targetMealKcal
        self.targetMealProtein = targetMealProtein
        self.targetMealFat = targetMealFat
        self.targetMealCarbohydrate = targetMealCarbohydrate
        self.userActivityLevel = userActivityLevel
    }
}

