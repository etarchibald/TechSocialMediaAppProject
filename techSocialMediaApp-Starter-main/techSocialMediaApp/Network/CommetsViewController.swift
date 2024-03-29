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
    var secret: UUID?
    var postid: Int?
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchComments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toOtherProfile = segue.destination as? OtherProfileViewController, let userId = sender as? String, let secret = secret {
            toOtherProfile.userId = userId
            toOtherProfile.secret = secret
        }
    }
    
    func fetchComments() {
        Task {
            do {
                let fetchCommentsRequest = FetchComments(secret: User.current!.secret, postid: postid!, pageNumber: pageNumber)
                comments = try await APIController.shared.sendRequest(fetchCommentsRequest)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func createComment() {
        let commentBody = commentTextField.text!
        Task {
            do {
                let createCommetRequest = CreateCommet(secret: User.current!.secret, commentBody: commentBody, postid: postid!)
                let newComment = try await APIController.shared.sendRequest(createCommetRequest)
                comments.append(newComment)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addCommentPressed(_ sender: UIButton) {
        guard let commentBody = commentTextField.text, commentBody != "" else { return }
        createComment()
        commentTextField.text = ""
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
        
        cell.delegate = self
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
}

extension CommetsViewController: PostDelegate {
    func commentButtonPressed(postid: Int) {
    }
    
    func userNameButtonPressed(authorUserId: String) {
        performSegue(withIdentifier: "toProfile", sender: authorUserId)
    }
}
