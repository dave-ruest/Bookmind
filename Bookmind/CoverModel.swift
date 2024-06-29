//
//  CoverModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/22/24.
//

import Combine
import Foundation
import UIKit

/// CoverModel keeps a cache of fetched images. Clients call static
/// fetch() to retrieve an cover. If the cover is in the cache it is
/// immediately returned. Otherwise the model will fetch the cover,
/// store it in the cache and then return it.
final class CoverModel: ObservableObject {
	private var cache = NSCache<NSString, UIImage>()
	private var cancelables = [AnyCancellable]()
	
	func getCover(_ coverId: Int) -> UIImage? {
		self.cache.object(forKey: coverId.asKey())
	}
	
	private func setCover(_ coverId: Int, image: UIImage) {
		self.cache.setObject(image, forKey: coverId.asKey())
	}
	
	func fetch(coverId: Int, found: @escaping ((UIImage?) -> Void)) {
		let string = "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
		guard let url = URL(string: string) else { return }

		self.cancelables.append(
			FetchTask(url: url)
				.start(found: { [weak self] image in
					self?.setCover(coverId, image: image)
					found(image)
				}
			)
		)
	}
}

private extension Int {
	func asKey() -> NSString {
		NSString(format: "%d", self)
	}
}
