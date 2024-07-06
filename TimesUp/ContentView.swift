//
//  ContentView.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            // TAB - A
            VStack{
                MainContentView()
            }.tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text(K.TAB_NAME_TAB_1)
                }
            }.tag(1)
            
            // TAB - B
            VStack{
                ListContentView()
            }.tabItem {
                VStack {
                    Image(systemName: "alarm.fill")
                    Text(K.TAB_NAME_TAB_2)
                }
            }.tag(2)
            
            // TAB - C
            VStack{
                SettingsContentView()
            }.tabItem {
                VStack {
                    Image(systemName: "gearshape.fill")
                    Text(K.TAB_NAME_TAB_3)
                }
            }.tag(3)
        }
    }
}

#Preview {
    ContentView()
}
