//
//  ProfileRowView.swift
//  Toresyoku
//
//  Created by USER on 2024/09/13.
//

import SwiftUI

struct ProfileRowView: View {
    var title: String
    var value: Double
    var unit: String = ""
    var specifier: String = "%.1f"
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
            Spacer()
            Text("\(value, specifier: specifier)")
                .font(.title3)
            if !unit.isEmpty {
                Text(unit)
                    .font(.title3)
            }
        }
        .padding(5)
    }
}

struct ProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRowView(title: "身長", value: 170.5, unit: "cm")
    }
}

