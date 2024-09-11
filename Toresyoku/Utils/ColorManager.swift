//
//  ColorManager.swift
//  Toresyoku
//
//  Created by USER on 2024/09/11.
//

// ColorUtils.swift

import SwiftUI

func colorManager(from imageColor: ImageColorModel?, opacity: Double) -> Color {
    return Color(
        red: imageColor?.imageColorRed ?? 0,
        green: imageColor?.imageColorGreen ?? 1,
        blue: imageColor?.imageColorBlue ?? 1,
        opacity: opacity
    )
}

