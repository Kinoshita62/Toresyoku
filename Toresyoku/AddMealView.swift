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
    
//    @Query private var myMealContents: [MyMealContentModel]
    @Query private var imageColor: [ImageColorModel]
    
    @State private var newMealName: String = ""
    @State private var newMealProtein: String = ""
    @State private var newMealFat: String = ""
    @State private var newMealCarbohydrate: String = ""
    @State private var newMealKcal: Double = 0.0
    @State private var newMealDate: Date
    
    @State private var myMenuSelectModal: Bool = false
    @State private var addMealModal: Bool = false
    
//    @State private var MyMealName: String = ""
//    @State private var MyMealProtein: Double = 0.0
//    @State private var MyMealFat: Double = 0.0
//    @State private var MyMealCarbohydrate: Double = 0.0
//    @State private var MyMealKcal: Double = 0.0
    
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
    
    var body: some View {
        VStack {
            HStack {
                Text("メニュー")
                    .font(.title3)
                TextField("", text: $newMealName)
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
                            selectedMealName: $newMealName,
                            selectedMealProtein: $newMealProtein,
                            selectedMealFat: $newMealFat,
                            selectedMealCarbohydrate: $newMealCarbohydrate,
                            selectedMealKcal: $newMealKcal
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
                TextField("", text: $newMealProtein)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
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
                        .foregroundColor(.red)
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
                    .foregroundColor(.black)
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
                        .foregroundColor(.red)
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
                    .foregroundColor(.black)
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
                        .foregroundColor(.red)
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
                    self.newMealDate = theDate
                }
                .onChange(of: theDate) {
                    self.newMealDate = theDate
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

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        @State var theDate = Date()
        AddMealView(theDate: $theDate, refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
