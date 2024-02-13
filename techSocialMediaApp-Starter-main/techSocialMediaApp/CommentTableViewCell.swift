//
//  CommentTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/7/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var comment = Comment(commentId: 0, body: "", userName: "", userId: "", createdDate: "")
    
    var delegate: PostDelegate?
    
    func updateUI(using comment: Comment) {
        self.comment = comment
        userNameButton.setTitle(comment.userName, for: .normal)
        dateLabel.text = comment.createdDate
        bodyLabel.text = comment.body
    }
    
    @IBAction func userNameButtonTapped(_ sender: Any) {
        delegate?.userNameButtonPressed(authorUserId: comment.userId)
    }
    
}
