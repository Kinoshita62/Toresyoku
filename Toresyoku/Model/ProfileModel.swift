//
//  ProfileModel.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import Foundation

class ProfileModel: ObservableObject {
    @Published var UserName: String = ""
    @Published var UserGender: Int = 0
}

