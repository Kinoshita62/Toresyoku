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
    
    @State private var filteredMealContents: [MealContentModel] = []
    
    var body: some View {
        List {
            ForEach(filteredMealContents) { mealContent in
                MealContentRowView(mealContent: mealContent, imageColor: imageColor.first, action: {
                    deleteMeal(mealContent)
                })
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .onAppear {
            filterMeals()
        }
        .onChange(of: theDate) {
            filterMeals()
        }
    }
}

struct MealContentRowView: View {
    
    let mealContent: MealContentModel
    let imageColor: ImageColorModel?
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                mealInfo
                Spacer()
                nutritionInfo
                Spacer()
                deleteButton
            }
        }
        .listRowSeparatorTint(.black)
        .listRowBackground(colorManager(from: imageColor, opacity: 0.03))
    }
}

extension MealContentListView {
    private func filterMeals() {
        filteredMealContents = mealContents.filter { mealContent in
            Calendar.current.isDate(mealContent.mealDate, inSameDayAs: theDate)
        }
    }
    
    private func deleteMeal(_ mealContent: MealContentModel) {
        do {
            context.delete(mealContent)
            try context.save()
            refreshID = UUID()
            filterMeals()
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }
}

extension MealContentRowView {
    private var mealInfo: some View {
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
    }
    
    private var nutritionInfo: some View {
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
    }
    
    private var deleteButton: some View {
        Image(systemName: "trash")
            .font(.title3)
            .foregroundStyle(.black)
            .onTapGesture {
                action()
            }
    }
    
    private func mealNameLimit(_ text: String) -> String {
        return text.count > 6 ? String(text.prefix(6)) + "…" : text
    }
}

struct MealContentListView_Previews: PreviewProvider {
    @State static var theDate = Date()
    static var previews: some View {
        MealContentListView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, ImageColorModel.self])
    }
}
