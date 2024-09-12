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
            HStack {
                Text("メニュー")
                    .font(.title3)
                TextField("", text: $newMealName)
                    .foregroundStyle(.black)
                    .padding(4)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .font(.title3)
                    .frame(width: 220)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Spacer()
                if mealNameValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
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
            HStack {
                Text("たんぱく質")
                    .font(.title3)
                TextField("", text: $newMealProtein)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: newMealProtein) {
                        if newMealProtein.count > 4 {
                            newMealProtein = String(newMealProtein.prefix(4))
                        }
                        calculateKcal()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g")
                    .font(.title3)
                Spacer()
                if mealProteinValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("脂質")
                    .font(.title3)
                TextField("", text: $newMealFat)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: newMealFat) {
                        if newMealFat.count > 4 {
                            newMealFat = String(newMealFat.prefix(4))
                        }
                        calculateKcal()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g")
                    .font(.title3)
                Spacer()
                if mealFatValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("炭水化物")
                    .font(.title3)
                TextField("", text: $newMealCarbohydrate)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: newMealCarbohydrate) {
                        if newMealCarbohydrate.count > 4 {
                            newMealCarbohydrate = String(newMealCarbohydrate.prefix(4))
                        }
                        calculateKcal()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("g")
                    .font(.title3)
                Spacer()
                if mealCarbohydrateValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            HStack {
                Text("カロリー")
                    .font(.title3)
                TextField("", value: $newMealKcal, format: .number)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 100)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .keyboardType(.decimalPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("kcal")
                    .font(.title3)
                Spacer()
                if mealKcalValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
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
        let castingProtein = Double(newMealProtein) ?? 0
        let castingFat = Double(newMealFat) ?? 0
        let castingCarbohydrate = Double(newMealCarbohydrate) ?? 0
    
        guard castingProtein >= 0, castingFat >= 0, castingCarbohydrate >= 0 else {
            newMealKcal = 0.0
            return
        }
        newMealKcal = round((castingProtein * 4) + (castingFat * 9) + (castingCarbohydrate * 4))
    }

    private func validateForm() -> Bool {
        var isValid = true
        mealNameValid = !newMealName.isEmpty
        if !mealNameValid { isValid = false }
    
        if let castingProtein = Double(newMealProtein), castingProtein >= 0, castingProtein <= 9999 {
            mealProteinValid = true
        } else {
            mealProteinValid = false
            isValid = false
        }
    
        if let castingFat = Double(newMealFat), castingFat >= 0, castingFat <= 9999 {
            mealFatValid = true
        } else {
            mealFatValid = false
            isValid = false
        }
    
        if let castingCarbohydrate = Double(newMealCarbohydrate), castingCarbohydrate >= 0, castingCarbohydrate <= 9999 {
            mealCarbohydrateValid = true
        } else {
            mealCarbohydrateValid = false
            isValid = false
        }
    
        mealKcalValid = newMealKcal >= 0
        if !mealKcalValid { isValid = false }
    
        return isValid
    }

    private func addMeal() {
        if !validateForm() {
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
