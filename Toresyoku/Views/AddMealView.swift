//
//  AddMealView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct AddMealView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    private var action = Action()

    @Query private var imageColor: [ImageColorModel]
    
    @State private var newMealName: String = ""
    @State private var newMealProtein: String = ""
    @State private var newMealFat: String = ""
    @State private var newMealCarbohydrate: String = ""
    @State private var newMealKcal: Double = 0.0
    @State private var newMealDate: Date
    
    @State private var myMenuSelectModal: Bool = false
    @State private var addMealModal: Bool = false
    
    @State private var mealNameValid: Bool = true
    @State private var mealProteinValid: Bool = true
    @State private var mealFatValid: Bool = true
    @State private var mealCarbohydrateValid: Bool = true
    @State private var mealKcalValid: Bool = true
    
    @State private var mealDateSelectPresented: Bool = false
    
    @Binding var refreshID: UUID
    @Binding var theDate: Date
    
    init(theDate: Binding<Date>, refreshID: Binding<UUID>) {
        self._theDate = theDate
        self._refreshID = refreshID
        self._newMealDate = State(initialValue: theDate.wrappedValue)
    }
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    var body: some View {
        ScrollView {
            VStack {
                mealSelectArea
                
                mealNutritionArea
                
                mealDecisionArea
                
                Spacer()
            }
        }
        .onAppear {
            self.newMealDate = theDate
        }
        .onChange(of: theDate) {
            self.newMealDate = theDate
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("決定") {
                    action.hideKeyboard()
                }
                .foregroundStyle(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
        
struct MealDateSelectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var newMealDate: Date
    var body: some View {
        DatePicker("", selection: $newMealDate, displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
            .onChange(of: newMealDate) {
                dismiss()
            }
    }
}
        
extension AddMealView {
    private var mealSelectArea: some View {
        VStack {
            InputMealNameArea(name: $newMealName, nameValid: $mealNameValid)

            HStack {
                BasicButton(title: "マイメニューから選択", widthSize: 230) {
                    myMenuSelectModal = true
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            .sheet(isPresented: $myMenuSelectModal) {
                MyMenuSelectView(
                    selectedMealName: $newMealName,
                    selectedMealProtein: $newMealProtein,
                    selectedMealFat: $newMealFat,
                    selectedMealCarbohydrate: $newMealCarbohydrate,
                    selectedMealKcal: $newMealKcal
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var mealNutritionArea: some View {
        VStack {
            InputMealNutritionArea(title: "たんぱく質", nutrition: $newMealProtein, valid: $mealProteinValid)
                .onChange(of: newMealProtein) {
                    if newMealProtein.count > 4 {
                        newMealProtein = String(newMealProtein.prefix(4))
                    }
                    calculateKcal()
                }
            
            InputMealNutritionArea(title: "脂質", nutrition: $newMealFat, valid: $mealFatValid)
                .onChange(of: newMealFat) {
                    if newMealFat.count > 4 {
                        newMealFat = String(newMealFat.prefix(4))
                    }
                    calculateKcal()
                }
            
            InputMealNutritionArea(title: "炭水化物", nutrition: $newMealCarbohydrate, valid: $mealCarbohydrateValid)
                .onChange(of: newMealCarbohydrate) {
                    if newMealCarbohydrate.count > 4 {
                        newMealCarbohydrate = String(newMealCarbohydrate.prefix(4))
                    }
                    calculateKcal()
                }
            
            InputMealKcalArea(kcal: $newMealKcal, kcalValid: $mealKcalValid)
        }
    }
    
    private var mealDecisionArea: some View {
        VStack {
            HStack {
                Spacer()
                NoButton {
                    dismiss()
                }
                Spacer()
                BasicButton(title: "決定") {
                    addMeal()
                }
                Spacer()
            }
        }
       
    }

    private func calculateKcal() {
        newMealKcal = action.calculateCalories(protein: newMealProtein, fat: newMealFat, carbohydrate: newMealCarbohydrate)
    }

    private func mealValidateForm() -> Bool {
        return action.validateForm(
            name: newMealName,
            protein: newMealProtein,
            fat: newMealFat,
            carbohydrate: newMealCarbohydrate,
            kcal: newMealKcal,
            nameValid: &mealNameValid,
            proteinValid: &mealProteinValid,
            fatValid: &mealFatValid,
            carbohydrateValid: &mealCarbohydrateValid,
            kcalValid: &mealKcalValid
        )
    }

    private func addMeal() {
        if !mealValidateForm() {
            return
        }
        let newMeal = MealContentModel(mealName: newMealName, mealProtein: Double(newMealProtein) ?? 0, mealFat: Double(newMealFat) ?? 0, mealCarbohydrate: Double(newMealCarbohydrate) ?? 0, mealKcal: newMealKcal, mealDate: newMealDate)
        context.insert(newMeal)
    
        do {
            try context.save()
            print("Meal saved successfully")
            newMealName = ""
            newMealProtein = ""
            newMealFat = ""
            newMealCarbohydrate = ""
            newMealKcal = 0.0
        
            refreshID = UUID()
            dismiss()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
    @State var theDate = Date()
    AddMealView(theDate: $theDate, refreshID: .constant(UUID()))
        .modelContainer(for: [MyMealContentModel.self, ImageColorModel.self])
    }
}
