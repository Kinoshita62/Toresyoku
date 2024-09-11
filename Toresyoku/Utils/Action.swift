//
//  Action.swift
//  Toresyoku
//
//  Created by USER on 2024/09/11.
//

import Foundation
import SwiftUI

class Action {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
