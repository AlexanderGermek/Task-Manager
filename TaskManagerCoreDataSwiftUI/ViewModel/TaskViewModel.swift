//
//  TaskViewModel.swift
//  TaskManagerSwiftUI
//
//  Created by Alexander Germek on 26.04.2022.
//

import SwiftUI

class TaskViewModel: ObservableObject {
	// Sample tasks:

	lazy private var formatter = DateFormatter()

	///@Published var storedTasks: [Task] = []

	/// Массив дней недели:
	@Published var currentWeek: [Date] = []

	/// Текущая дата ( день):
	@Published var currentDate: Date = Date()

	/// Задачи текущего дня:
	@Published var filteredTasks: [Task]?

	/// New Task View:
	@Published var isAddNewTask: Bool = false

	/// Edit Task:
	@Published var editTask: Task?

	// MARK: Init
	init() {
		formatter.dateFormat = "dd/MM/yyyy HH:mm"
		fetchData()
		fetchCurrentWeek()
		//filterTodayTask()
	}

	private func fetchData() {
//		storedTasks = [
//			Task(taskTitle: "Daily", taskDescription: "Discuss team task for the day",
//								 taskDate: formatter.date(from: "25/04/2022 12:33") ?? Date()),
//		Task(taskTitle: "Bug", taskDescription: "Voice Over Bug Fix",
//			 taskDate: formatter.date(from: "26/04/2022 15:23") ?? Date()),
//		Task(taskTitle: "SwiftUI", taskDescription: "SwiftUI Task Manager Lesson",
//			 taskDate: formatter.date(from: "27/04/2022 16:44") ?? Date()),
////			Task(taskTitle: "SwiftUI", taskDescription: "SwiftUI Task Manager Lesson",
////				 taskDate: formatter.date(from: "27/04/2022 15:01") ?? Date()),
////			Task(taskTitle: "SwiftUI", taskDescription: "SwiftUI Task Manager Lesson",
////				 taskDate: formatter.date(from: "27/04/2022 09:01") ?? Date()),
////			Task(taskTitle: "SwiftUI", taskDescription: "SwiftUI Task Manager Lesson",
////				 taskDate: formatter.date(from: "27/04/2022 22:01") ?? Date()),
//		Task(taskTitle: "Lunch", taskDescription: "Some Food",
//			 taskDate: formatter.date(from: "28/04/2022 8:04") ?? Date())
//			]
	}


//	func filterTodayTask() {
//		DispatchQueue.global(qos: .userInteractive).async {
//			let calendar = Calendar.current
//			let filtered = self.storedTasks.filter {
//				return calendar.isDate($0.taskDate, inSameDayAs: self.currentDate)
//			}.sorted {
//				return $0.taskDate < $1.taskDate
//			}
//
//			DispatchQueue.main.async {
//				withAnimation {
//					self.filteredTasks = filtered
//				}
//			}
//		}
//	}

	func fetchCurrentWeek() {
		let today = Date()
		let calendar = Calendar.current

		let week = calendar.dateInterval(of: .weekOfMonth, for: today)

		guard let firstWeekDay = week?.start else {
			return
		}

		(1...7).forEach { day in
			if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
				currentWeek.append(weekday)
			}
		}
	}

	func extractDate(date: Date, format: String) -> String {
		let formatter = DateFormatter()

		formatter.dateFormat = format

		return formatter.string(from: date)
	}

	func isToday(date: Date) -> Bool {
		return Calendar.current.isDate(date, inSameDayAs: currentDate)
	}

	func isCurrentHour(date: Date) -> Bool {
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: date)
		let currentHour = calendar.component(.hour, from: Date())
		let isToday = calendar.isDateInToday(date)
		return (hour == currentHour && isToday)
	}
}
