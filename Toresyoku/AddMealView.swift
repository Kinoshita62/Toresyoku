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
    
    @Query private var MyMealContents: [MyMealContentModel]
    @Query private var imageColor: [ImageColorModel]
    
    @State private var MealName: String = ""
    @State private var MealProtein: String = ""
    @State private var MealFat: String = ""
    @State private var MealCarbohydrate: String = ""
    @State private var MealKcal: Double = 0.0
    @State private var MealDate: Date
    
    @State private var myMenuSelectModal: Bool = false
    @State private var addMealModal: Bool = false
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @State private var mealNameValid: Bool = true
    @State private var mealProteinValid: Bool = true
    @State private var mealFatValid: Bool = true
    @State private var mealCarbohydrateValid: Bool = true
    @State private var mealKcalValid: Bool = true
    
    @State private var MealDateSelectPresented: Bool = false
    
    @Binding var refreshID: UUID
    @Binding var theDate: Date
    
    init(theDate: Binding<Date>, refreshID: Binding<UUID>) {
            self._theDate = theDate
            self._refreshID = refreshID
            self._MealDate = State(initialValue: theDate.wrappedValue)
        }
    
    var body: some View {
        VStack {
            HStack {
                Text("メニュー")
                    .font(.title3)
                TextField("", text: $MealName)
                    .foregroundColor(.black)
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
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            

            HStack {
                Text("マイメニューから選択")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .padding(10)
                    .frame(width: 210, height: 35)
                    .background(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: imageColor.first?.A ?? 0.2
                    ))
                    .cornerRadius(10)
                    .overlay(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        myMenuSelectModal = true
                    }
                    .sheet(isPresented: $myMenuSelectModal) {
                        MyMenuSelectView(
                            selectedMealName: $MealName,
                            selectedMealProtein: $MealProtein,
                            selectedMealFat: $MealFat,
                            selectedMealCarbohydrate: $MealCarbohydrate,
                            selectedMealKcal: $MealKcal
                        )
                        .presentationDragIndicator(.visible)
                    }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            HStack {
                Text("たんぱく質")
                    .font(.title3)
                TextField("", text: $MealProtein)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: MealProtein) {
                        if MealProtein.count > 4 {
                            MealProtein = String(MealProtein.prefix(4))
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
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)

            HStack {
                Text("脂質")
                    .font(.title3)
                TextField("", text: $MealFat)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: MealFat) {
                        if MealFat.count > 4 {
                            MealFat = String(MealFat.prefix(4))
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
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)

            HStack {
                Text("炭水化物")
                    .font(.title3)
                TextField("", text: $MealCarbohydrate)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .keyboardType(.decimalPad)
                    .onChange(of: MealCarbohydrate) {
                        if MealCarbohydrate.count > 4 {
                            MealCarbohydrate = String(MealCarbohydrate.prefix(4))
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
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            HStack {
                Text("カロリー")
                    .font(.title3)
                TextField("", value: $MealKcal, format: .number)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 100)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
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
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            HStack {
                Spacer()
                Button("戻る") {
                    dismiss()
                }
                .font(.title3)
                .bold()
                .padding()
                .frame(width: 100, height: 35)
                .foregroundColor(.black)
                .background(Color.gray .opacity(0.8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                Spacer()
                Button("決定") {
                    addMeal()
                }
                .font(.title3)
                .bold()
                .padding()
                .frame(width: 150, height: 35)
                .foregroundColor(.black)
                .background(Color(
                    red: imageColor.first?.R ?? 0,
                    green: imageColor.first?.G ?? 1,
                    blue: imageColor.first?.B ?? 1,
                    opacity: imageColor.first?.A ?? 0.2
                ))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                Spacer()
            }
        }
        .onAppear {
                    self.MealDate = theDate
                }
                .onChange(of: theDate) {
                    self.MealDate = theDate
                }
        Spacer()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("決定") {
                    hideKeyboard()
                }
                .foregroundColor(.black)
            }
        }
        .padding(.top, 100)
        .navigationBarBackButtonHidden(true)
    }
        
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateKcal() {
        let protein = Double(MealProtein) ?? 0
        let fat = Double(MealFat) ?? 0
        let carbohydrate = Double(MealCarbohydrate) ?? 0
        guard protein >= 0, fat >= 0, carbohydrate >= 0 else {
            MealKcal = 0.0
            return
        }
        MealKcal = round((protein * 4) + (fat * 9) + (carbohydrate * 4))
    }
    
    private func validateForm() -> Bool {
        var isValid = true

        mealNameValid = !MealName.isEmpty
        if !mealNameValid { isValid = false }

        if let protein = Double(MealProtein), protein >= 0, protein <= 9999 {
            mealProteinValid = true
        } else {
            mealProteinValid = false
            isValid = false
        }

        if let fat = Double(MealFat), fat >= 0, fat <= 9999 {
            mealFatValid = true
        } else {
            mealFatValid = false
            isValid = false
        }

        if let carbohydrate = Double(MealCarbohydrate), carbohydrate >= 0, carbohydrate <= 9999 {
            mealCarbohydrateValid = true
        } else {
            mealCarbohydrateValid = false
            isValid = false
        }

        mealKcalValid = MealKcal >= 0
        if !mealKcalValid { isValid = false }

        return isValid
    }

    
    private func addMeal() {
        if !validateForm() {
            return
        }
        let newMeal = MealContentModel(MealName: MealName, MealProtein: Double(MealProtein) ?? 0, MealFat: Double(MealFat) ?? 0, MealCarbohydrate: Double(MealCarbohydrate) ?? 0, MealKcal: MealKcal, MealDate: MealDate)
        context.insert(newMeal)
        
        do {
            try context.save()
            print("Meal saved successfully")
            MealName = ""
            MealProtein = ""
            MealFat = ""
            MealCarbohydrate = ""
            MealKcal = 0.0

            refreshID = UUID()
            dismiss()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

struct MealDateSelectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var MealDate: Date
    var body: some View {
        DatePicker("", selection: $MealDate, displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
            .onChange(of: MealDate) {
                dismiss()
            }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        @State var theDate = Date()
        AddMealView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
