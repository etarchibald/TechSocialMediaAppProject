//
//  AllPostsViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/6/24.
//

import UIKit

class AllPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post(postid: 0, title: "", body: "", authorUserName: "", authorUserId: "", likes: 0, userLiked: false, numComments: 0, createdDate: "")]
    var postid = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.9)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        fetchPosts(pageNumber: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPosts(pageNumber: pageNumber)
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
    
    @IBSegueAction func toComments(_ coder: NSCoder, sender: Any?) -> CommetsViewController? {
        return CommetsViewController(coder: coder, postid: postid)
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
    func postButtonPressed(postid: Int) {
        self.postid = postid
    }
}
