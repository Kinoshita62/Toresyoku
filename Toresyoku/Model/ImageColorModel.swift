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
    var imageColorRed: Double
    var imageColorGreen: Double
    var imageColorBlue: Double
    var imageColorAlpha: Double
        
    init(imageColorRed: Double = 0, imageColorGreen: Double = 1, imageColorBlue: Double = 1, imageColorAlpha: Double = 0.2) {
        self.imageColorRed = imageColorRed
        self.imageColorGreen = imageColorGreen
        self.imageColorBlue = imageColorBlue
        self.imageColorAlpha = imageColorAlpha
    }
}

