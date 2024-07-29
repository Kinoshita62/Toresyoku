//
//  MealContentListView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MealContentListView: View {
    @Environment(\.modelContext) private var context
    @Query private var mealContents: [MealContentModel]
    
    
    //    @ObservedObject var mealContentList: MealListModel
    
    var body: some View {
        ScrollView {
            NavigationView {
                List {
                    ForEach(mealContents) { mealContent in
                        LazyVStack(alignment: .leading) {
                            HStack {
                                Text(mealContent.MealName)
                                Spacer()
                                Text("\(mealContent.MealKcal, specifier: "%.1f") kcal")
                                Spacer()
                            }
                            .font(.subheadline)
                            HStack {
                                Text("たんぱく質: \(mealContent.MealProtein, specifier: "%.1f") g")
                                Text("脂質: \(mealContent.MealFat, specifier: "%.1f") g")
                                Text("炭水化物: \(mealContent.MealCarbohydrate, specifier: "%.1f") g")
                            }
                            .font(.subheadline)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            delete(mealContent: mealContents[index])
                        }
                    })
                }
                .scrollContentBackground(.hidden)
                .background(Color.orange.opacity(0.2))
            }
            .frame(width: 350, height: 500)
        }
    }
    private func delete(mealContent: MealContentModel) {
        context.delete(mealContent)
    }
}

struct MealContentListView_Previews: PreviewProvider {
    static var previews: some View {
        MealContentListView()
            .modelContainer(for: MealContentModel.self)
    }
}
