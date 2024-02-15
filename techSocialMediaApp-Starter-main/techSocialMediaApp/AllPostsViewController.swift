//
//  AllPostsViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/6/24.
//

import UIKit

class AllPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var pageNumber = 0
    let secret = User.current?.secret
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.9)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        fetchPosts(pageNumber: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPosts(pageNumber: pageNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toOtherProfile = segue.destination as? OtherProfileViewController, let userId = sender as? String, let secret = secret {
            toOtherProfile.userId = userId
            toOtherProfile.secret = secret
        }
        
        if let toComments = segue.destination as? CommetsViewController, let postid = sender as? Int, let secret = secret {
            toComments.postid = postid
            toComments.secret = secret
        }
    }
    
    func fetchPosts(pageNumber: Int) {
        Task {
            do {
                let postRequest = FetchPosts(secret: User.current!.secret, pageNumber: pageNumber)
                posts = try await APIController.shared.sendRequest(postRequest)
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension AllPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostsCollectionViewCell
        
        cell.delegate = self
        
        let post = posts[indexPath.row]
        
        cell.updateUI(using: post)
        cell.layer.cornerRadius = 20
        
        return cell
    }
}

extension AllPostsViewController: PostDelegate {
    func userNameButtonPressed(authorUserId: String) {
        performSegue(withIdentifier: "toOtherProfile", sender: authorUserId)
    }
    
    func commentButtonPressed(postid: Int) {
        performSegue(withIdentifier: "toComments", sender: postid)
    }
}
