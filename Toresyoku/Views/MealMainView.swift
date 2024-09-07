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
    @Query private var imageColor: [ImageColorModel]
    
    @Binding var theDate: Date
    @Binding var refreshID: UUID
 
    var body: some View {
        NavigationStack {
            VStack {
                Text("今日の達成状況")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .horizontal])
                        
                MealProgressView(theDate: $theDate, refreshID: $refreshID)
                    .padding(.horizontal)

                        
                HStack {
                    NavigationLink(destination: AddMealView(theDate: $theDate, refreshID: $refreshID)) {
                        Text("食事の追加")
                            .bold()
                            .frame(width: 150, height: 35)
                            .background(Color(
                                red: imageColor.first?.imageColorRed ?? 0,
                                green: imageColor.first?.imageColorGreen ?? 1,
                                blue: imageColor.first?.imageColorBlue ?? 1,
                                opacity: imageColor.first?.imageColorAlpha ?? 0.2
                            ))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .foregroundStyle(.black)
                            .font(.title3)
                            .padding([.top, .horizontal])
                    }
                    Spacer()
                }
                
                MealContentListView(theDate: $theDate, refreshID: $refreshID)
                    .padding(.horizontal)
                    .onAppear {
                        refreshID = UUID()
                    }
                Spacer()
            }
        }
    }
}

struct MealMainView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MealMainView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
