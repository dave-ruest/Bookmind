//
//  ScanScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// ScanScreen presents an overlay above a wrapped data scanner controller.
/// For stage one (prove we can scan an ISBN), it identifies and displays
/// a scanned ISBN number. The "add" button will shortly create, lookup
/// and persist some kind of book entity. But for stage one we just close
/// the screen.
struct ScanScreen: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var scanModel: ScanModel
	
	var body: some View {
		ZStack {
			#if targetEnvironment(simulator)
			Color(.background)
				.ignoresSafeArea()
			#else
			ScanView()
				.ignoresSafeArea()
			#endif
			VStack {
				Spacer()
				Text(scanModel.error ?? scanModel.isbn ?? "")
					.bookText()
				Button(action: {
					self.dismiss()
				}, label: {
					Text(scanModel.isbn == nil ? "Cancel" : "Add")
						.bookButton()
				})
			}
		}
	}
}

#Preview {
	ScanScreen()
		.environmentObject(ScanModel(isbn: "9780862786380"))
}

#Preview {
	ScanScreen()
		.environmentObject(ScanModel())
}
