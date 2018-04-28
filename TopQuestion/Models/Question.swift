//
//  Question.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 25/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation
struct Questions: Codable {
    struct Question: Codable {
        let title: String
        let score: Int
        let tags: [String]
        let date: Date
        let owner: User?
        
        enum CodingKeys: String, CodingKey {
            case title
            case score
            case tags
            case owner
            case date = "creation_date"
        }
    }
    public let items: [Question]
}
