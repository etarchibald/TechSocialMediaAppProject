//
//  AddEditPostViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/5/24.
//

import UIKit

class AddEditPostViewController: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var post: PostPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        saveButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
    }
    
    func updateUI() {
        guard let post = post else { return }
        titleTextField.text = post.title
        bodyTextView.text = post.body
    }
    
    func createPost() {
        if let post = post {
            Task {
                do {
                    let createPostRequest = CreatePost(secret: User.current!.secret, post: post)
                    _ = try await APIController.shared.sendRequest(createPostRequest)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func editPost() {
        if let post = post {
            Task {
                do {
                    let editPostRequest = EditPost(secret: User.current!.secret, post: post)
                    _ = try await APIController.shared.sendRequest(editPostRequest)
                } catch {
                    print(error)
                }
            }
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard titleTextField.text != "", bodyTextView.text != "" else { return }
        if post?.postid != nil {
            post = PostPost(postid: post?.postid, title: titleTextField.text!, body: bodyTextView.text!)
            editPost()
        } else {
            post = PostPost(title: titleTextField.text!, body: bodyTextView.text)
            createPost()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard titleTextField.text != "", bodyTextView.text != "" else { return }
        let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete your post?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deletePost(postid: (self.post?.postid)!)
            self.navigationController?.popViewController(animated: true)
        }))
        present(ac, animated: true)
    }
    
}
