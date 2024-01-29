//
//  BookmindApp.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/1/24.
//

import SwiftUI

/// BookmindApp specifies initial views, and stores and injects models
/// into the environment. If we need different initial views for phone,
/// tablet and headset, those will be conditionally set here.
@main
struct BookmindApp: App {
	@StateObject var bookModel = BookModel()
	
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				HomeScreen()
			}
			.environmentObject(self.bookModel)
        }
    }
}
