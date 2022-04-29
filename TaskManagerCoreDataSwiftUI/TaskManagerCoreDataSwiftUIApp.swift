//
//  TaskManagerCoreDataSwiftUIApp.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Гермек Александр Георгиевич on 27.04.2022.
//

import SwiftUI

@main
struct TaskManagerCoreDataSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
