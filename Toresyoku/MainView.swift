//
//  ContentView.swift
//  Toresyoku
//
//  Created by USER on 2024/07/28.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @ObservedObject var mealListModel: MealListModel
    @ObservedObject var profileModel: ProfileModel
    @State var mainSelectedTag = 1
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 25))
                    .padding()
                Text("日付")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Image(systemName: "gearshape")
                    .font(.system(size: 25))
                    .padding()
            }
            .background(Color.orange.opacity(0.2))
            
            TabView(selection: $mainSelectedTag) {
                MealMainView(mealListModel: mealListModel)
                    .tabItem {
                        Label("食事", systemImage: "fork.knife")
                    }.tag(1)
                GraphMainView()
                    .tabItem {
                        Label("グラフ", systemImage: "chart.line.uptrend.xyaxis")
                    }.tag(2)
                MyPageMainView(profileModel: profileModel)
                    .tabItem {
                        Label("マイページ", systemImage: "person.crop.circle")
                    }.tag(3)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mealListModel: MealListModel(), profileModel: ProfileModel())
    }
}


//struct MainView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    MainView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
