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
    @Query private var ImageColor: [ImageColorModel]
    
    @State var mainSelectedTag = 1
    @State var theDate = Date()
    @State var datePickerPresented: Bool = false
    @State var settingViewPresented: Bool = false
    @State var isError: Bool = false
    
    @State var R: Double = 0
    @State var G: Double = 1
    @State var B: Double = 1
    @State var A: Double = 1
   
    @State var refreshID = UUID()
    @State var refreshGraph = UUID()
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
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
                                .font(.system(size: 25))
                        }
                        .sheet(isPresented: $datePickerPresented) {
                            DatePickerView(datePickerPresented: $datePickerPresented, theDate: $theDate, refreshID: $refreshID)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                        .padding()
                        Text(dateFormat.string(from: theDate))
                            .foregroundColor(.black)
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
                                .font(.system(size: 25))
                        }
                        .padding()
                    }
                    
                    TabView(selection: $mainSelectedTag) {
                        MealMainView(selectedDate: $theDate, refreshID: $refreshID)
                            .tabItem {
                                Label("食事", systemImage: "fork.knife")
                            }
                            .tag(1)
                        GraphMainView(refreshGraph: $refreshGraph, refreshID: $refreshID)
                            .tabItem {
                                Label("グラフ", systemImage: "chart.line.uptrend.xyaxis")
                            }.tag(2)
                        MyPageMainView(refreshGraph: $refreshGraph)
                            .tabItem {
                                Label("マイページ", systemImage: "person.crop.circle")
                            }.tag(3)
                    }
                }
                .background(Color(
                    red: ImageColor.first?.R ?? 0,
                    green: ImageColor.first?.G ?? 1,
                    blue: ImageColor.first?.B ?? 1,
                    opacity: ImageColor.first?.A ?? 1
                ))
                
                if settingViewPresented {
                    GeometryReader { geometry in
                        SettingView(settingViewPresented: $settingViewPresented, isError: $isError, refreshID: $refreshID)
                            .frame(width: geometry.size.width * 0.5)
                            .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                            .shadow(radius: 5)
                            .transition(.move(edge: .trailing))
                            .position(x: geometry.size.width - (geometry.size.width * 0.25))
                    }
                    .background(Color.black.opacity(0.6))
                    .onTapGesture {
                        withAnimation {
                            settingViewPresented.toggle()
                        }
                    }
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
        Divider()
        Spacer()
    }
}

struct SettingView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var ImageColor: [ImageColorModel]
    
    @State var R: Double = 0
    @State var G: Double = 255
    @State var B: Double = 255
    @State var A: Double = 1
    
    @Binding var settingViewPresented: Bool
    @Binding var isError: Bool
    @Binding var refreshID: UUID
    
    var body: some View {
        VStack {
            Text("イメージカラーの変更")
                .padding(.top, 250)
            HStack {
                Circle()
                    .foregroundColor(Color(red: 0/255, green: 255/255, blue: 255/255, opacity: 0.5))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorBlue()
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, -5)
                Circle()
                    .foregroundColor(Color(red: 255/255, green: 0/255, blue: 255/255, opacity: 0.5))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorPink()
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, -5)
                Circle()
                    .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255, opacity: 0.5))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorLemon()
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, -5)
                Circle()
                    .foregroundColor(Color(red: 150/255, green: 255/255, blue: 50/255, opacity: 0.5))
                    .frame(width: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onTapGesture {
                        selectColorGreen()
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, -5)
            }
            
            Button("データの初期化") {
                isError.toggle()
            }
            .foregroundColor(.black)
            .alert(isPresented: $isError) {
                Alert(
                    title: Text("注意!"),
                    message: Text("消去したデータは復元できません"),
                    primaryButton: .destructive(Text("消去する"), action:
                                                    {deleteAllData()
                                                        withAnimation {
                                                            settingViewPresented = false
                                                        }
                                                    }),
                    secondaryButton: .cancel(Text("キャンセル"), action:
                                                {withAnimation {
                                                    settingViewPresented = false
                                                }
                                                })
                )
            }
            .padding(.top, 20)
            
            Button("閉じる") {
                withAnimation {
                    settingViewPresented = false
                }
            }
            .foregroundColor(.black)
            .padding(.top, 20)
            .padding(.bottom, 20)
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
            let Colors = try context.fetch(FetchDescriptor<ImageColorModel>())
            for Colors in Colors {
                context.delete(Colors)
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
        let A: Double = 0.5
        replaceImageColor(R: R, G: G, B: B, A: A)
    }

    private func selectColorPink() {
        let R: Double = 255
        let G: Double = 0
        let B: Double = 255
        let A: Double = 0.5
        replaceImageColor(R: R, G: G, B: B, A: A)
    }

    private func selectColorLemon() {
        let R: Double = 255
        let G: Double = 255
        let B: Double = 0
        let A: Double = 0.5
        replaceImageColor(R: R, G: G, B: B, A: A)
    }
    
    private func selectColorGreen() {
        let R: Double = 150
        let G: Double = 255
        let B: Double = 50
        let A: Double = 0.5
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
