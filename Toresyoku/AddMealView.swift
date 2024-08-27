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
    @Query private var ImageColor: [ImageColorModel]
    
    @State private var MealName: String = ""
    @State private var MealProtein: String = ""
    @State private var MealFat: String = ""
    @State private var MealCarbohydrate: String = ""
    @State private var MealKcal: Double = 0.0
    @State private var MealDate: Date = Date()

    @State var myMenuSelectModal: Bool = false
    @State private var addMealModal: Bool = false
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 0.2
    
    @State private var MealDateSelectPresented: Bool = false
    
    @Binding var refreshID: UUID
    
    var buttonBackgroundColor: Color {
        return isFormValid() ? Color(
            red: ImageColor.first?.R ?? 0,
            green: ImageColor.first?.G ?? 1,
            blue: ImageColor.first?.B ?? 1,
            opacity: ImageColor.first?.A ?? 0.2
        ) : Color.gray
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("日付")
                    .font(.title3)
                Button {
                    MealDateSelectPresented.toggle()
                } label: {
                    Text(dateFormat.string(from: MealDate))
                        .font(.title3)
                }
                .sheet(isPresented: $MealDateSelectPresented) {
                    MealDateSelectView(MealDate: $MealDate)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
            }
            .padding()
            
            HStack {
                Text("メニュー")
                    .font(.title3)
                ZStack(alignment: .leading) {
                    TextField("", text: $MealName)
                        .foregroundColor(.black)
                        .padding(4)
                        .background(.white, in: .rect(cornerRadius: 6))
                        .font(.title3)
                        .frame(width: 250)
                        .overlay(
                               RoundedRectangle(cornerRadius: 6)
                                   .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
            }
            .padding(.horizontal)
            

            HStack {
                Text("マイメニューから選択")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(10)
                    .frame(width: 210, height: 35)
                    .background(Color(
                        red: ImageColor.first?.R ?? 0,
                        green: ImageColor.first?.G ?? 1,
                        blue: ImageColor.first?.B ?? 1,
                        opacity: ImageColor.first?.A ?? 0.2
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
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            Button("決定") {
                addMeal()
            }
            .font(.title3)
            .padding()
            .frame(width: 150, height: 35)
            .foregroundColor(.black)
            .background(buttonBackgroundColor)
            .cornerRadius(10)
            .disabled(!isFormValid())
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(Color.gray, lineWidth: 1)
            )
            Spacer()
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
    
    private func isFormValid() -> Bool {
        let protein = Double(MealProtein) ?? 0
        let fat = Double(MealFat) ?? 0
        let carbohydrate = Double(MealCarbohydrate) ?? 0
        return !MealName.isEmpty && protein >= 0 && fat >= 0 && carbohydrate >= 0 && MealKcal >= 0
    }
    
    private func addMeal() {
        let protein = Double(MealProtein) ?? 0
        let fat = Double(MealFat) ?? 0
        let carbohydrate = Double(MealCarbohydrate) ?? 0
        
        if !isFormValid() {
            return
        }
        print("Form validation passed")
        let newMeal = MealContentModel(MealName: MealName, MealProtein: protein, MealFat: fat, MealCarbohydrate: carbohydrate, MealKcal: MealKcal, MealDate: MealDate)
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
        AddMealView(refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
