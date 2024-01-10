//
//  ContentView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/1/24.
//

import SwiftUI

/// The welcome screen provides a friendly start page. We may keep this
/// as an introduction, when the user has not yet added books. Or we may
/// move to a list of categories. We'll see when we add book persistence.
struct WelcomeScreen: View {
    var body: some View {
		NavigationStack {
			ZStack {
				Color(.background)
					.ignoresSafeArea()
				VStack {
					ScrollView {
						Text("\nBookmind remembers your books.\n\nThe books you own, the books you want, the books you didn't like...\n\nBookmind remembers them all.\n\n")
							.padding()
					}
					NavigationLink {
						ScanScreen()
					} label: {
						Label("Add Book", systemImage: "camera.fill")
							.bookButton()
					}
				}
			}
			.navigationBarTitleDisplayMode(.large)
			.navigationTitle("Bookmind")
		}
    }
}

#Preview {
    WelcomeScreen()
}
