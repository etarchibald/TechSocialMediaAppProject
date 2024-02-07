//
//  AddEditPostViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 2/5/24.
//

import UIKit

class AddEditPostViewController: UIViewController {

    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var post: PostPost?
    
    required init?(coder: NSCoder, post: PostPost) {
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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
}
