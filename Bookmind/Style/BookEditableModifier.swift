//
//  BookEditableModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-20.
//

import SwiftUI

/// A view modifier which forwards the edit mode environment variable
/// to a much simpler boolean binding. Avoids repeated copies of the
/// slightly verbose and less clear code to deal with the optional
/// edit mode binding.
struct BookEditableModifier: ViewModifier {
	/// Binding to a content editing flag. We'll update the binding
	/// with any changes from the environment value.
	@Binding var isEditing: Bool
	/// An optional handler if the content wants to take action when
	/// edit mode changes. May as well group up here since the modifier
	/// is already doing related work.
	var onChange: (() -> Void)?
	/// The edit mode environment value. We can manually change this
	/// but it's simpler to just let the edit button do all the work. 
	@Environment(\.editMode) private var mode
	
	func body(content: Content) -> some View {
		content
			.onChange(of: self.mode?.wrappedValue) {
				self.isEditing = self.mode?.wrappedValue != .inactive
				if let onChange {
					onChange()
				}
			}
	}
}

extension View {
	/// A view modifier which forwards the edit mode environment variable
	/// to a much simpler boolean binding. Avoids repeated copies of the
	/// slightly verbose and less clear code to deal with the optional
	/// edit mode binding.
	func editable(_ binding: Binding<Bool>, onChange: (() -> Void)? = nil) -> some View {
		modifier(BookEditableModifier(isEditing: binding))
	}
}
