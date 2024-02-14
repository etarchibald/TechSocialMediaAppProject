//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/29/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), bio: "", techInterests: "", posts: [])
    let secret = User.current?.secret
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toComments = segue.destination as? CommetsViewController, let postid = sender as? Int {
            toComments.postid = postid
        }
        
        if let editProfile = segue.destination as? EditProfileViewController, let postProfile = sender as? PostProfile {
            editProfile.postProfile = postProfile
            editProfile.secret = User.current!.secret
        }
        
        if let createPost = segue.destination as? AddEditPostViewController, let postPost = sender as? PostPost, let secret = secret {
            createPost.post = postPost
            createPost.secret = secret
            createPost.navigationItem.title = "Create your post!"
        }
        
        if let editPost = segue.destination as? AddEditPostViewController, let postPost = sender as? PostPost, let secret = secret {
            editPost.post = postPost
            editPost.secret = secret
            editPost.navigationItem.title = "Edit your post!"
        }
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfile", sender: PostProfile(userName: userProfile.userName, bio: userProfile.bio ?? "", techInterests: userProfile.techInterests ?? ""))
    }
    
    @IBAction func createPostButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "createPost", sender: PostPost(title: "", body: ""))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = userProfile.posts[indexPath.row]
        performSegue(withIdentifier: "editPost", sender: PostPost(postid: post.postid, title: post.title, body: post.body))
    }
    
}

extension ProfileViewController: PostDelegate {
    func commentButtonPressed(postid: Int) {
        performSegue(withIdentifier: "toComment", sender: postid)
    }
    
    func userNameButtonPressed(authorUserId: String) {
    }
}
