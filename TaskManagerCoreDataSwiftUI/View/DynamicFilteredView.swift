//
//  DynamicFilteredView.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Alexander Germek on 28.04.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject{
	/// Core Data Request
	@FetchRequest var request: FetchedResults<T>
	let content: (T) -> Content

	/// Building Custom ForEach which will give CoreData object to build View
	init(dateToFilter: Date, @ViewBuilder content: @escaping (T) -> Content) {

		/// Predicate to Filter current date Tasks:
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: dateToFilter)
		let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()

		let filterKey = "taskDate" // field from core data Entity
		let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tomorrow])

		/// Request with NSPredicate
		_request = FetchRequest(entity: T.entity(),
								sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: false)],
								predicate: predicate)
		self.content = content
	}

	var body: some View {

		Group {

			if request.isEmpty {
				Text("Tasks not found")
					.font(.system(size: 16))
					.fontWeight(.light)
					.offset(y: 100)
			} else {
				ForEach(request, id: \.objectID) { object in
					self.content(object)
				}
			}
		}
	}
}
