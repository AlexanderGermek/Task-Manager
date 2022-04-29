//
//  NewTask.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Alexander Germek on 28.04.2022.
//

import SwiftUI

struct NewTask: View {

	/// Task parameters:
	@State private var taskTitle: String = ""
	@State private var taskDescription: String = ""
	@State private var taskDate: Date = Date()

	// Environments:
	/// Core Data Context:
	@Environment(\.managedObjectContext) var context
	/// Task Model:
	@EnvironmentObject var taskViewModel: TaskViewModel
	/// Dismiss:
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationView {

			List {

				Section {
					TextField("Enter title...", text: $taskTitle)
				} header: {
					Text("Task Title")
				}

				Section {
					TextField("Enter description...", text: $taskDescription)
				} header: {
					Text("Task Description")
				}

				if taskViewModel.editTask == nil {
					Section {
						DatePicker("", selection: $taskDate)
							.datePickerStyle(.graphical)
							.labelsHidden()
					} header: {
						Text("Task Date")
					}
				}

			}
			.listStyle(.insetGrouped)
			.navigationTitle("Add New Task")
			.navigationBarTitleDisplayMode(.inline)
			.interactiveDismissDisabled() // disable dismiss on swipe
			/// Navigation Buttons
			.toolbar {

				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Save") {

						if let task = taskViewModel.editTask {
							/// Редактируемая задача:
							task.taskTitle = taskTitle
							task.taskDescription = taskDescription
						} else {
							/// Новая задача:
							let task = Task(context: context)
							task.taskTitle = taskTitle
							task.taskDescription = taskDescription
							task.taskDate = taskDate
						}

						try? context.save()
						dismiss()
					}
					.disabled(taskTitle == "" || taskDescription == "")
				}

				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
			.onAppear {
				guard let task = taskViewModel.editTask  else { return }
				taskTitle = task.taskTitle ?? ""
				taskDescription = task.taskDescription ?? ""
			}
		}
	}
}
