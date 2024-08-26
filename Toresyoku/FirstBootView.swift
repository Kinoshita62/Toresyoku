//
//  FirstBootView.swift
//  Toresyoku
//
//  Created by USER on 2024/08/26.
//

import SwiftUI

struct FirstBootView: View {
    @Binding var isFirstBoot: Bool
    var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                Text("〜使い方〜")
                    .font(.title3)
                    .padding()
                    .padding(.top, 50)
                Text("・マイページからプロフィール情報を入力し、目標を設定します")
                    .padding(.top)
                    .padding(.horizontal)
                Text("（体重・体脂肪率を更新していくことで、体の変化をグラフで確認できます）")
                    .padding(.horizontal)
                    .padding(.bottom)
                Text("・「食事の追加」で食事内容を追加します")
                    .padding(.top)
                    .padding(.horizontal)
                Text("（マイメニューを設定しておくと、次回以降の入力が楽になります）")
                    .padding(.horizontal)
                    .padding(.bottom)
                Text("・目標達成までに必要な残りの食事量を確認しながら、毎日の食事管理を頑張りましょう！")
                    .padding()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isFirstBoot = false
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 100)
                                .foregroundColor(.white)
                            Text("はじめる")
                                .foregroundColor(.black)
                                .font(.title3)
                            .padding()
                        }
                    }
                    Spacer()
                }
                Spacer()
        }
        .background(Color(red: 0, green: 1, blue: 1, opacity: 0.2))
        .edgesIgnoringSafeArea(.all)
    }
}

struct FirstBootView_Previews: PreviewProvider {
    @State static var isFirstBoot: Bool = true
    static var previews: some View {
        FirstBootView(isFirstBoot: $isFirstBoot)
    }
}
