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
                    red: imageColor.first?.imageColorRed ?? 0,
                    green: imageColor.first?.imageColorGreen ?? 1,
                    blue: imageColor.first?.imageColorBlue ?? 1,
                    opacity: imageColor.first?.imageColorAlpha ?? 0.2
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
                    .foregroundColor(Color(red: 255/255, green: 100/255, blue: 0/255, opacity: 0.2))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorOrange()
                    }
                    .padding(.horizontal, 5)
                Circle()
                    .foregroundColor(Color(red: 25/255, green: 200/255, blue: 50/255, opacity: 0.2))
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
        replaceImageColor(newRed: 0, newGreen: 255, newBlue: 255, newAlpha: 0.2)
    }

    private func selectColorPink() {
        replaceImageColor(newRed: 255, newGreen: 0, newBlue: 255, newAlpha: 0.2)
    }

    private func selectColorOrange() {
        replaceImageColor(newRed: 255, newGreen: 100, newBlue: 0, newAlpha: 0.2)
    }
        
    private func selectColorGreen() {
        replaceImageColor(newRed: 25, newGreen: 200, newBlue: 50, newAlpha: 0.2)
    }

    private func replaceImageColor(newRed: Double, newGreen: Double, newBlue: Double, newAlpha: Double) {
        do {
            let existingColors = try context.fetch(FetchDescriptor<ImageColorModel>())
            for color in existingColors {
                context.delete(color)
            }
            let imageColorModel = ImageColorModel(imageColorRed: newRed / 255, imageColorGreen: newGreen / 255, imageColorBlue: newBlue / 255, imageColorAlpha: newAlpha)
             context.insert(imageColorModel)
            try context.save()
            settingViewPresented = false
            refreshID = UUID()
        } catch {
                print("Failed to replace color: \(error.localizedDescription)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
