//
//  Extensions.swift
//  TaskManagerCoreDataSwiftUI
//
//  Created by Гермек Александр Георгиевич on 29.04.2022.
//

import SwiftUI


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
