//
//  GraphMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct GraphMainView: View {
    var body: some View {
        VStack {
            
            HStack {
                Text("カロリー摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("たんぱく質摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("脂肪摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("炭水化物摂取量（一日あたり）")
                Spacer()
            }
            
            HStack {
                Text("データの追加")
                Spacer()
            }
            HStack {
                Text("体重")
                Spacer()
            }
            HStack {
                Text("BMI")
                Spacer()
            }
            HStack {
                Text("除脂肪体重")
                Spacer()
            }
            HStack {
                Text("筋肉量")
                Spacer()
            }
            
            
        }
    }
}

#Preview {
    GraphMainView()
}
