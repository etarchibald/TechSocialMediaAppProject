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
    var postProfile: PostProfile?
    
    required init?(coder: NSCoder, secret: UUID, postProfile: PostProfile) {
        self.secret = secret
        self.postProfile = postProfile
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
        guard let postProfile = postProfile else { return }
        techInterestsTextField.text = postProfile.techInterests
        userNameTextField.text = postProfile.userName
        bioTextField.text = postProfile.bio
        
    }
    
    func updateProfilePost() {
        if let secret = secret, let postProfile = postProfile {
            Task {
                do {
                    let editProfileRequest = EditProfilePost(secret: secret, postProfile: postProfile)
                    _ = try await APIController.shared.sendRequest(editProfileRequest)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let userName = userNameTextField.text, let bio = bioTextField.text, let techInterests = techInterestsTextField.text  else { return }
        postProfile = PostProfile(userName: userName, bio: bio, techInterests: techInterests)
        updateProfilePost()
        self.navigationController?.popViewController(animated: true)
    }
}
