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
//    @Query private var mealContents: [MealContentModel]
//    @Query private var profiles: [ProfileModel]
//    @Query private var myMealContents: [MyMealContentModel]
    @Query private var ImageColor: [ImageColorModel]
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 1
    
    @Binding var selectedDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
        NavigationView {
            VStack {
                Text("今日の達成状況")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal)
                        
                MealProgressView(selectedDate: selectedDate, refreshID: $refreshID)
                    .padding(.horizontal)

                        
                HStack {
                    NavigationLink(destination: AddMealView(refreshID: $refreshID)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(
                                red: ImageColor.first?.R ?? 0,
                                green: ImageColor.first?.G ?? 1,
                                blue: ImageColor.first?.B ?? 1,
                                opacity: ImageColor.first?.A ?? 1
                            ))
                            .frame(width: 150, height: 35)
                            .overlay(Label("食事の追加", systemImage: "square.and.pencil"))
                            .overlay(
                                   RoundedRectangle(cornerRadius: 10)
                                       .stroke(Color.gray, lineWidth: 1)
                            )
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
    static var previews: some View {
        MealMainView(selectedDate: $selectedDate, refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
