//
//  MyMenuSelectView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MyMenuSelectView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var myMealContents: [MyMealContentModel]
    @Query private var imageColor: [ImageColorModel]
    
    private var action = Action()
    
    @State private var newMyMealName: String = ""
    @State private var newMyMealProtein: Double = 0.0
    @State private var newMyMealFat: Double = 0.0
    @State private var newMyMealCarbohydrate: Double = 0.0
    @State private var newMyMealKcal: Double = 0.0
    
    @Binding var selectedMealName: String
    @Binding var selectedMealProtein:String
    @Binding var selectedMealFat: String
    @Binding var selectedMealCarbohydrate: String
    @Binding var selectedMealKcal: Double
    
    @State var myMenuAddViewPresented: Bool = false
    
    @State private var errorMessage: String?
    
    init(selectedMealName: Binding<String>, selectedMealProtein: Binding<String>, selectedMealFat: Binding<String>, selectedMealCarbohydrate: Binding<String>, selectedMealKcal: Binding<Double>) {
            self._selectedMealName = selectedMealName
            self._selectedMealProtein = selectedMealProtein
            self._selectedMealFat = selectedMealFat
            self._selectedMealCarbohydrate = selectedMealCarbohydrate
            self._selectedMealKcal = selectedMealKcal
        }
    
    var body: some View {
        VStack {
            
            listArea
            BasicButton(title: "マイメニューの追加", widthSize: 210) {
                myMenuAddViewPresented = true
            }
            .sheet(isPresented: $myMenuAddViewPresented) {
                MyMenuAddView(myMenuAddViewPresented: $myMenuAddViewPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct MyMenuAddView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var imageColor: [ImageColorModel]
    
    private var action = Action()
    
    @State private var newMyMealName: String = ""
    @State private var newMyMealProtein: String = ""
    @State private var newMyMealFat: String = ""
    @State private var newMyMealCarbohydrate: String = ""
    @State private var newMyMealKcal: Double = 0.0
    
    @State private var myMealNameValid: Bool = true
    @State private var myMealProteinValid: Bool = true
    @State private var myMealFatValid: Bool = true
    @State private var myMealCarbohydrateValid: Bool = true
    @State private var myMealKcalValid: Bool = true
    
    @Binding var myMenuAddViewPresented: Bool
    
    init(myMenuAddViewPresented: Binding<Bool>) {
            self._myMenuAddViewPresented = myMenuAddViewPresented
        }
    
    var body: some View {
        ScrollView {
            
            mealInputArea
            
            BasicButton(title: "決定") {
                addMyMeal()
            }
            
            Spacer()
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("決定") {
                            action.hideKeyboard()
                        }
                        .foregroundStyle(.black)
                    }
                }
                .padding(.top, 100)
        }
    }
}

extension MyMenuSelectView {
    private var listArea: some View {
        List {
            ForEach(myMealContents) { myMealContent in
                VStack(alignment: .leading) {
                    HStack {
                        VStack() {
                            Text(myMealNameLimit(myMealContent.myMealName))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("\(myMealContent.myMealKcal, specifier: "%.f") kcal")
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .font(.title3)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("たんぱく質: \(myMealContent.myMealProtein, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("脂質: \(myMealContent.myMealFat, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("炭水化物: \(myMealContent.myMealCarbohydrate, specifier: "%.1f") g")
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .font(.system(size: 15))
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .font(.title3)
                                .onTapGesture {
                                    selectMyMeal(myMealContent)
                                }
                            Image(systemName: "trash")
                                .foregroundStyle(.black)
                                .font(.title3)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    deleteMyMeal(myMealContent)
                                }
                        }
                        .font(.title2)
                    }
                }
                .listRowSeparatorTint(Color.black)
                .listRowBackground(colorManager(from: imageColor.first, opacity: 0.03))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func myMealNameLimit(_ text: String) -> String {
        return text.count > 6 ? String(text.prefix(6)) + "…" : text
    }
    
    private func selectMyMeal(_ myMealContent: MyMealContentModel) {
        selectedMealName = myMealContent.myMealName
        selectedMealProtein = String(format: "%.1f", myMealContent.myMealProtein)
        selectedMealFat = String(format: "%.1f", myMealContent.myMealFat)
        selectedMealCarbohydrate = String(format: "%.1f", myMealContent.myMealCarbohydrate)
        selectedMealKcal = myMealContent.myMealKcal
        dismiss()
    }
    
    private func deleteMyMeal(_ myMealContent: MyMealContentModel) {
        do {
            context.delete(myMealContent)
            try context.save()
        } catch {
            errorMessage = "削除に失敗しました: \(error.localizedDescription)"
        }
    }
}

extension MyMenuAddView {
    private var mealInputArea: some View {
        VStack {
            InputMealNameArea(name: $newMyMealName, nameValid: $myMealNameValid)
                .padding(.vertical, 20)

        InputMealNutritionArea(title: "たんぱく質", nutrition: $newMyMealProtein, valid: $myMealProteinValid)
                .onChange(of: newMyMealProtein) {
                    if newMyMealProtein.count > 4 {
                        newMyMealProtein = String(newMyMealProtein.prefix(4))
                    }
                    calculateMyKcal()
                }
            
        InputMealNutritionArea(title: "脂質", nutrition: $newMyMealFat, valid: $myMealFatValid)
                .onChange(of: newMyMealFat) {
                    if newMyMealFat.count > 4 {
                        newMyMealFat = String(newMyMealFat.prefix(4))
                    }
                    calculateMyKcal()
                }
            
        InputMealNutritionArea(title: "炭水化物", nutrition: $newMyMealCarbohydrate, valid: $myMealCarbohydrateValid)
                .onChange(of: newMyMealCarbohydrate) {
                    if newMyMealCarbohydrate.count > 4 {
                        newMyMealCarbohydrate = String(newMyMealCarbohydrate.prefix(4))
                    }
                    calculateMyKcal()
                }
            
        InputMealKcalArea(kcal: $newMyMealKcal, kcalValid: $myMealKcalValid)
            
        }
        .padding(.bottom, 30)
    }
    
    private func calculateMyKcal() {
        newMyMealKcal = action.calculateCalories(protein: newMyMealProtein, fat: newMyMealFat, carbohydrate: newMyMealCarbohydrate)
    }
    
    private func myMealValidateForm() -> Bool {
        return action.validateForm(
            name: newMyMealName,
            protein: newMyMealProtein,
            fat: newMyMealFat,
            carbohydrate: newMyMealCarbohydrate,
            kcal: newMyMealKcal,
            nameValid: &myMealNameValid,
            proteinValid: &myMealProteinValid,
            fatValid: &myMealFatValid,
            carbohydrateValid: &myMealCarbohydrateValid,
            kcalValid: &myMealKcalValid
        )
    }
    
    private func addMyMeal() {
        if !myMealValidateForm() {
            return
        }
        let newMyMeal = MyMealContentModel(myMealName: newMyMealName, myMealProtein: Double(newMyMealProtein) ?? 0, myMealFat: Double(newMyMealFat) ?? 0, myMealCarbohydrate: Double(newMyMealCarbohydrate) ?? 0, myMealKcal: newMyMealKcal)
        context.insert(newMyMeal)
        
        do {
            try context.save()
            print("MyMeal saved successfully")
            newMyMealName = ""
            newMyMealProtein = ""
            newMyMealFat = ""
            newMyMealCarbohydrate = ""
            newMyMealKcal = 0.0
            
            myMenuAddViewPresented.toggle()
            
            dismiss()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

struct MyMenuSelectView_Previews: PreviewProvider {
    
    @State static var selectedMealName = "Sample Meal"
    @State static var selectedMealProtein = "10.0"
    @State static var selectedMealFat = "5.0"
    @State static var selectedMealCarbohydrate = "20.0"
    @State static var selectedMealKcal: Double = 200.0
    
    static var previews: some View {
        MyMenuSelectView(
            selectedMealName: $selectedMealName,
            selectedMealProtein: $selectedMealProtein,
            selectedMealFat: $selectedMealFat,
            selectedMealCarbohydrate: $selectedMealCarbohydrate,
            selectedMealKcal: $selectedMealKcal
        )
        .modelContainer(for: [MyMealContentModel.self, ImageColorModel.self])
    }
}
