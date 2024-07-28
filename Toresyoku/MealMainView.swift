//
//  MealMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct MealMainView: View {
    @ObservedObject var mealListModel: MealListModel
    @State var addMealModal: Bool = false

    var body: some View {
        VStack {
            Text("達成状況")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Rectangle()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .foregroundColor(.orange.opacity(0.2))
            
            Label("食事の追加", systemImage: "square.and.pencil")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
                .onTapGesture {
                    addMealModal = true
                }
                .sheet(isPresented: $addMealModal, content: {
                    AddMealView(
                        mealListModel: mealListModel,
                        addMealPresented: $addMealModal // バインディングを渡す
                    )
                    .presentationDetents([.height(600)])
                    .presentationDragIndicator(.visible)
                })
            
            Rectangle()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .foregroundColor(.orange.opacity(0.2))
        }
    }
}

struct MealMainView_Previews: PreviewProvider {
    static var previews: some View {
        MealMainView(mealListModel: MealListModel())
    }
}
