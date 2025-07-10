//
//  BookSearchAppApp.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

@main
struct BookSearchAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
