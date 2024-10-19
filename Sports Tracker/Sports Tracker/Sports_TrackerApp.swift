//
//  Sports_TrackerApp.swift
//  Sports Tracker
//
//  Created by David Šafarik on 19.10.2024.
//

import SwiftUI

@main
struct Sports_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
