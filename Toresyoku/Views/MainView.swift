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
    
    var dateFormat: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .full
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    var body: some View {
        ZStack {
            if isFirstBoot {
                FirstBootView(isFirstBoot: $isFirstBoot)
            } else {
                mainArea
                
                settingArea
            }
        }
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

extension MainView {
    private var mainArea: some View {
        VStack {
            HStack {
                Button {
                    datePickerPresented.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.black)
                        .font(.system(size: 30))
                }
                .sheet(isPresented: $datePickerPresented) {
                    DatePickerView(datePickerPresented: $datePickerPresented, theDate: $theDate, refreshID: $refreshID)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                .padding()
                Text(dateFormat.string(from: theDate))
                    .foregroundStyle(.black)
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
                        .foregroundStyle(.black)
                        .font(.system(size: 30))
                }
                .padding()
            }
            .background(.linearGradient(colors: [colorManager(from: imageColor.first, opacity: 0.1), colorManager(from: imageColor.first, opacity: 0.4)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
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
    }
    
    private var settingArea: some View {
        GeometryReader { geometry in
            if settingViewPresented {
                SettingView(settingViewPresented: $settingViewPresented, isAlert: $isAlert, refreshID: $refreshID)
                    .frame(width: geometry.size.width * 0.5)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .shadow(radius: 5)
                    .transition(.move(edge: .trailing))
                    .position(x: geometry.size.width - (geometry.size.width * 0.25))
            } else {
                EmptyView()
            }
        }
        .background(settingViewPresented ? Color.black.opacity(0.6) : Color.clear)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
