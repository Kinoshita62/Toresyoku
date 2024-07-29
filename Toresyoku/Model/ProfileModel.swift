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
    var UserName: String
    var UserGender: Int
    
    init(UserName: String, UserGender: Int) {
        self.id = UUID().uuidString
        self.UserName = UserName
        self.UserGender = UserGender
    }
}

