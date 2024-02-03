//
//  ScanView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/2/24.
//

import SwiftUI
import VisionKit

/// ScanView adapts a DataScannerViewController, which is otherwise unavailable in SwiftUI.
struct ScanView: UIViewControllerRepresentable {
	typealias UIViewControllerType = DataScannerViewController
	
	@EnvironmentObject var scanModel: ScanModel
	
	func makeUIViewController(context: Context) -> DataScannerViewController {
		let controller = DataScannerViewController(recognizedDataTypes: [
			.barcode(symbologies: [.ean8, .ean13]),
			.text()
		], isHighlightingEnabled: true)
		controller.view.backgroundColor = .background
		
		self.scanModel.start(controller)
		return controller
	}
	
	static func dismantleUIViewController(_ controller: DataScannerViewController, coordinator: ()) {
		controller.stopScanning()
	}
	
	func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
		// ?
	}
}
