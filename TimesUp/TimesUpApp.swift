//
//  TimesUpApp.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/5.
//

import SwiftUI

@main
struct TimesUpApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
