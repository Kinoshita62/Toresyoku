//
//  SettingView.swift
//  Toresyoku
//
//  Created by USER on 2024/09/12.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    @Environment(\.modelContext) private var context
    @Query private var imageColor: [ImageColorModel]
    
    @Binding var settingViewPresented: Bool
    @Binding var isAlert: Bool
    @Binding var refreshID: UUID
    
    var body: some View {
        VStack {
            colorSelectArea
            
            dataDeleteArea
            
            closeArea
        }
    }
}

extension SettingView {
    
    private var colorSelectArea: some View {
        VStack {
            Text("イメージカラー変更")
                .font(.title3)
                .padding(.top, 250)
            HStack {
                Circle()
                    .foregroundStyle(Color(red: 0/255, green: 255/255, blue: 255/255, opacity: 0.2))
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
                    .foregroundStyle(Color(red: 255/255, green: 0/255, blue: 255/255, opacity: 0.2))
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
                    .foregroundStyle(Color(red: 255/255, green: 100/255, blue: 0/255, opacity: 0.2))
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
                    .foregroundStyle(Color(red: 25/255, green: 200/255, blue: 50/255, opacity: 0.2))
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
        }
    }
    
    private var dataDeleteArea: some View {
        Button("データの初期化") {
            isAlert.toggle()
        }
        .font(.title3)
        .foregroundStyle(.black)
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
    }
    
    private var closeArea: some View {
        Button("閉じる") {
            settingViewPresented = false
        }
        .font(.title3)
        .foregroundStyle(.black)
        .padding([.top, .bottom], 20)
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

struct SettingView_Previews: PreviewProvider {
    @State static var settingViewPresented = true
    @State static var isAlert = false
    @State static var refreshID = UUID()
    static var previews: some View {
        SettingView(settingViewPresented: $settingViewPresented, isAlert: $isAlert, refreshID: $refreshID)
            .modelContainer(for: [ProfileModel.self, MealContentModel.self, MyMealContentModel.self, ImageColorModel.self])
    }
}
