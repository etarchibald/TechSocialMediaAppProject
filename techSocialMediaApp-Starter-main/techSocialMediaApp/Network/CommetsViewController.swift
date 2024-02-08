//
//  CommetsViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/7/24.
//

import UIKit

class CommetsViewController: UIViewController {

    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var comments = [Comment(commentId: 0, body: "", userName: "", userId: "", createdDate: "")]
    var postid: Int
    var pageNumber = 0
    
    required init?(coder: NSCoder, postid: Int) {
        self.postid = postid
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchComments()
    }
    
    func fetchComments() {
        Task {
            do {
                let fetchCommentsRequest = FetchComments(secret: User.current!.secret, postid: postid, pageNumber: pageNumber)
                comments = try await APIController.shared.sendRequest(fetchCommentsRequest)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addCommentPressed(_ sender: UIButton) {
        
    }
}

extension CommetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        
        cell.updateUI(using: comment)
        
        return cell
    }
}
