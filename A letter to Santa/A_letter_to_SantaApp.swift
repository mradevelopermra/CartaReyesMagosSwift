//
//  A_letter_to_SantaApp.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 17/08/23.
//

import SwiftUI

@main
struct A_letter_to_SantaApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var store = Store()
    @StateObject private var settings = Settings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(store)
                .environmentObject(settings)
        }
    }
}
