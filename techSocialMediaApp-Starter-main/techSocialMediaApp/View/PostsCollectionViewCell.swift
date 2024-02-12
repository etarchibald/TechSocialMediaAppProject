//
//  PostsCollectionViewCell.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/12/24.
//

import UIKit

protocol PostDelegate {
    func postButtonPressed(postid: Int)
}

class PostsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCounterLabel: UILabel!
    @IBOutlet weak var likesCounterLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var userNameButton: UIButton!
    
    private var post = Post(postid: 0, title: "", body: "", authorUserName: "", authorUserId: "", likes: 0, userLiked: true, numComments: 0, createdDate: "", comments: [])
    
    var delegate: PostDelegate?
    
    override func layoutSubviews() {
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        super.layoutSubviews()
    }
    
    func updateUI(using post: Post) {
        self.post = post
        titleLabel.text = post.title
        bodyLabel.text = post.body
        createdDateLabel.text = post.createdDate
        userNameButton.setTitle(post.authorUserName, for: .normal)
        likesCounterLabel.text = String(post.likes)
        commentCounterLabel.text = String(post.numComments)
        likeButton.setImage(UIImage(systemName: post.userLiked ? "heart.fill" : "heart"), for: .normal)
    }
    
    func updateLikes() {
        Task {
            do {
                let updateLikesRequest = UpdateLikes(secret: User.current!.secret, postid: post.postid)
                post = try await APIController.shared.sendRequest(updateLikesRequest)
                updateUI(using: post)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        delegate?.postButtonPressed(postid: post.postid)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        updateLikes()
    }
    
}
