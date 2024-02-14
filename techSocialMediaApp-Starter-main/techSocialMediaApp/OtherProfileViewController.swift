//
//  OtherProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/13/24.
//

import UIKit

class OtherProfileViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var techInterestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), bio: "", techInterests: "", posts: [])
    var userId: String?
    var secret: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        guard userId != "", let secret = secret else { return }
        Task {
            do {
                let profileFetchRequest = techSocialMediaApp.fetchUserProfile(userUUID: UUID(uuidString: userId!)!, secret: secret)
                userProfile = try await APIController.shared.sendRequest(profileFetchRequest)
                updateUI()
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUI() {
        nameLabel.text = "\(userProfile.firstName) \(userProfile.lastName)"
        bioLabel.text = userProfile.bio
        techInterestsLabel.text = userProfile.techInterests
        navigationItem.title = userProfile.userName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toComments = segue.destination as? CommetsViewController, let postid = sender as? Int {
            toComments.postid = postid
        }
    }
    
}

extension OtherProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userProfile.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostsCollectionViewCell
        
        let post = userProfile.posts[indexPath.row]
        
        cell.delegate = self
        
        cell.updateUI(using: post)
        cell.layer.cornerRadius = 20
        
        return cell
    }
}

extension OtherProfileViewController: PostDelegate {
    func commentButtonPressed(postid: Int) {
        performSegue(withIdentifier: "toComments", sender: postid)
    }
    
    func userNameButtonPressed(authorUserId: String) {
    }
}
