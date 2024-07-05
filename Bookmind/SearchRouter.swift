//
//  SearchRouter.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-29.
//

import SwiftUI

/// SearchRouter specifies navigation between scan, search and insert screens.
/// The home screen defines navigation destinations for these properties, so
/// required screens are displayed as necessary. The scan and search screens
/// update these properties according to actions on their views.
final class SearchRouter: ObservableObject {
	/// A navigation path used to push the "insert book" screen onto the
	/// navigation stack.
	@Published var path = NavigationPath()
	/// A binding flag used to show and hide the scan screen.
	@Published var isScanning = false
	
	func popToRoot() {
		self.path.removeLast(self.path.count)
	}
	
	/// A stub type used to push the search screen onto a navigations stack.
	/// We may need to add a similar type for an inserting book if we ever
	/// push another kind of book screen onto the stack. 
	struct Search: Hashable {
		let identifier = ""
	}
}
