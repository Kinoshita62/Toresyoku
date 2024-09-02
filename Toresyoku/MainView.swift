//
//  ContentView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @AppStorage("isFirstBoot") var isFirstBoot: Bool = true
    @Environment(\.modelContext) private var context
    @Query private var imageColor: [ImageColorModel]
    
    @State var mainSelectedTag = 1
    @State var theDate = Date()
    @State var datePickerPresented: Bool = false
    @State var settingViewPresented: Bool = false
    @State var isAlert: Bool = false
    
//    @State var R: Double = 0
//    @State var G: Double = 255
//    @State var B: Double = 255
//    @State var A: Double = 0.2
   
    @State var refreshID = UUID()
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            if isFirstBoot {
                FirstBootView(isFirstBoot: $isFirstBoot)
            } else {
                VStack {
                    HStack {
                        Button {
                            datePickerPresented.toggle()
                        } label: {
                            Image(systemName: "calendar")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                        }
                        .sheet(isPresented: $datePickerPresented) {
                            DatePickerView(datePickerPresented: $datePickerPresented, theDate: $theDate, refreshID: $refreshID)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                        .padding()
                        Text(dateFormat.string(from: theDate))
                            .foregroundColor(.black)
                            .bold()
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Button {
                            withAnimation {
                                settingViewPresented.toggle()
                            }
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                        }
                        .padding()
                    }
                    
                    TabView(selection: $mainSelectedTag) {
                        MealMainView(theDate: $theDate, refreshID: $refreshID)
                            .tabItem {
                                Label("食事", systemImage: "fork.knife")
                            }
                            .tag(1)
                        GraphMainView(refreshID: $refreshID)
                            .tabItem {
                                Label("グラフ", systemImage: "chart.line.uptrend.xyaxis")
                            }.tag(2)
                        MyPageMainView(theDate: $theDate)
                            .tabItem {
                                Label("マイページ", systemImage: "person.crop.circle")
                            }.tag(3)
                    }
                }
                .background(Color(
                    red: imageColor.first?.R ?? 0,
                    green: imageColor.first?.G ?? 1,
                    blue: imageColor.first?.B ?? 1,
                    opacity: imageColor.first?.A ?? 0.2
                ))
                
                if settingViewPresented {
                    GeometryReader { geometry in
                        SettingView(settingViewPresented: $settingViewPresented, isAlert: $isAlert, refreshID: $refreshID)
                            .frame(width: geometry.size.width * 0.5)
                            .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                            .shadow(radius: 5)
                            .transition(.move(edge: .trailing))
                            .position(x: geometry.size.width - (geometry.size.width * 0.25))
                    }
                    .background(Color.black.opacity(0.6))
                }
            }
        }
    }
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .full
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
}

struct DatePickerView: View {
    @Binding var datePickerPresented: Bool
    @Binding var theDate: Date
    @Binding var refreshID: UUID
    
    var body: some View {
        DatePicker("", selection: $theDate, displayedComponents: .date)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
            .onChange(of: theDate) {
                refreshID = UUID()
                datePickerPresented = false
            }
    }
}

