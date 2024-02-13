//
//  Post.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import Foundation

struct Post: Codable, Hashable {
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var authorUserId: String
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
    var comments: [Comment]?
    
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
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.postid < rhs.postid
    }
}
