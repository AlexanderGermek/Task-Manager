//
//  NewTask.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Alexander Germek on 28.04.2022.
//

import SwiftUI

struct NewTask: View {
	/// Dismiss:
	@Environment(\.dismiss) private var dismiss

	/// Task parameters:
	@State var taskTitle: String = ""
	@State var taskDescription: String = ""
	@State var taskDate: Date = Date()

	// Environments:
	/// Core Data Context:
	@Environment(\.managedObjectContext) var context
	/// Task Model
	@EnvironmentObject var taskViewModel: TaskViewModel

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
							task.taskTitle = taskTitle
							task.taskDescription = taskDescription
						} else {
							/// Save to core data:
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
				if let task = taskViewModel.editTask {
				taskTitle = task.taskTitle ?? ""
				taskDescription = task.taskDescription ?? ""
				}
			}
		}
	}
}
