//
//  MealMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct MealMainView: View {

    @Environment(\.modelContext) private var context
    var selectedDate: Date
    
    var body: some View {
        NavigationView {
            Color.gray.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    VStack {
                        Text("達成状況")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .foregroundColor(.orange.opacity(0.2))

                        
                        HStack {
                            NavigationLink(destination: AddMealView()) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.orange.opacity(0.2))
                                    .frame(width: 150, height: 30)
                                        .overlay(Label("食事の追加", systemImage: "square.and.pencil"))
                                            .foregroundColor(.black)
                                            .font(.title3)
                            }
                            .padding(.top)
                            .padding(.leading)
                            Spacer()
                        }
                        MealContentListView(selectedDate: selectedDate)
                    }
                    Spacer()
                }
        }
    }
}

struct MealMainView_Previews: PreviewProvider {
    static var previews: some View {
        MealMainView(selectedDate: Date())
            .modelContainer(for: MealContentModel.self, inMemory: true)
    }
}
