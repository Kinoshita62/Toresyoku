//
//  MealMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct MealMainView: View {
//    @State var addMealModal: Bool = false
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationView {
            VStack {
                Text("達成状況")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Rectangle()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .foregroundColor(.orange.opacity(0.2))
                
                NavigationLink(destination: AddMealView()) {
                    Label("食事の追加", systemImage: "square.and.pencil")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
//                        .onTapGesture {
//                            addMealModal = true
//                        }
//                        .sheet(isPresented: $addMealModal, content: {
//                            AddMealView(
//                                addMealPresented: $addMealModal
//                            )
//                            .presentationDetents([.height(600)])
//                            .presentationDragIndicator(.visible)
                    
                }
                MealContentListView()
//                Rectangle()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .foregroundColor(.orange.opacity(0.2))
            }
        }
    }
}

struct MealMainView_Previews: PreviewProvider {
    static var previews: some View {
        MealMainView()
            .modelContainer(for: MealContentModel.self, inMemory: true)
    }
}
