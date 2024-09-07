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
    @Query private var imageColor: [ImageColorModel]
    @Binding var theDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
        List {
            let filteredMealContents = mealContents.filter { mealContent in
                Calendar.current.isDate(mealContent.mealDate, inSameDayAs: theDate)
            }
            ForEach(filteredMealContents) { mealContent in
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Spacer()
                            Text(mealNameLimit(mealContent.mealName))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                            Text("\(mealContent.mealKcal, specifier: "%.f") kcal")
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        .font(.title3)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("たんぱく質: \(mealContent.mealProtein, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("脂質: \(mealContent.mealFat, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("炭水化物: \(mealContent.mealCarbohydrate, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .font(.system(size: 15))
                        Spacer()
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .onTapGesture {
                                deleteMeal(mealContent)
                            }
                    }
                }
                .listRowSeparatorTint(Color(.black))
                .listRowBackground(Color(
                    red: imageColor.first?.imageColorRed ?? 0,
                    green: imageColor.first?.imageColorGreen ?? 1,
                    blue: imageColor.first?.imageColorBlue ?? 1,
                    opacity: 0.03
                ))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func mealNameLimit(_ text: String) -> String {
        return text.count > 6 ? String(text.prefix(6)) + "…" : text
    }
    
    private func deleteMeal(_ mealContent: MealContentModel) {
        do {
            context.delete(mealContent)
            try context.save()
            refreshID = UUID()
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }
}

struct MealContentListView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MealContentListView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, ImageColorModel.self])
    }
}
