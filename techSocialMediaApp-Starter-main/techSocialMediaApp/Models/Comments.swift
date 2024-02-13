//
//  Comments.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/5/24.
//

import Foundation

struct Comment: Codable, Hashable {
    var commentId: Int
    var body: String
    var userName: String
    var userId: String
    var createdDate: String
    
    enum CodingKeys: CodingKey {
        case commentId
        case body
        case userName
        case userId
        case createdDate
    }
}
