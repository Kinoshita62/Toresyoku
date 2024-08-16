//
//  MealMainView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MealMainView: View {

    @Environment(\.modelContext) private var context
    @Query private var mealContents: [MealContentModel]
    @Query private var profiles: [ProfileModel]
    @Binding var selectedDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
        NavigationView {
            VStack {
                Text("達成状況")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal)
                        
                MealProgressView(selectedDate: selectedDate, refreshID: $refreshID)
                    .padding(.horizontal)

                        
                HStack {
                    NavigationLink(destination: AddMealView(refreshID: $refreshID)) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0/255, green: 255/255, blue: 255/255))
                            .frame(width: 150, height: 30)
                            .overlay(Label("食事の追加", systemImage: "square.and.pencil"))
                            .foregroundColor(.black)
                                .font(.title3)
                    }
                    .padding(.top)
                    .padding(.leading)
                    Spacer()
                }
                
                MealContentListView(selectedDate: selectedDate, refreshID: $refreshID)
                    .padding(.horizontal)
                    .onAppear {
                        refreshID = UUID()
                    }

            }
            Spacer()
        }
    }
}

struct MealMainView_Previews: PreviewProvider {
    @State static var selectedDate = Date()
    @State static var refreshID = UUID()
    static var previews: some View {
        MealMainView(selectedDate: $selectedDate, refreshID: $refreshID)
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self])
    }
}
