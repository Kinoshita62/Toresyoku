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
    @Environment(\.presentationMode) var presentation
    
    @State private var MealName: String = ""
    @State private var MealProtein: Double = 0.0
    @State private var MealFat: Double = 0.0
    @State private var MealCarbohydrate: Double = 0.0
    @State private var MealKcal: Double = 0.0
    @State private var MealDate: Date = Date()

    
    
    @State var myMenuSelectModal: Bool = false
    @State private var isProteinValid: Bool = false
    @State private var isFatValid: Bool = false
    @State private var isCarbohydrateValid: Bool = false
    @State private var addMealModal: Bool = false

    var body: some View {
        Color.orange.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
            .overlay {
                VStack {
                    HStack {
                        DatePicker("日付を選択", selection: $MealDate, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                        }
                    
                    .padding()
                    
                    
                    HStack {
                        TextField("メニュー", text: $MealName)
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
                        TextField("-", value: $MealProtein, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("決定") {
                                        hideKeyboard()
                                    }
                                }
                            }
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
                        TextField("-", value: $MealFat, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("決定") {
                                        hideKeyboard()
                                    }
                                }
                            }
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
                        TextField("-", value: $MealCarbohydrate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("決定") {
                                        hideKeyboard()
                                    }
                                }
                            }
                        Text("g")
                        if isCarbohydrateValid {
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
                                Text("\(MealKcal, specifier: "%.1f")")
                            }
                        Text("kcal")

                        Spacer()
                    }
                    .padding()
                    
                    Button("決定") {
                        addMeal()
                    }
                    .padding()
                    .frame(width: 200, height: 35)
                    .foregroundColor(.black)
                    .background(Color.gray)
                    .cornerRadius(10)

                    Spacer()
                }
                .padding(.top, 100)
            }
    }

    func calculateKcal() {
//        guard MealProtein >= 0,
//              MealFat >= 0,
//              MealCarbohydrate >= 0 else {
//            return
//        }
       MealKcal = MealProtein * 4 + MealFat * 9 + MealCarbohydrate * 4
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
    private func addMeal() {
        if MealProtein < 0 {
            isProteinValid = true
        } else {
            isProteinValid = false
        }
        if MealFat < 0 {
            isFatValid = true
        } else {
            isFatValid = false
        }
        if MealCarbohydrate < 0 {
            isCarbohydrateValid = true
        } else {
            isCarbohydrateValid = false
        }
        guard MealProtein >= 0, MealFat >= 0, MealCarbohydrate >= 0, MealKcal >= 0 else {
            return
        }
        let newMeal = MealContentModel(MealName: MealName, MealProtein: MealProtein, MealFat: MealFat, MealCarbohydrate: MealCarbohydrate, MealKcal: MealKcal, MealDate: MealDate)
        context.insert(newMeal)
        presentation.wrappedValue.dismiss()
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView()
            .modelContainer(for: MealContentModel.self, inMemory: true)
    }
}
