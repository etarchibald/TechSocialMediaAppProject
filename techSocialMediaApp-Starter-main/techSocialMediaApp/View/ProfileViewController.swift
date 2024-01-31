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
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), bio: "", techInterests: "", posts: [])
    private var userProfileController = UserProfileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostsTableViewCell
        
        return cell
    }
}
