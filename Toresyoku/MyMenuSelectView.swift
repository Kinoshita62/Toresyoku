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
    @Environment(\.presentationMode) var presentation
    
    @Query private var MyMealContents: [MyMealContentModel]
    @Query private var ImageColor: [ImageColorModel]
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @State var R: Double = 0
    @State var G: Double = 255
    @State var B: Double = 255
    @State var A: Double = 1
    
    @Binding var selectedMealName: String
    @Binding var selectedMealProtein: Double
    @Binding var selectedMealFat: Double
    @Binding var selectedMealCarbohydrate: Double
    @Binding var selectedMealKcal: Double
    
    @State var MyMenuAddViewPresented: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(MyMealContents) { myMealContent in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                Spacer()
                                Text(myMealContent.MyMealName)
                                Spacer()
                                Text("\(myMealContent.MyMealKcal, specifier: "%.1f") kcal")
                                Spacer()
                            }
                            .font(.title3)
                            Spacer()
                            VStack {
                                Text("たんぱく質: \(myMealContent.MyMealProtein, specifier: "%.1f") g")
                                Text("脂質: \(myMealContent.MyMealFat, specifier: "%.1f") g")
                                Text("炭水化物: \(myMealContent.MyMealCarbohydrate, specifier: "%.1f") g")
                            }
                            .font(.system(size: 15))
                            Spacer()
                            Button(action: {
                                selectMeal(myMealContent)
                            }) {
                                Text("決定")
                            }
                            .padding(10)
                            .foregroundColor(.black)
                            .background(Color(
                                red: ImageColor.first?.R ?? 0 / 255,
                                green: ImageColor.first?.G ?? 255 / 255,
                                blue: ImageColor.first?.B ?? 255 / 255,
                                opacity: ImageColor.first?.A ?? 1
                            ))
                            .cornerRadius(10)
                            .overlay(  // 枠線を追加
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                            )
                        }
                    }
                    .listRowSeparatorTint(Color("Text"))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            Button("マイメニューの追加") {
                MyMenuAddViewPresented.toggle()
            }
            .padding(.horizontal)
            .sheet(isPresented: $MyMenuAddViewPresented) {
                MyMenuAddView(MyMenuAddViewPresented: $MyMenuAddViewPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    
    
    private func selectMeal(_ myMealContent: MyMealContentModel) {
        selectedMealName = myMealContent.MyMealName
        selectedMealProtein = myMealContent.MyMealProtein
        selectedMealFat = myMealContent.MyMealFat
        selectedMealCarbohydrate = myMealContent.MyMealCarbohydrate
        selectedMealKcal = myMealContent.MyMealKcal
        presentation.wrappedValue.dismiss()
    }
}

struct MyMenuAddView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentation
    
    @Query private var ImageColor: [ImageColorModel]
    
    @State private var MyMealName: String = ""
    @State private var MyMealProtein: Double = 0.0
    @State private var MyMealFat: Double = 0.0
    @State private var MyMealCarbohydrate: Double = 0.0
    @State private var MyMealKcal: Double = 0.0
    
    @State var R: Double = 0
    @State var G: Double = 255
    @State var B: Double = 255
    @State var A: Double = 1
    
    @Binding var MyMenuAddViewPresented: Bool
    
    var myMenuAddButtonBackgroundColor: Color {
        return isMyMenuAddFormValid() ? Color(
            red: ImageColor.first?.R ?? 0 / 255,
            green: ImageColor.first?.G ?? 255 / 255,
            blue: ImageColor.first?.B ?? 255 / 255,
            opacity: ImageColor.first?.A ?? 1
        ) : Color.gray
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("メニュー")
                ZStack(alignment: .leading) {
                    TextField("", text: $MyMealName)
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
            .padding()
            .padding(.top, 30)
        }
        
        HStack {
            Text("たんぱく質")
            TextField("", value: $MyMealProtein, format: .number)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 60)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.numberPad)
                .onChange(of: MyMealProtein) {
                    calculateMyKcal()
                }
                .overlay(  // 枠線を追加
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                )
            Text("g")
            Spacer()
        }
        .padding(.horizontal)
        
        HStack {
            Text("脂質")
            TextField("", value: $MyMealFat, format: .number)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 60)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.numberPad)
                .onChange(of: MyMealFat) {
                    calculateMyKcal()
                }
                .overlay(  // 枠線を追加
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                )
            Text("g")
            Spacer()
        }
        .padding(.horizontal)
        
        HStack {
            Text("炭水化物")
            TextField("", value: $MyMealCarbohydrate, format: .number)
                .multilineTextAlignment(.trailing)
                .padding(4)
                .frame(width: 60)
                .background(.white, in: .rect(cornerRadius: 6))
                .foregroundColor(.black)
                .font(.system(size: 20))
                .keyboardType(.numberPad)
                .onChange(of: MyMealCarbohydrate) {
                    calculateMyKcal()
                }
                .overlay(  // 枠線を追加
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
                )
            Text("g")
            Spacer()
        }
        .padding(.horizontal)
        
        HStack {
            Text("カロリー")
            TextField("", value: $MyMealKcal, format: .number)
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
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
        
        Button(action: {
            addMyMeal()
            MyMenuAddViewPresented.toggle()
        }) {
            Text("決定")
        }
        .padding(10)
        .frame(width: 200, height: 35)
        .foregroundColor(.black)
        .background(myMenuAddButtonBackgroundColor)
        .cornerRadius(10)
        .disabled(!isMyMenuAddFormValid())
        .overlay(  // 枠線を追加
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray, lineWidth: 1)  // 枠線の色と幅を設定
        )
        Spacer()
    }
    
    private func calculateMyKcal() {
        guard MyMealProtein >= 0, MyMealFat >= 0, MyMealCarbohydrate >= 0 else {
            MyMealKcal = 0.0
            return
        }
        MyMealKcal = round((MyMealProtein * 4) + (MyMealFat * 9) + (MyMealCarbohydrate * 4))
    }
    
    private func isMyMenuAddFormValid() -> Bool {
        return !MyMealName.isEmpty && MyMealProtein >= 0 && MyMealFat >= 0 && MyMealCarbohydrate >= 0 && MyMealKcal >= 0
    }
    
    private func addMyMeal() {
        if !isMyMenuAddFormValid() {
            return
        }
        let newMyMeal = MyMealContentModel(MyMealName: MyMealName, MyMealProtein: MyMealProtein, MyMealFat: MyMealFat, MyMealCarbohydrate: MyMealCarbohydrate, MyMealKcal: MyMealKcal)
        context.insert(newMyMeal)
        try? context.save() // 追加: データベースに変更を保存
        
        MyMealName = ""
        MyMealProtein = 0.0
        MyMealFat = 0.0
        MyMealCarbohydrate = 0.0
        MyMealKcal = 0.0
    }
}


struct MyMenuSelectView_Previews: PreviewProvider {
    
    @State static var selectedMealName = "Sample Meal"
    @State static var selectedMealProtein: Double = 10.0
    @State static var selectedMealFat: Double = 5.0
    @State static var selectedMealCarbohydrate: Double = 20.0
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
