//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), bio: "", techInterests: "", posts: []) {
        didSet {
            print(userProfile)
        }
    }
    private var userProfileController = UserProfileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
    }
    
    func getUserProfile() {
        
        self.tableView.reloadData()
        
        let userQueryItem = URLQueryItem(name: "userUUID", value: User.current?.userUUID.uuidString)
        let secretQueryItem = URLQueryItem(name: "userSecret", value: User.current?.secret.uuidString)
        
        Task {
            do {
                userProfile = try await userProfileController.fetchUserProfile(matching: [userQueryItem, secretQueryItem])
                updateUI()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUI() {
        techInterestsLabel.text = userProfile.techInterests
        bioLabel.text = userProfile.bio
        fullNameLabel.text = "\(userProfile.firstName) \(userProfile.lastName)"
        userNameLabel.text = userProfile.userName
        tableView.reloadData()
    }
    
    @IBSegueAction func editProfile(_ coder: NSCoder, sender: Any?) -> EditProfileViewController? {
        return EditProfileViewController(coder: coder, secret: User.current!.secret, postProfile: PostProfile(userName: userProfile.userName, bio: userProfile.bio ?? "", techInterests: userProfile.techInterests ?? ""))
    }
    
    @IBSegueAction func createPost(_ coder: NSCoder, sender: Any?) -> AddEditPostViewController? {
        return AddEditPostViewController(coder: coder, post: PostPost(title: "", body: ""))
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostsTableViewCell
        
        let post = userProfile.posts[indexPath.row]
        
        cell.updateUI(using: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = userProfile.posts[indexPath.row]
            userProfile.posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            deletePost(postid: post.postid)
        }
    }
    
    func deletePost(postid: Int) {
        Task {
            do {
                let secretQueryItem = URLQueryItem(name: "userSecret", value: User.current?.secret.uuidString)
                let postidQueryItem = URLQueryItem(name: "postid", value: String(postid))
                
                _ = try await AddEditPostController().deletePost(matching: [secretQueryItem, postidQueryItem])
            } catch {
                print(error)
            }
        }
    }
}
