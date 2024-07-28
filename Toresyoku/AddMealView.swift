//
//  AddMealView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI

struct AddMealView: View {

    @ObservedObject var mealContentModel = MealContentModel()
    @ObservedObject var mealListModel: MealListModel
    @State var myMenuSelectModal: Bool = false
    @Binding var addMealPresented: Bool
    @State private var isFormValid: Bool = true
    @State private var isProteinValid: Bool = true
    @State private var isFatValid: Bool = true
    @State private var isCarbohydrateValid: Bool = true

    var body: some View {
        Color.orange.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
            .overlay {
                VStack {
                    HStack {
                        TextField("メニュー", text: $mealContentModel.MealName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250)
                        Spacer()
                        Label("検索", systemImage: "magnifyingglass")
                            .padding()
                            .frame(width: 100, height: 35)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("マイメニューから選択")
                            .padding(10)
                            .frame(width: 200, height: 40)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .onTapGesture {
                                myMenuSelectModal = true
                            }
                            .sheet(isPresented: $myMenuSelectModal) {
                                MyMenuSelectView()
                                    .presentationDragIndicator(.visible)
                            }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)

                    HStack {
                        Text("たんぱく質")
                        TextField("-", value: $mealContentModel.MealProtein, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            
                        Text("g")
                        if !isProteinValid {
                            Text("有効な値を入力してください")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("脂質")
                        TextField("-", value: $mealContentModel.MealFat, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                           
                        Text("g")
                        if !isFatValid {
                            Text("有効な値を入力してください")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("炭水化物")
                        TextField("-", value: $mealContentModel.MealCarbohydrate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)

                        Text("g")
                        if !isCarbohydrateValid {
                            Text("有効な値を入力してください")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("カロリー")
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 30)
                            .cornerRadius(5)
                            .overlay {
                                Text("\(mealContentModel.MealKcal, specifier: "%.1f")")
                            }
                        Text("kcal")
                        Spacer()
                    }
                    .padding()

                    HStack {
                        Button("決定") {
                            if validateInputs() {
                                decisionMeal()
                                addMealPresented = false
                            }
                        }
                        .padding()
                        .frame(width: 100, height: 35)
                        .foregroundColor(.black)
                        .background(isFormValid ? Color(red: 0.4, green: 0.8, blue: 1.0) : Color.gray)
                        .cornerRadius(10)
                        .disabled(!isFormValid)
                        Spacer()
                    }
                    .padding()

                    Button("キーボードを閉じる") {
                        hideKeyboard()
                    }
                    .padding()
                    .frame(width: 200, height: 35)
                    .foregroundColor(.black)
                    .background(Color.gray)
                    .cornerRadius(10)

                    Spacer()
                }
                .padding(.top, 200)
            }
    }

    func validateInputs() -> Bool {
        isProteinValid = mealContentModel.MealProtein > 0
        isFatValid = mealContentModel.MealFat > 0
        isCarbohydrateValid = mealContentModel.MealCarbohydrate > 0
        isFormValid = isProteinValid && isFatValid && isCarbohydrateValid
        return isFormValid
    }

    func decisionMeal() {
        mealListModel.addMeal(mealContentModel)
        print("Meal added: \(mealContentModel.MealName)")
    }

    func calculateKcal() {
        guard mealContentModel.MealProtein >= 0,
              mealContentModel.MealFat >= 0,
              mealContentModel.MealCarbohydrate >= 0 else {
            return
        }
        mealContentModel.MealKcal = mealContentModel.MealProtein * 4 + mealContentModel.MealFat * 9 + mealContentModel.MealCarbohydrate * 4
    }

    // キーボードを閉じる関数
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(mealListModel: MealListModel(), addMealPresented: .constant(true))
    }
}
