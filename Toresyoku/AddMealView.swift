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
    @State private var isKcalValid: Bool = false
    @State private var isProteinValid: Bool = false
    @State private var isFatValid: Bool = false
    @State private var isCarbohydrateValid: Bool = false
    @State private var addMealModal: Bool = false
    
    @Binding var refreshID: UUID

    var body: some View {
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
                    .onChange(of: MealProtein) {
                        calculateKcal()
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
                    .onChange(of: MealFat) {
                        calculateKcal()
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
                    .onChange(of: MealCarbohydrate) {
                        calculateKcal()
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
            .padding(.bottom)
            
            HStack {
                Text("カロリー")
                TextField("-", value: $MealKcal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Text("kcal")
                if isKcalValid {
                    Text("有効な値を入力してください")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Button("決定") {
                addMeal()
            }
            .padding()
            .frame(width: 200, height: 35)
            .foregroundColor(.black)
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(MealProtein <= 0 || MealFat <= 0 || MealCarbohydrate <= 0)
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
        guard MealProtein > 0, MealFat > 0, MealCarbohydrate > 0 else {
            MealKcal = 0.0
            return
        }
        MealKcal = round((MealProtein * 4) + (MealFat * 9) + (MealCarbohydrate * 4))
    }
    
    private func addMeal() {
        if MealKcal < 0 {
            isKcalValid = true
        } else {
            isKcalValid = false
        }
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
        try? context.save() // 追加: データベースに変更を保存
            refreshID = UUID()  
        presentation.wrappedValue.dismiss()
    }
}

struct AddMealView_Previews: PreviewProvider {
    @State static var refreshID = UUID()
    static var previews: some View {
        AddMealView(refreshID: $refreshID)
            .modelContainer(for: MealContentModel.self, inMemory: true)
    }
}
