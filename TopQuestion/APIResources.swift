//
//  APIResources.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 25/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation

struct ApiWrapper {
	let items: [Serialization]
}

extension ApiWrapper {
	private enum Keys: String, SerializationKey {
		case items
	}
	
	init(serialization: Serialization) {
		items = serialization.value(forKey: Keys.items) ?? []
	}
}

protocol ApiResource {
	associatedtype Model
	var methodPath: String { get }
	func makeModel(serialization: Serialization) -> Model
}

extension ApiResource {
	var url: URL {
		let baseUrl = "https://api.stackexchange.com/2.2"
		let site = "site=stackoverflow"
		let order = "order=desc"
		let sorting = "sort=votes"
		let tags = "tagged=ios"
		let url = baseUrl + methodPath + "?" + order + "&" + sorting + "&" + tags + "&" + site
		return URL(string: url)!
	}
	
	func makeModel(data: Data) -> [Model]? {
		guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
			return nil
		}
		guard let jsonSerialization = json as? Serialization else {
			return nil
		}
		let wrapper = ApiWrapper(serialization: jsonSerialization)
		return wrapper.items.map(makeModel(serialization:))
	}
}

struct QuestionsResource: ApiResource {
	let methodPath = "/questions"
	
	func makeModel(serialization: Serialization) -> Question {
		return Question(serialization: serialization)
	}
}
