//
//  LibraryBackgroundView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-22.
//

import SwiftUI

/// LibraryBackgroundView is a blurred library background.
/// It fills the background and ignores the safe area. The
/// idea is to provide visual interest but not distract too
/// much from foreground details.
struct LibraryBackgroundView: View {
	static private let cover = UIImage(resource: .libraryBackground)
	
	var body: some View {
		ZStack {
			Image(uiImage: Self.cover)
				.resizable()
				.blur(radius: 4.0)
				.brightness(-0.2)
				.toolbarBackground(.hidden, for: .navigationBar)
			Color(.background).opacity(BookStyle.opacity)
		}
		.ignoresSafeArea()
	}
}
