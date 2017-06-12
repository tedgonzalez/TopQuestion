//
//  NetworkController.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 29/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation

class NetworkController1 {
	func loadQuestions(withCompletion completion: @escaping ([Question]?) -> Void) {
		let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
		let url = URL(string: "https://api.stackexchange.com/2.2/questions?order=desc&sort=votes&site=stackoverflow")!
		let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			guard let data = data else {
				completion(nil)
				return
			}
			guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
				completion(nil)
				return
			}
			let questions: [Question] = [] // Transform JSON into Question values
			completion(questions)
		})
		task.resume()
	}
}

class NetworkController {
	static let questionsURL = "https://api.stackexchange.com/2.2/questions?order=desc&sort=votes&site=stackoverflow"
	static let usersURL = "https://api.stackexchange.com/2.2/users?order=desc&sort=reputation&site=stackoverflow"
	
	func load(_ urlString: String, withCompletion completion: @escaping ([Any]?) -> Void) {
		let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
		let url = URL(string: urlString)!
		let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			guard let data = data else {
				completion(nil)
				return
			}
			guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
				completion(nil)
				return
			}
			let result: [Any]
			switch urlString {
			case NetworkController.questionsURL:
				result = [] // Transform JSON into Question values
			case NetworkController.usersURL:
				result = [] // Transform JSON into Question values
			default:
				result = []
			}
			completion(result)
		})
		task.resume()
	}
}
