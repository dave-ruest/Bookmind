//
//  BookmindApp.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/1/24.
//

import SwiftData
import SwiftUI

/// BookmindApp specifies initial views, and stores and injects models
/// into the environment. If we need different initial views for phone,
/// tablet and headset, those will be conditionally set here.
@main
struct BookmindApp: App {
	private let storage = StorageModel()
	private let covers = CoverModel()
	@ObservedObject private var router = SearchRouter()
	
    var body: some Scene {
        WindowGroup {
			NavigationStack(path: self.$router.path) {
				HomeScreen()
			}
			.modelContainer(self.storage.container)
			.environmentObject(self.storage)
			.environmentObject(self.covers)
			.environmentObject(self.router)
        }
    }
}
