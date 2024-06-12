//
//  FetchTask.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/21/24.
//

import Combine
import Foundation
import UIKit

/// FetchTask encapsulates the shared combine code required to download
/// decodables and images. 
struct FetchTask {
	let url: URL

	func start<Item: Decodable>(found: @escaping ((Item) -> Void)) -> AnyCancellable {
		self.start<Item>(found: found, completed: {_ in })
	}
	
	func start<Item: Decodable>(found: @escaping ((Item) -> Void),
		completed: @escaping ((Subscribers.Completion<any Error>) -> Void)) -> AnyCancellable
	{
		URLSession.shared.dataTaskPublisher(for: self.url)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map() { $0.data }
			.decode(type: Item.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: completed, receiveValue: found)
	}
	
	func start(found: @escaping ((UIImage) -> Void)) -> AnyCancellable {
		URLSession.shared.dataTaskPublisher(for: self.url)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.compactMap { UIImage(data: $0.data) }
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: {_ in },
				  receiveValue: found)
	}
}
