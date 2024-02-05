//
//  Post.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import Foundation

struct Post: Codable {
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var authorUserId: String
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
    var comments: [Comments]?
    
    enum CodingKeys: CodingKey {
        case postid
        case title
        case body
        case authorUserName
        case authorUserId
        case likes
        case userLiked
        case numComments
        case createdDate
        case comments
    }
}
