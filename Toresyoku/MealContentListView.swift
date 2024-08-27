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
    
    @State private var errorMessage: String?
    
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
                                    Text(MealNameLimit(mealContent.MealName))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                    Text("\(mealContent.MealKcal, specifier: "%.1f") kcal")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                .font(.title3)
                                Spacer()
                                VStack {
                                    Text("たんぱく質: \(mealContent.MealProtein, specifier: "%.1f") g")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("脂質: \(mealContent.MealFat, specifier: "%.1f") g")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("炭水化物: \(mealContent.MealCarbohydrate, specifier: "%.1f") g")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .font(.system(size: 15))
                                Spacer()
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        deleteMeal(mealContent)
                                    }
                            }
                        }
                        .listRowSeparatorTint(Color("Text"))
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func MealNameLimit(_ text: String) -> String {
            if text.count > 6 {
                return String(text.prefix(6)) + "…"
            } else {
                return text
            }
        }
    private func deleteMeal(_ mealContent: MealContentModel) {
        do {
            if let originalIndex = mealContents.firstIndex(where: { $0.id == mealContent.id }) {
                context.delete(mealContents[originalIndex])
                try context.save()
                refreshID = UUID()
            }
        } catch {
            errorMessage = "削除に失敗しました: \(error.localizedDescription)"
        }
    }
}

struct MealContentListView_Previews: PreviewProvider {
    static var previews: some View {
        MealContentListView(selectedDate: Date(), refreshID: .constant(UUID()))
            .modelContainer(for: MealContentModel.self)
    }
}
