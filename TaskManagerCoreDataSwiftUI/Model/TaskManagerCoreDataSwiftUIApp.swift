//
//  TaskManagerCoreDataSwiftUIApp.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Alexander Germek on 27.04.2022.
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
