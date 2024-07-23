//
//  SettingsContentView.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/6.
//

import SwiftUI

struct SettingsContentView: View {
     @State private var username: String = ""
     @State private var notificationsEnabled: Bool = false
     @State private var volume: Double = 50
     @State private var selectedTheme: String = "Light"
     
     let themes = ["Light", "Dark", "System"]

     var body: some View {
         NavigationView {
             VStack {
                 
                 SettingHeaderView()
                 
                 VStack {
                     Form {
                         Section(header: Text("Profile")) {
                             TextField("Username", text: $username)
                         }
                         
                         Section(header: Text("Preferences")) {
                             Toggle(isOn: $notificationsEnabled) {
                                 Text("Enable Notifications")
                             }
                             
                             Slider(value: $volume, in: 0...100) {
                                 Text("Volume")
                             }
                         }
                         
                         Section(header: Text("Appearance")) {
                             Picker("Theme", selection: $selectedTheme) {
                                 ForEach(themes, id: \.self) { theme in
                                     Text(theme)
                                 }
                             }
                         }
                     }
                 }
                 .background(.white)
                 .cornerRadius(20.0)
                 .padding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
             }
             .navigationBarHidden(true)
             .edgesIgnoringSafeArea(.top)
         }
     }
 }


struct SettingHeaderView: View {
    var body: some View {
        HStack {
            Text("设置")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(alignment: .center)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 0))
            Spacer()
            GIFImageView(gifName: "gears_anim")
                .frame(width: 100, height: 100)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.mainContentHeaderBlue)
    }
}

#Preview {
    SettingsContentView()
}
