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
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 80, height: 80))
                    .foregroundStyle(.white)
                    .frame(height: 400)
                VStack {
                    Text("〜使い方〜")
                        .font(.title2)
                        .bold()
                        .padding()
                    Text("•マイページからプロフィール情報を入力し、目標を設定します")
                        .font(.title3)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("•「食事の追加」で食事内容を追加します")
                        .font(.title3)
                        .padding(.top)
                        .padding(.horizontal)
                    Text("（マイメニューを設定しておくと、次回以降の入力が楽になります）")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.bottom)
                    Text("•目標達成までに必要な残りの食事量を確認しながら、毎日の食事管理を頑張りましょう！")
                        .font(.title3)
                        .padding()
                        .padding(.bottom)
                }
            }
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isFirstBoot = false
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 120)
                            .foregroundStyle(.white)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        Text("はじめる")
                            .foregroundStyle(.black)
                            .bold()
                            .font(.title2)
                            .padding()
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(Color(red: 0, green: 1, blue: 1, opacity: 0.05))
        .edgesIgnoringSafeArea(.all)
    }
}

struct FirstBootView_Previews: PreviewProvider {
    @State static var isFirstBoot: Bool = true
    static var previews: some View {
        FirstBootView(isFirstBoot: $isFirstBoot)
    }
}
