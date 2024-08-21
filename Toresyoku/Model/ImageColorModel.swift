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
        
    init(R: Double, G: Double, B: Double, A: Double) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
