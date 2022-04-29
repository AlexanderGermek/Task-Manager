//
//  HomeView.swift
//  TaskManagerSwiftUI
//
//  Created by Гермек Александр Георгиевич on 26.04.2022.
//

import SwiftUI

struct HomeView: View {
	@StateObject var taskViewModel = TaskViewModel()
	@Namespace var animation

	/// Environments:
	@Environment(\.managedObjectContext) var context
	@Environment(\.editMode) var editButton

	var body: some View {
		ScrollView(.vertical, showsIndicators: false) {

			// MARK: Lazy Stack With Pinned Header
			LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {

				Section {
					// MARK: Lazy Stack With Pinned Header

					ScrollView(.horizontal, showsIndicators: false) {

						HStack(spacing: 10) {
							let width = (UIScreen.main.bounds.width - 8*10)/7
							ForEach(taskViewModel.currentWeek, id: \.self) { day in

								VStack(spacing: 10) {

									Text(taskViewModel.extractDate(date: day, format: "dd"))
										.font(.system(size: 15))
										.fontWeight(.semibold)

									/// EEE is MON, TUE, ...
									Text(taskViewModel.extractDate(date: day, format: "EEE"))
										.font(.system(size: 14))

									Circle()
										.fill(.white)
										.frame(width: 8, height: 8)
										.opacity(taskViewModel.isToday(date: day) ? 1: 0)
								}
								// MARK: Foreground Style
								.foregroundStyle(taskViewModel.isToday(date: day) ? .primary : .secondary)
								.foregroundColor(taskViewModel.isToday(date: day) ? .white : .black)
								// MARK: Capsule Shape
								.frame(width: width, height: 90)
								.background(

									ZStack {
										// MARK: Matched Geometry Effect
										if taskViewModel.isToday(date: day) {
											Capsule()
												.fill(.black)
												.matchedGeometryEffect(id: "CURRENTDAY", in: animation)
										}
									}

								)
								.contentShape(Capsule())
								.onTapGesture {
									// Update Current Day
									withAnimation {
										taskViewModel.currentDate = day
									}
								}
							}
						}
						.padding(.horizontal)
					}

					TasksView()
				} header: {
					HeaderView()
				}
			}
		}
		.ignoresSafeArea(.container, edges: .top)
		// MARK: Plus Button
		.overlay(
			Button(action: {
				taskViewModel.isAddNewTask.toggle()
			}, label: {
				Image(systemName: "plus")
					.foregroundColor(.white)
					.padding()
					.background(.black, in: Circle())
			})
				.padding()
			,alignment: .bottomTrailing
		)
		.sheet(isPresented: $taskViewModel.isAddNewTask) {
			taskViewModel.editTask = nil
		} content: {
			NewTask()
				.environmentObject(taskViewModel)
		}
	}

	// MARK: Tasks View
	func TasksView() -> some View {
		LazyVStack(spacing: 20) {
			/// Converting object as Our Task Model
			DynamicFilteredView(dateToFilter: taskViewModel.currentDate) { (object: Task) in
				TaskCardView(task: object)
			}
		}
		.padding()
		.padding(.top)
	}

	// MARK: Task Card View
	func TaskCardView(task: Task) -> some View {

		HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30) {
			let isCompleted = task.isCompleted
			let editWappedValue = editButton?.wrappedValue

			if editWappedValue == .active {

				// Кнопка редактирования - только для не Прошлых задач
				VStack(spacing: 10) {
					if task.taskDate?.compare(Date()) == .orderedDescending ||
						Calendar.current.isDateInToday(task.taskDate ?? Date()) {

						Button {
							taskViewModel.editTask = task
							taskViewModel.isAddNewTask.toggle()

						} label: {
							Image(systemName: "pencil.circle.fill")
								.font(.title)
								.foregroundColor(.primary)
						}
					}


					Button {
						/// Delete task
						context.delete(task)
						try? context.save()

					} label: {
						Image(systemName: "minus.circle.fill")
							.font(.title)
							.foregroundColor(.red)
					}
				}

			} else {
				VStack(spacing: 10) {
					Circle()
						.fill(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ?
							  (isCompleted ? .green : .black) : .clear)
						.frame(width: 15, height: 15)
						.background(
							Circle()
								.stroke(.black, lineWidth: 1)
								.padding(-3)
						)
						.scaleEffect(!taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)

					Rectangle()
						.fill(.black)
						.frame(width: 3)
				}
			}

			VStack {
				HStack(alignment: .top, spacing: 10) {
					VStack(alignment: .leading, spacing: 12) {
						Text(task.taskTitle ?? "")
							.font(.title2.bold())
						Text(task.taskDescription ?? "")
							.font(.callout)
							.foregroundStyle(.secondary)
					}
					.hLeading()

					Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
				}

				if taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) {
					/// Team Members:
					HStack(spacing: 12) {

						//						HStack(spacing: -10) {
						//							ForEach(["user1","user2","user3"], id: \.self) {
						//								Image($0)
						//									.resizable()
						//									.aspectRatio(contentMode: .fill)
						//									.frame(width: 45, height: 45)
						//									.clipShape(Circle())
						//									.background(
						//										Circle()
						//											.stroke(.black, lineWidth: 4)
						//									)
						//							}
						//						}
						//						.hLeading()

						/// Checkbox Button
						if !isCompleted {

							Button {
								task.isCompleted = true
								try? context.save()

							} label: {
								Image(systemName: "checkmark")
									.foregroundStyle(.black)
									.padding(10)
									.background(.white, in: RoundedRectangle(cornerRadius: 10))
							}
						}

						Text(isCompleted ? "Completed" : "Mark Task as Completed")
							.font(.system(size: isCompleted ? 14 : 16, weight: .light))
							.foregroundColor(isCompleted ? .gray : .white)
							.hLeading()

					}
					.padding(.top)
				}
			}
			.foregroundColor(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
			.padding(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
			.hLeading()
			.background(
				Color("cardBackground")
					.cornerRadius(25)
					.opacity(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
			)
		}
		.hLeading()
	}

	// MARK: Header
	func HeaderView() -> some View {
		HStack(spacing: 10) {

			VStack(alignment: .leading, spacing: 10) {

				Text(Date().formatted(date: .abbreviated, time: .omitted))
					.foregroundColor(.gray)
				Text("Today").font(.largeTitle.bold())

			}
			.hLeading()
			EditButton()
			/// Profile Button
			//			Button {
			//
			//			} label: {
			//				Image("Profile")
			//					.resizable()
			//					.aspectRatio(contentMode: .fill)
			//					.frame(width: 45, height: 45)
			//					.clipShape(Circle())
			//			}
		}
		.padding()
		.padding(.top, getSafeArea().top)
		.background(.white)
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}


// MARK: UI Design Helper functions
extension View {
	func hLeading() -> some View {
		self
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	func hTrailing() -> some View {
		self
			.frame(maxWidth: .infinity, alignment: .trailing)
	}

	func hCenter() -> some View {
		self
			.frame(maxWidth: .infinity, alignment: .center)
	}

	// MARK: Safe Area
	func getSafeArea() -> UIEdgeInsets {
		guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let safeAreaInsets = screen.windows.first?.safeAreaInsets else {
				  return .zero
			  }

		return safeAreaInsets
	}
}
