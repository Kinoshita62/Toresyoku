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
    @State private var isKcalValid: Bool = false
    @State private var isProteinValid: Bool = false
    @State private var isFatValid: Bool = false
    @State private var isCarbohydrateValid: Bool = false
    @State private var addMealModal: Bool = false
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 1
    
    @Binding var refreshID: UUID
    
    var buttonBackgroundColor: Color {
        return isFormValid() ? Color(
            red: ImageColor.first?.R ?? 0,
            green: ImageColor.first?.G ?? 1,
            blue: ImageColor.first?.B ?? 1,
            opacity: ImageColor.first?.A ?? 1
        ) : Color.gray
    }

    var body: some View {
        VStack {
            HStack {
                DatePicker("日付を選択", selection: $MealDate, displayedComponents: [.date])
                    .environment(\.locale, Locale(identifier: "ja_JP"))
            }
            .padding()
            
            HStack {
                Text("メニュー")
                ZStack(alignment: .leading) {
                    TextField("", text: $MealName)
                        .foregroundColor(.black)  // 通常のテキストの色を設定
                        .padding(4)
                        .background(.white, in: .rect(cornerRadius: 6))
                        .font(.system(size: 25))
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
                    .foregroundColor(.black)
                    .padding(10)
                    .frame(width: 200, height: 40)
                    .background(Color(
                        red: ImageColor.first?.R ?? 0,
                        green: ImageColor.first?.G ?? 1,
                        blue: ImageColor.first?.B ?? 1,
                        opacity: ImageColor.first?.A ?? 1
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
                TextField("", text: $MealProtein)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: MealProtein) {
                        calculateKcal()
                    }
                    .overlay(  // 枠線を追加
                           RoundedRectangle(cornerRadius: 6)
                               .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                       )
                Text("g")
                if isProteinValid {
                    Text("有効な値を入力してください")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("脂質")
                TextField("", text: $MealFat)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: MealFat) {
                        calculateKcal()
                    }
                    .overlay(  // 枠線を追加
                           RoundedRectangle(cornerRadius: 6)
                               .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                       )
                Text("g")
                if isFatValid {
                    Text("有効な値を入力してください")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("炭水化物")
                TextField("", text: $MealCarbohydrate)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: MealCarbohydrate) {
                        calculateKcal()
                    }
                    .overlay(  // 枠線を追加
                           RoundedRectangle(cornerRadius: 6)
                               .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                       )
                Text("g")
                if isCarbohydrateValid {
                    Text("有効な値を入力してください")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            HStack {
                Text("カロリー")
                TextField("", value: $MealKcal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .overlay(  // 枠線を追加
                           RoundedRectangle(cornerRadius: 6)
                               .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                       )
                Text("kcal")
                if isKcalValid {
                    Text("有効な値を入力してください")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            Button("決定") {
                addMeal()
            }
            .padding()
            .frame(width: 200, height: 35)
            .foregroundColor(.black)
            .background(buttonBackgroundColor)
            .cornerRadius(10)
            .disabled(!isFormValid())
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(Color.gray, lineWidth: 1)
            )
            Spacer()
            
            Spacer()
        }
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

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(refreshID: .constant(UUID()))
            .modelContainer(for: [MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
