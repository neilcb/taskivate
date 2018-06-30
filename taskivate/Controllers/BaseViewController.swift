//
//  BaseViewController.swift
//  taskivate
//
//  Created by Neil Baron on 6/29/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver

class BaseViewController: UIViewController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40.0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpProfileImage()
    }
    
    func setUpProfileImage() {
        
        let widthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 40)

        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .done, target: nil, action: nil)
        negativeSpacer.width = 25
        
        let imageItem = UIBarButtonItem.init(customView: profileImageView)
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTaped(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        profileImageView.addGestureRecognizer(singleTap)
        
        navigationItem.leftBarButtonItem =  imageItem
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }
    }
    
    @objc func profileImageTaped(recognizer: UIGestureRecognizer) {
        print("image clicked")
        SwiftyBeaver.info("profile image selected/tapped")
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let userProfileController = UserProfileController()
        userProfileController.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        if let id = Auth.auth().currentUser?.uid {
            UserAPI.fetchUserToDisplay(uid: id, completionHandler: { (user, error) in
                if let error = error {
                    print(error)
                    UIViewController.removeSpinner(spinner: sv)
                    let alert = UIAlertController(title: "Error finding user", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    UIViewController.removeSpinner(spinner: sv)
                    userProfileController.user = user!
                    //userProfileController.supportedInterfaceOrientations = .portrait
                    self.navigationItem.backBarButtonItem = backItem
                    self.navigationController?.pushViewController(userProfileController, animated: false)
                }
                
            })
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
