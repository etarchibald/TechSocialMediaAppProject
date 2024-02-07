//
//  AllPostsViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/6/24.
//

import UIKit

class AllPostsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post(postid: 0, title: "", body: "", authorUserName: "", authorUserId: "", likes: 0, userLiked: false, numComments: 0, createdDate: "")]
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPosts()
    }
    
    func fetchPosts() {
        Task {
            do {
                let postRequest = FetchPosts(secret: User.current!.secret, pageNumber: pageNumber)
                posts = try await APIController.shared.sendRequest(postRequest)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension AllPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostsTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.updateUI(using: post)
        
        return cell
    }
}
