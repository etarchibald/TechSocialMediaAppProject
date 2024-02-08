//
//  PostsTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/30/24.
//

import UIKit

protocol PostDelegate {
    func postButtonPressed(postid: Int)
}

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentCounterLabel: UILabel!
    @IBOutlet weak var likesCounterLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private var post = Post(postid: 0, title: "", body: "", authorUserName: "", authorUserId: "", likes: 0, userLiked: false, numComments: 0, createdDate: "", comments: [])
    
    var delegate: PostDelegate?
    
    func updateUI(using post: Post) {
        self.post = post
        titleLabel.text = post.title
        bodyLabel.text = post.body
        createdDateLabel.text = post.createdDate
        userNameLabel.text = post.authorUserName
        likesCounterLabel.text = String(post.likes)
        commentCounterLabel.text = String(post.numComments)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        delegate?.postButtonPressed(postid: post.postid)
    }
}
