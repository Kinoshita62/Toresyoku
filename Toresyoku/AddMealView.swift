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
    @State private var MealProtein: Double = 0.0
    @State private var MealFat: Double = 0.0
    @State private var MealCarbohydrate: Double = 0.0
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
    @State var G: Double = 255
    @State var B: Double = 255
    @State var A: Double = 1
    
    @Binding var refreshID: UUID
    
    var buttonBackgroundColor: Color {
        return isFormValid() ? Color(
            red: ImageColor.first?.R ?? 0 / 255,
            green: ImageColor.first?.G ?? 255 / 255,
            blue: ImageColor.first?.B ?? 255 / 255,
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
                        .overlay(  // 枠線を追加
                               RoundedRectangle(cornerRadius: 6)
                                   .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
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
                        red: ImageColor.first?.R ?? 0 / 255,
                        green: ImageColor.first?.G ?? 255 / 255,
                        blue: ImageColor.first?.B ?? 255 / 255,
                        opacity: ImageColor.first?.A ?? 1
                    ))
                    .cornerRadius(10)
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
            .padding(.bottom, 50)
            
            HStack {
                Text("たんぱく質")
                TextField("", value: $MealProtein, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.numberPad)
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
                TextField("", value: $MealFat, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.numberPad)
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
                TextField("", value: $MealCarbohydrate, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 60)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .keyboardType(.numberPad)
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
                    .keyboardType(.numberPad)
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
            Spacer()
            
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("決定") {
                    hideKeyboard()
                }
            }
        }
        .padding(.top, 100)
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
    private func calculateKcal() {
        guard MealProtein >= 0, MealFat >= 0, MealCarbohydrate >= 0 else {
            MealKcal = 0.0
            return
        }
        MealKcal = round((MealProtein * 4) + (MealFat * 9) + (MealCarbohydrate * 4))
    }
    
    private func isFormValid() -> Bool {
        return !MealName.isEmpty && MealProtein >= 0 && MealFat >= 0 && MealCarbohydrate >= 0 && MealKcal >= 0
    }
    
    private func addMeal() {
        if !isFormValid() {
            return
        }
        print("Form validation passed")
        let newMeal = MealContentModel(MealName: MealName, MealProtein: MealProtein, MealFat: MealFat, MealCarbohydrate: MealCarbohydrate, MealKcal: MealKcal, MealDate: MealDate)
        context.insert(newMeal)
        do {
            try context.save()
            print("Meal saved successfully")
            refreshID = UUID()
            dismiss()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    @State static var refreshID = UUID()
    static var previews: some View {
        AddMealView(refreshID: $refreshID)
            .modelContainer(for: [MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
