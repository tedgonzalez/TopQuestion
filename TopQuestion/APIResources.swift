//
//  APIResources.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 25/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation

protocol ApiResource {
    associatedtype Model:Decodable
	var methodPath: String { get }
    func makeModel(data:Data) -> Model
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
}

struct QuestionsResource: ApiResource {
	let methodPath = "/questions"
	
    func makeModel(data: Data) -> Questions? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        guard let questions = try? decoder.decode(Questions.self, from: data) else {
            return nil
        }
        return questions
	}
}
