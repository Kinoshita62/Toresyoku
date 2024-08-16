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
    var selectedDate: Date
    @Binding var refreshID: UUID

    var body: some View {
        ScrollView {
            NavigationView {
                List {
                    let filteredMealContents = mealContents.filter { mealContent in
                        Calendar.current.isDate(mealContent.MealDate, inSameDayAs: selectedDate)
                    }
        
                    ForEach(filteredMealContents) { mealContent in
                        LazyVStack(alignment: .leading) {
                            HStack {
                                VStack {
                                    Spacer()
                                    Text(mealContent.MealName)
                                    Spacer()
                                    Text("\(mealContent.MealKcal, specifier: "%.1f") kcal")
                                    Spacer()
                                }
                                .font(.title3)
                                Spacer()
                                VStack {
                                    Text("たんぱく質: \(mealContent.MealProtein, specifier: "%.1f") g")
                                    Spacer()
                                    Text("脂質: \(mealContent.MealFat, specifier: "%.1f") g")
                                    Spacer()
                                    Text("炭水化物: \(mealContent.MealCarbohydrate, specifier: "%.1f") g")
                                }
                                .font(.system(size: 15))
                            }
                        }
                        .listRowSeparatorTint(Color("Text"))
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            delete(mealContent: mealContents[index])
                        }
                        refreshID = UUID()
                    })
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func delete(mealContent: MealContentModel) {
        context.delete(mealContent)
        try? context.save()
    }
}

struct MealContentListView_Previews: PreviewProvider {
    static var previews: some View {
        MealContentListView(selectedDate: Date(), refreshID: .constant(UUID()))
            .modelContainer(for: MealContentModel.self)
    }
}
