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
    
    @Query private var myMealContents: [MyMealContentModel]
    @Query private var imageColor: [ImageColorModel]
    
    private var action = Action()
    
    @State private var newMyMealName: String = ""
    @State private var newMyMealProtein: Double = 0.0
    @State private var newMyMealFat: Double = 0.0
    @State private var newMyMealCarbohydrate: Double = 0.0
    @State private var newMyMealKcal: Double = 0.0
    
    @Binding var selectedMealName: String
    @Binding var selectedMealProtein:String
    @Binding var selectedMealFat: String
    @Binding var selectedMealCarbohydrate: String
    @Binding var selectedMealKcal: Double
    
    @State var myMenuAddViewPresented: Bool = false
    
    @State private var errorMessage: String?
    
    init(selectedMealName: Binding<String>, selectedMealProtein: Binding<String>, selectedMealFat: Binding<String>, selectedMealCarbohydrate: Binding<String>, selectedMealKcal: Binding<Double>) {
            self._selectedMealName = selectedMealName
            self._selectedMealProtein = selectedMealProtein
            self._selectedMealFat = selectedMealFat
            self._selectedMealCarbohydrate = selectedMealCarbohydrate
            self._selectedMealKcal = selectedMealKcal
        }
    
    var body: some View {
        VStack {
            List {
                ForEach(myMealContents) { myMealContent in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack() {
                                Text(myMealNameLimit(myMealContent.myMealName))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("\(myMealContent.myMealKcal, specifier: "%.f") kcal")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .font(.title3)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("たんぱく質: \(myMealContent.myMealProtein, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("脂質: \(myMealContent.myMealFat, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("炭水化物: \(myMealContent.myMealCarbohydrate, specifier: "%.1f") g")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .font(.system(size: 15))
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .font(.title3)
                                    .onTapGesture {
                                        selectMyMeal(myMealContent)
                                    }
                                Image(systemName: "trash")
                                    .foregroundStyle(.black)
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
                        red: imageColor.first?.imageColorRed ?? 0,
                        green: imageColor.first?.imageColorGreen ?? 1,
                        blue: imageColor.first?.imageColorBlue ?? 1,
                        opacity: 0.05
                    ))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            BasicButton(title: "マイメニューの追加", widthSize: 210) {
                myMenuAddViewPresented = true
            }
            .sheet(isPresented: $myMenuAddViewPresented) {
                MyMenuAddView(myMenuAddViewPresented: $myMenuAddViewPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
//            Button(action: {
//                myMenuAddViewPresented.toggle()
//            }) {
//                Text("マイメニューの追加")
//            }
//            .font(.title3)
//            .bold()
//            .padding(.horizontal)
//            .frame(width: 210, height: 35)
//            .foregroundStyle(.black)
//            .background(Color(
//                red: imageColor.first?.imageColorRed ?? 0,
//                green: imageColor.first?.imageColorGreen ?? 1,
//                blue: imageColor.first?.imageColorBlue ?? 1,
//                opacity: imageColor.first?.imageColorAlpha ?? 0.2
//            ))
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
            
        }
    }
    
    private func myMealNameLimit(_ text: String) -> String {
        return text.count > 6 ? String(text.prefix(6)) + "…" : text
    }
    
    private func selectMyMeal(_ myMealContent: MyMealContentModel) {
        selectedMealName = myMealContent.myMealName
        selectedMealProtein = String(format: "%.1f", myMealContent.myMealProtein)
        selectedMealFat = String(format: "%.1f", myMealContent.myMealFat)
        selectedMealCarbohydrate = String(format: "%.1f", myMealContent.myMealCarbohydrate)
        selectedMealKcal = myMealContent.myMealKcal
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
    
    private var action = Action()
    
    @State private var newMyMealName: String = ""
    @State private var newMyMealProtein: String = ""
    @State private var newMyMealFat: String = ""
    @State private var newMyMealCarbohydrate: String = ""
    @State private var newMyMealKcal: Double = 0.0
    
    @State private var myMealNameValid: Bool = true
    @State private var myMealProteinValid: Bool = true
    @State private var myMealFatValid: Bool = true
    @State private var myMealCarbohydrateValid: Bool = true
    @State private var myMealKcalValid: Bool = true
    
    @Binding var myMenuAddViewPresented: Bool
    
    init(myMenuAddViewPresented: Binding<Bool>) {
            self._myMenuAddViewPresented = myMenuAddViewPresented
        }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("メニュー")
                        .font(.title3)
                    ZStack(alignment: .leading) {
                        TextField("", text: $newMyMealName)
                            .font(.title3)
                            .foregroundStyle(.black)
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
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                .padding(.top, 30)
            }
            
            HStack {
                Text("たんぱく質")
                    .font(.title3)
                TextField("", text: $newMyMealProtein)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: newMyMealProtein) {
                        if newMyMealProtein.count > 4 {
                            newMyMealProtein = String(newMyMealProtein.prefix(4))
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
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("脂質")
                    .font(.title3)
                TextField("", text: $newMyMealFat)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: newMyMealFat) {
                        if newMyMealFat.count > 4 {
                            newMyMealFat = String(newMyMealFat.prefix(4))
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
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("炭水化物")
                    .font(.title3)
                TextField("", text: $newMyMealCarbohydrate)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 80)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
                    .font(.system(size: 20))
                    .keyboardType(.decimalPad)
                    .onChange(of: newMyMealCarbohydrate) {
                        if newMyMealCarbohydrate.count > 4 {
                            newMyMealCarbohydrate = String(newMyMealCarbohydrate.prefix(4))
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
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("カロリー")
                    .font(.title3)
                TextField("", value: $newMyMealKcal, format: .number)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .padding(4)
                    .frame(width: 100)
                    .background(.white, in: .rect(cornerRadius: 6))
                    .foregroundStyle(.black)
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
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            BasicButton(title: "決定") {
                addMyMeal()
            }
            
//            Button(action: {
//                addMyMeal()
//            }) {
//                Text("決定")
//            }
//            .font(.title3)
//            .bold()
//            .padding(10)
//            .frame(width: 150, height: 35)
//            .foregroundStyle(.black)
//            .background(Color(
//                red: imageColor.first?.imageColorRed ?? 0,
//                green: imageColor.first?.imageColorGreen ?? 1,
//                blue: imageColor.first?.imageColorBlue ?? 1,
//                opacity: imageColor.first?.imageColorAlpha ?? 0.2
//            ))
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
            Spacer()
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("決定") {
                            action.hideKeyboard()
                        }
                        .foregroundStyle(.black)
                    }
                }
                .padding(.top, 100)
        }
    }
    
//    private func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
    
    private func calculateMyKcal() {
        let castingMyProtein = Double(newMyMealProtein) ?? 0
        let castingMyFat = Double(newMyMealFat) ?? 0
        let castingMyCarbohydrate = Double(newMyMealCarbohydrate) ?? 0
        guard castingMyProtein >= 0, castingMyFat >= 0, castingMyCarbohydrate >= 0 else {
            newMyMealKcal = 0.0
            return
        }
        newMyMealKcal = round((castingMyProtein * 4) + (castingMyFat * 9) + (castingMyCarbohydrate * 4))
    }
    
    private func validateMyMealForm() -> Bool {
        var isMyMealValid = true
        
        myMealNameValid = !newMyMealName.isEmpty
        if !myMealNameValid { isMyMealValid = false }
        
        if let castingMyProtein = Double(newMyMealProtein), castingMyProtein >= 0, castingMyProtein <= 9999 {
            myMealProteinValid = true
        } else {
            myMealProteinValid = false
            isMyMealValid = false
        }
        
        if let castingMyFat = Double(newMyMealFat), castingMyFat >= 0, castingMyFat <= 9999 {
            myMealFatValid = true
        } else {
            myMealFatValid = false
            isMyMealValid = false
        }
        
        if let castingMyCarbohydrate = Double(newMyMealCarbohydrate), castingMyCarbohydrate >= 0, castingMyCarbohydrate <= 9999 {
            myMealCarbohydrateValid = true
        } else {
            myMealCarbohydrateValid = false
            isMyMealValid = false
        }
        
        myMealKcalValid = newMyMealKcal >= 0
        if !myMealKcalValid { isMyMealValid = false }
        
        return isMyMealValid
    }
    
    private func addMyMeal() {
        if !validateMyMealForm() {
            return
        }
        let newMyMeal = MyMealContentModel(myMealName: newMyMealName, myMealProtein: Double(newMyMealProtein) ?? 0, myMealFat: Double(newMyMealFat) ?? 0, myMealCarbohydrate: Double(newMyMealCarbohydrate) ?? 0, myMealKcal: newMyMealKcal)
        context.insert(newMyMeal)
        
        do {
            try context.save()
            print("MyMeal saved successfully")
            newMyMealName = ""
            newMyMealProtein = ""
            newMyMealFat = ""
            newMyMealCarbohydrate = ""
            newMyMealKcal = 0.0
            
            myMenuAddViewPresented.toggle()
            
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