struct SettingView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var imageColor: [ImageColorModel]
    
    @State var selectedRed: Double = 0
    @State var selectedGreen: Double = 1
    @State var selectedBlue: Double = 1
    @State var selectedAlpha: Double = 0.2
    
    @State var R: Double = 0
    @State var G: Double = 255
    @State var B: Double = 255
    @State var A: Double = 0.2
    
    @Binding var settingViewPresented: Bool
    @Binding var isAlert: Bool
    @Binding var refreshID: UUID
    
    var body: some View {
        VStack {
            Text("イメージカラー変更")
                .font(.title3)
                .padding(.top, 250)
            HStack {
                Circle()
                    .foregroundColor(Color(red: 0/255, green: 255/255, blue: 255/255, opacity: 0.2))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorBlue()
                    }
                    .padding(.horizontal, 5)
                Circle()
                    .foregroundColor(Color(red: 255/255, green: 0/255, blue: 255/255, opacity: 0.2))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorPink()
                    }
                    .padding(.horizontal, 5)
                Circle()
                    .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255, opacity: 0.2))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorLemon()
                    }
                    .padding(.horizontal, 5)
                Circle()
                    .foregroundColor(Color(red: 50/255, green: 200/255, blue: 75/255, opacity: 0.2))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorGreen()
                    }
                    .padding(.horizontal, 5)
            }
            
            Button("データの初期化") {
                isAlert.toggle()
            }
            .font(.title3)
            .foregroundColor(.black)
            .alert(isPresented: $isAlert) {
                Alert(
                    title: Text("注意!"),
                    message: Text("消去したデータは復元できません"),
                    primaryButton: .destructive(Text("消去する"), action: {deleteAllData()
                        settingViewPresented = false
                    }),
                    secondaryButton: .cancel(Text("キャンセル"), action: {
                        settingViewPresented = false}
                    )
                )
            }
            .padding(.top, 20)
            
            Button("閉じる") {
                settingViewPresented = false
            }
            .font(.title3)
            .foregroundColor(.black)
            .padding([.top, .bottom], 20)
        }
    }
    
    private func deleteAllData() {
        do {
            let profiles = try context.fetch(FetchDescriptor<ProfileModel>())
            for profile in profiles {
                context.delete(profile)
            }
            let meals = try context.fetch(FetchDescriptor<MealContentModel>())
            for meal in meals {
                context.delete(meal)
            }
            let myMeals = try context.fetch(FetchDescriptor<MyMealContentModel>())
            for myMeal in myMeals {
                context.delete(myMeal)
            }
            let colors = try context.fetch(FetchDescriptor<ImageColorModel>())
            for color in colors {
                context.delete(color)
            }
            try context.save()
            refreshID = UUID()
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }
    
    private func selectColorBlue() {
            let R: Double = 0
            let G: Double = 255
            let B: Double = 255
            let A: Double = 0.2
            replaceImageColor(R: R, G: G, B: B, A: A)
        }

        private func selectColorPink() {
            let R: Double = 255
            let G: Double = 0
            let B: Double = 255
            let A: Double = 0.2
            replaceImageColor(R: R, G: G, B: B, A: A)
        }

        private func selectColorLemon() {
            let R: Double = 255
            let G: Double = 255
            let B: Double = 0
            let A: Double = 0.2
            replaceImageColor(R: R, G: G, B: B, A: A)
        }
        
        private func selectColorGreen() {
            let R: Double = 150
            let G: Double = 255
            let B: Double = 50
            let A: Double = 0.2
            replaceImageColor(R: R, G: G, B: B, A: A)
        }

        private func replaceImageColor(R: Double, G: Double, B: Double, A: Double) {
            do {
                let existingColors = try context.fetch(FetchDescriptor<ImageColorModel>())
                for color in existingColors {
                    context.delete(color)
                }
                let imageColorModel = ImageColorModel(R: R / 255, G: G / 255, B: B / 255, A: A)
                context.insert(imageColorModel)
                try context.save()
                withAnimation {
                    settingViewPresented = false
                }
                refreshID = UUID()
            } catch {
                print("Failed to replace color: \(error.localizedDescription)")
            }
        }

    }
    
//    private func selectColor(selectedRed: Double, selectedGreen: Double, selectedBlue: Double, selectedAlpha: Double) {
//        replaceImageColor(R: selectedRed, G: selectedGreen, B: selectedBlue, A: selectedAlpha)
//    }

//    private func selectColorBlue() {
//        let newRed: Double = 0
//        let newGreen: Double = 255
//        let newBlue: Double = 255
//        let newAlpha: Double = 0.2
//        replaceImageColor(newSelectedRed: newRed, newSelectedGreen: newGreen, newSelectedBlue: newBlue, newSelectedAlpha: newAlpha)
//    }
//
//    private func selectColorPink() {
//        let newRed: Double = 255
//                let newGreen: Double = 0
//                let newBlue: Double = 255
//                let newAlpha: Double = 0.2
//                replaceImageColor(newSelectedRed: newRed, newSelectedGreen: newGreen, newSelectedBlue: newBlue, newSelectedAlpha: newAlpha)
//    }
//
//    private func selectColorOrange() {
//        let newRed: Double = 255
//        let newGreen: Double = 150
//        let newBlue: Double = 0
//        let newAlpha: Double = 0.2
//        replaceImageColor(newSelectedRed: newRed, newSelectedGreen: newGreen, newSelectedBlue: newBlue, newSelectedAlpha: newAlpha)
//    }
//
//    private func selectColorGreen() {
//        let newRed: Double = 50
//        let newGreen: Double = 200
//        let newBlue: Double = 75
//        let newAlpha: Double = 0.2
//        replaceImageColor(newSelectedRed: newRed, newSelectedGreen: newGreen, newSelectedBlue: newBlue, newSelectedAlpha: newAlpha)
//    }
//
//
//    private func replaceImageColor(newSelectedRed: Double, newSelectedGreen: Double, newSelectedBlue: Double, newSelectedAlpha: Double) {
//        do {
//            let existingColors = try context.fetch(FetchDescriptor<ImageColorModel>())
//            for color in existingColors {
//                context.delete(color)
//            }
//            let newColor = ImageColorModel(selectedRed: newSelectedRed / 255, selectedGreen: newSelectedGreen / 255, selectedBlue: newSelectedBlue / 255, selectedAlpha: newSelectedAlpha)
//            context.insert(newColor)
//            try context.save()
//            refreshID = UUID()
//            settingViewPresented = false
//        } catch {
//            print("Failed to replace color: \(error.localizedDescription)")
//        }
//    }


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
