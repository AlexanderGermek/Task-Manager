//
//  TaskViewModel.swift
//  TaskManagerSwiftUI
//
//  Created by Alexander Germek on 26.04.2022.
//

import SwiftUI

/// Класс вью-модели
final class TaskViewModel: ObservableObject {

	// MARK: - Properties
	/// Массив дней текущей недели:
	@Published var currentWeek: [Date] = []

	/// Текущая дата ( день):
	@Published var currentDate: Date = Date()

	/// Флаг добавляется ли задача или редактируется:
	@Published var isAddNewTask: Bool = false

	/// Редиктируемая задача:
	@Published var editTask: Task?

	// MARK: - Init
	init() {
		fetchCurrentWeek()
	}

	// MARK: - Private Functions
	private func fetchCurrentWeek() {
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

	// MARK: - Public Functions
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
