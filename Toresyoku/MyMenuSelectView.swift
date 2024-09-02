//
//  MyMenuSelectView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MyMenuSelectView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var MyMealContents: [MyMealContentModel]
    @Query private var imageColor: [ImageColorModel]
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @Binding var selectedMealName: String
    @Binding var selectedMealProtein:String
    @Binding var selectedMealFat: String
    @Binding var selectedMealCarbohydrate: String
    @Binding var selectedMealKcal: Double
    
    @State var MyMenuAddViewPresented: Bool = false
    
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            List {
                ForEach(MyMealContents) { myMealContent in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack() {
                                Text(myMealNameLimit(myMealContent.MyMealName))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("\(myMealContent.MyMealKcal, specifier: "%.f") kcal")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .font(.title3)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("たんぱく質: \(myMealContent.MyMealProtein, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("脂質: \(myMealContent.MyMealFat, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("炭水化物: \(myMealContent.MyMealCarbohydrate, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .font(.system(size: 15))
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .onTapGesture {
                                        selectMyMeal(myMealContent)
                                    }
                                Image(systemName: "trash")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .padding(.leading, 20)
                                    .onTapGesture {
                                        deleteMyMeal(myMealContent)
                                    }
                            }
                            .font(.title2)
                        }
                    }
                    .listRowSeparatorTint(Color.black)
                    .listRowBackground(Color(
                        red: imageColor.first?.R ?? 0,
                        green: imageColor.first?.G ?? 1,
                        blue: imageColor.first?.B ?? 1,
                        opacity: 0.05
                    ))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            Button(action: {
                MyMenuAddViewPresented.toggle()
            }) {
                Text("マイメニューの追加")
            }
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .frame(width: 210, height: 35)
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
            .sheet(isPresented: $MyMenuAddViewPresented) {
                MyMenuAddView(MyMenuAddViewPresented: $MyMenuAddViewPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func myMealNameLimit(_ text: String) -> String {
        return text.count > 6 ? String(text.prefix(6)) + "…" : text
    }
    
    private func selectMyMeal(_ myMealContent: MyMealContentModel) {
        selectedMealName = myMealContent.MyMealName
        selectedMealProtein = String(format: "%.1f", myMealContent.MyMealProtein)
        selectedMealFat = String(format: "%.1f", myMealContent.MyMealFat)
        selectedMealCarbohydrate = String(format: "%.1f", myMealContent.MyMealCarbohydrate)
        selectedMealKcal = myMealContent.MyMealKcal
        dismiss()
    }
    
    private func deleteMyMeal(_ myMealContent: MyMealContentModel) {
        do {
            context.delete(myMealContent)
            try context.save()
        } catch {
            errorMessage = "削除に失敗しました: \(error.localizedDescription)"
        }
    }
}

struct MyMenuAddView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var imageColor: [ImageColorModel]
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: String = ""
    @State private var MyMealFat: String = ""
    @State private var MyMealCarbohydrate: String = ""
    @State private var MyMealKcal: Double = 0.0
    
    @State private var myMealNameValid: Bool = true
    @State private var myMealProteinValid: Bool = true
    @State private var myMealFatValid: Bool = true
    @State private var myMealCarbohydrateValid: Bool = true
    @State private var myMealKcalValid: Bool = true

    @Binding var MyMenuAddViewPresented: Bool
        
    var body: some View {
        VStack {
            HStack {
                Text("メニュー")
                    .font(.title3)
                ZStack(alignment: .leading) {
                    TextField("", text: $MyMealName)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(4)
                        .background(.white, in: .rect(cornerRadius: 6))
                        .font(.system(size: 25))
                        .frame(width: 220)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
                if myMealNameValid == false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .padding(.top, 30)
        }
        
        HStack {
            Text("たんぱく質")
                .font(.title3)
            TextField("", text: $MyMealProtein)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 80)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.decimalPad)
                .onChange(of: MyMealProtein) {
                    if MyMealProtein.count > 4 {
                        MyMealProtein = String(MyMealProtein.prefix(4))
                    }
                    calculateMyKcal()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("g")
                .font(.title3)
            Spacer()
            if myMealProteinValid == false {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        
        HStack {
            Text("脂質")
                .font(.title3)
            TextField("", text: $MyMealFat)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 80)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.decimalPad)
                .onChange(of: MyMealFat) {
                    if MyMealFat.count > 4 {
                        MyMealFat = String(MyMealFat.prefix(4))
                    }
                    calculateMyKcal()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("g")
                .font(.title3)
            Spacer()
            if myMealFatValid == false {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        
        HStack {
            Text("炭水化物")
                .font(.title3)
            TextField("", text: $MyMealCarbohydrate)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 80)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.decimalPad)
                .onChange(of: MyMealCarbohydrate) {
                    if MyMealCarbohydrate.count > 4 {
                        MyMealCarbohydrate = String(MyMealCarbohydrate.prefix(4))
                    }
                    calculateMyKcal()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("g")
                .font(.title3)
            Spacer()
            if myMealCarbohydrateValid == false {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        
        HStack {
            Text("カロリー")
                .font(.title3)
            TextField("", value: $MyMealKcal, format: .number)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 100)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.decimalPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Text("kcal")
                .font(.title3)
            Spacer()
            if myMealKcalValid == false {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
        
        Button(action: {
            addMyMeal()
        }) {
            Text("決定")
        }
        .font(.title3)
        .bold()
        .padding(10)
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
    
    private func calculateMyKcal() {
        let protein = Double(MyMealProtein) ?? 0
        let fat = Double(MyMealFat) ?? 0
        let carbohydrate = Double(MyMealCarbohydrate) ?? 0
        guard protein >= 0, fat >= 0, carbohydrate >= 0 else {
            MyMealKcal = 0.0
            return
        }
        MyMealKcal = round((protein * 4) + (fat * 9) + (carbohydrate * 4))
    }
    
    private func validateMyMealForm() -> Bool {
        var isMyMealValid = true

        myMealNameValid = !MyMealName.isEmpty
        if !myMealNameValid { isMyMealValid = false }

        if let myProtein = Double(MyMealProtein), myProtein >= 0, myProtein <= 9999 {
            myMealProteinValid = true
        } else {
            myMealProteinValid = false
            isMyMealValid = false
        }

        if let myFat = Double(MyMealFat), myFat >= 0, myFat <= 9999 {
            myMealFatValid = true
        } else {
            myMealFatValid = false
            isMyMealValid = false
        }

        if let myCarbohydrate = Double(MyMealCarbohydrate), myCarbohydrate >= 0, myCarbohydrate <= 9999 {
            myMealCarbohydrateValid = true
        } else {
            myMealCarbohydrateValid = false
            isMyMealValid = false
        }

        myMealKcalValid = MyMealKcal >= 0
        if !myMealKcalValid { isMyMealValid = false }

        return isMyMealValid
    }
    
    private func addMyMeal() {
        if !validateMyMealForm() {
            return
        }
        let newMyMeal = MyMealContentModel(MyMealName: MyMealName, MyMealProtein: Double(MyMealProtein) ?? 0, MyMealFat: Double(MyMealFat) ?? 0, MyMealCarbohydrate: Double(MyMealCarbohydrate) ?? 0, MyMealKcal: MyMealKcal)
        context.insert(newMyMeal)
        
        do {
            try context.save()
            print("MyMeal saved successfully")
            MyMealName = ""
            MyMealProtein = ""
            MyMealFat = ""
            MyMealCarbohydrate = ""
            MyMealKcal = 0.0
            
            MyMenuAddViewPresented.toggle()
            
            dismiss()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}


struct MyMenuSelectView_Previews: PreviewProvider {
    
    @State static var selectedMealName = "Sample Meal"
    @State static var selectedMealProtein = "10.0"
    @State static var selectedMealFat = "5.0"
    @State static var selectedMealCarbohydrate = "20.0"
    @State static var selectedMealKcal: Double = 200.0
    
    static var previews: some View {
        MyMenuSelectView(
            selectedMealName: $selectedMealName,
            selectedMealProtein: $selectedMealProtein,
            selectedMealFat: $selectedMealFat,
            selectedMealCarbohydrate: $selectedMealCarbohydrate,
            selectedMealKcal: $selectedMealKcal
        )
        .modelContainer(for: [MyMealContentModel.self, ImageColorModel.self])
    }
}
