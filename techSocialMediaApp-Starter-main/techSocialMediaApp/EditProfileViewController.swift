//
//  EditProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Ethan Archibald on 1/31/24.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var techInterestsTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var secret: UUID?
    var userName: String?
    var bio: String?
    var techInterests: String?
    
    required init?(coder: NSCoder, secret: UUID, userName: String, bio: String, techInterests: String) {
        self.secret = secret
        self.userName = userName
        self.bio = bio
        self.techInterests = techInterests
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
        guard (userName != nil), (bio != nil), (techInterests != nil) else { return }
        techInterestsTextField.text = techInterests
        userNameTextField.text = userName
        bioTextField.text = bio
        
    }
    
    func updateProfilePost() {
        if let secret = secret, let userName = userName, let bio = bio, let techInterests = techInterests {
            Task {
                do {
                    let response = try await EditProfileController().editProfilePost(secret: secret, userName: userName, bio: bio, techInterests: techInterests)
                    print(response)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard ((userNameTextField.text?.isEmpty) != nil), ((bioTextField.text?.isEmpty) != nil), ((techInterestsTextField.text?.isEmpty) != nil) else { return }
        updateProfilePost()
        self.navigationController?.popViewController(animated: true)
    }
    
}
