//
//  ContentView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MainView: View {

    @State var mainSelectedTag = 1
    @State var theDate = Date()
    @State var datePickerPresented: Bool = false
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    datePickerPresented.toggle()
                } label: {
                    Image(systemName: "calendar")
                }
                .sheet(isPresented: $datePickerPresented) {
                    DatePickerView(datePickerPresented: $datePickerPresented,theDate: $theDate)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
                .font(.system(size: 25))
                .foregroundColor(.black)
                .padding()
                Text(dateFormat.string(from: theDate))
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Image(systemName: "gearshape")
                    .font(.system(size: 25))
                    .padding()
                }
                .background(Color.orange.opacity(0.2))
            
            TabView(selection: $mainSelectedTag) {
                MealMainView(selectedDate: theDate)
                    .tabItem {
                        Label("食事", systemImage: "fork.knife")
                    }
                    .tag(1)
                GraphMainView()
                    .tabItem {
                        Label("グラフ", systemImage: "chart.line.uptrend.xyaxis")
                    }.tag(2)
                MyPageMainView()
                    .tabItem {
                        Label("マイページ", systemImage: "person.crop.circle")
                    }.tag(3)
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
    
    var body: some View {
        DatePicker("", selection: $theDate, displayedComponents: .date)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.graphical)
        Divider()
        Spacer()
        Button("保存") {
            datePickerPresented = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [ProfileModel.self, MealContentModel.self])
    }
}
