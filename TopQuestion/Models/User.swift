//
//  User.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 25/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation

struct User: Codable {
	let name: String?
	let profileImageURL: URL?
	let reputation: Int?
    
    enum CodingKeys: String, CodingKey {
        case reputation
        case name = "display_name"
        case profileImageURL = "profile_image"
    }
}
