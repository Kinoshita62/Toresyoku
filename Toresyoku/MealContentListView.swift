//
//  MealContentListView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct MealContentListView: View {
    @ObservedObject var mealContentList: MealListModel
    
    var body: some View {
        ScrollView {
            NavigationView {
                List(mealContentList.meals) { meal in
                    LazyVStack(alignment: .leading) {
                        HStack {
                            Text(meal.MealName)
                            Spacer()
                            Text("\(meal.MealKcal, specifier: "%.1f") kcal")
                            Spacer()
                        }
                        .font(.subheadline)
                        HStack {
                            Text("たんぱく質: \(meal.MealProtein, specifier: "%.1f") g")
                            Text("脂質: \(meal.MealFat, specifier: "%.1f") g")
                            Text("炭水化物: \(meal.MealCarbohydrate, specifier: "%.1f") g")
                        }
                        .font(.subheadline)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.orange.opacity(0.2))
            }
            .frame(width: 350, height: 500)
        }
    }
}

struct MealContentListView_Previews: PreviewProvider {
    static var previews: some View {
        MealContentListView(mealContentList: MealListModel())
    }
}
