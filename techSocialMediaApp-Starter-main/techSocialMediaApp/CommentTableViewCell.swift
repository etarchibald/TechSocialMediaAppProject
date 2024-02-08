//
//  CommentTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/7/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var comment = Comment(commentId: 0, body: "", userName: "", userId: "", createdDate: "")
    
    func updateUI(using comment: Comment) {
        self.comment = comment
        userNameLabel.text = comment.userName
        dateLabel.text = comment.createdDate
        bodyLabel.text = comment.body
    }
    
}
