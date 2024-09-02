//
//  ColorModel.swift
//  Toresyoku
//
//  Created by USER on 2024/08/19.
//

import Foundation
import SwiftData

@Model
final class ImageColorModel {
    var R: Double
    var G: Double
    var B: Double
    var A: Double
        
    init(R: Double = 0, G: Double = 1, B: Double = 1, A: Double = 0.2) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
