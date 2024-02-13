//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), bio: "", techInterests: "", posts: [])
    private var postid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)), repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        getUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
    }
    
    func getUserProfile() {
        
        self.collectionView.reloadData()
        
        Task {
            do {
                let profileToSearch = fetchUserProfile(userUUID: User.current!.userUUID, secret: User.current!.secret)
                userProfile = try await APIController.shared.sendRequest(profileToSearch)
                updateUI()
                collectionView.reloadData()
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
        collectionView.reloadData()
    }
    
    @IBSegueAction func editProfile(_ coder: NSCoder, sender: Any?) -> EditProfileViewController? {
        return EditProfileViewController(coder: coder, secret: User.current!.secret, postProfile: PostProfile(userName: userProfile.userName, bio: userProfile.bio ?? "", techInterests: userProfile.techInterests ?? ""))
    }
    
    @IBSegueAction func createPost(_ coder: NSCoder, sender: Any?) -> AddEditPostViewController? {
        return AddEditPostViewController(coder: coder, post: PostPost(title: "", body: ""))
    }
    
    @IBSegueAction func toEdit(_ coder: NSCoder, sender: Any?) -> AddEditPostViewController? {
        guard let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) else { return nil }
        
        let post = userProfile.posts[indexPath.row]
        
        return AddEditPostViewController(coder: coder, post: PostPost(postid: post.postid, title: post.title, body: post.body))
    }
    
    @IBSegueAction func toComments(_ coder: NSCoder, sender: Any?) -> CommetsViewController? {
        return CommetsViewController(coder: coder, postid: postid)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userProfile.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostsCollectionViewCell
        
        cell.delegate = self
        
        let post = userProfile.posts[indexPath.row]
        
        cell.updateUI(using: post)
        cell.layer.cornerRadius = 20 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostsTableViewCell
        
        cell.delegate = self
        
        let post = userProfile.posts[indexPath.row]
        
        cell.updateUI(using: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete your post?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let post = self.userProfile.posts[indexPath.row]
                self.userProfile.posts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.deletePost(postid: post.postid)
            }))
            present(ac, animated: true)
        }
    }
    
    func deletePost(postid: Int) {
        Task {
            do {
                let deletePostRequest = DeletePost(secret: User.current!.secret, postid: postid)
                _ = try await APIController.shared.sendRequest(deletePostRequest)
            } catch {
                print(error)
            }
        }
    }
}


extension ProfileViewController: PostDelegate {
    func postButtonPressed(postid: Int) {
        self.postid = postid
    }
}
