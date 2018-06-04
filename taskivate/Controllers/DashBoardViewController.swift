//
//  UserProfileViewController.swift
//  taskivate
//
//  Created by Neil Baron on 1/20/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI

import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import SwiftyBeaver

class DasboardViewController: UIViewController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    //var demoFeatures: [DemoFeature] = []
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    var image:UIImage?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    var absoluteUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       
        if let image = UIImage(named: "user-filled-50") {
            self.addLeftBarIcon(image: image)
            
        }
        
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        SwiftyBeaver.info("view did load in dashboad")
        UserDefaults.standard.set(false, forKey: User.userSynchKey)
       

    }
    
    func checkIfUserIsLoggedIn() {
        if (Auth.auth().currentUser?.uid == nil) {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
             SwiftyBeaver.error("Problem logging out \(logoutError)")
        }
        
        let loginController = HomeViewController()
        if let navc = self.navigationController {
            navc.pushViewController(loginController, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in

            
            self.navigationController?.isNavigationBarHidden = false
           
            let photoURL = user?.photoURL
            
            let name = user?.displayName
            
            if name != nil {
                var stringArr = name?.components(separatedBy: " ")
                self.navigationItem.title = "Hello \(stringArr![0])"
                
            }
            
            
            if let url = photoURL {
              self.absoluteUrl = url.absoluteString
              self.downloadImage(url: url)
            
            }
            
            let userSynchedOnLogin = UserDefaults.standard.bool(forKey: User.userSynchKey)
           
            SwiftyBeaver.info("User is synced on login \(userSynchedOnLogin)")
            if(!userSynchedOnLogin){
                self.synchUser()
            }
            
        }
        
        
       
    }
    
    func synchUser() {
        
        let uid = Auth.auth().currentUser?.uid
        let email = Auth.auth().currentUser?.email
        let profileImageUrl = Auth.auth().currentUser?.photoURL?.absoluteString
        let user = User()
        user.id = uid!
        user.email = email!
        user.profileImageUrl = profileImageUrl!
        let stringArray = Auth.auth().currentUser?.displayName?.components(separatedBy: " ")
        if(stringArray != nil) {
            user.firstName = (stringArray?[0])!
            user.lastName = (stringArray?[1])!
        }
        
        UserAPI.syncUserData(user: user) { (status, error) in
            if let err = error {
                SwiftyBeaver.error("problem synching user \(err)")
            } else {
                SwiftyBeaver.info("user has synched")
                UserDefaults.standard.set(true, forKey: User.userSynchKey)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
      
        ImageHelper.getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
                if let img = self.image {
                    self.addLeftBarIcon(image: img)
                    let data:NSData = img.jpeg(.lowest)! as NSData
                    
                    UserDefaults.standard.set(data, forKey: "userImageKey")
                }
            }
        }
    }
    
    
    
    func addLeftBarIcon(image: UIImage) {
        
        let logoImage = image
        
        let iconImageView = UIImageView.init(image: logoImage)
        iconImageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40.0)
        iconImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: iconImageView)
     
        iconImageView.isUserInteractionEnabled = true
        iconImageView.layer.cornerRadius = iconImageView.layer.frame.width/2
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.borderWidth = 1
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapping(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        iconImageView.addGestureRecognizer(singleTap)
        
       
      
        let widthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        negativeSpacer.width = -25
     
        imageItem.target = self
        imageItem.action = #selector(leftNavItemTapped)
        navigationItem.leftBarButtonItem =  imageItem
        
        //self.view.addSubview(iconImageView)
      
    }
    
    
    
    func addRightBarIcon(image: UIImage) {
        
        let logoImage = image
        let iconImageView = UIImageView.init(image: logoImage)
        iconImageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40.0)
        iconImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: iconImageView)
        
        iconImageView.isUserInteractionEnabled = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightNavItemTapped(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        iconImageView.addGestureRecognizer(singleTap)
        
        
        
        let widthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        negativeSpacer.width = 25
        
        imageItem.target = self
        
        navigationItem.rightBarButtonItem =  imageItem
        
        self.view.addSubview(iconImageView)
        
    }
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = loginButton
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.title = NSLocalizedString("Settings", comment: "Label for the logout button.")
        navigationItem.rightBarButtonItem!.action = #selector(rightNavItemTapped(recognizer:))
        
    }
    
    @objc func leftNavItemTapped() {
        print("left nav tapped")
//        let userProfileViewController = storyboard?.instantiateViewController(withIdentifier: "userProfileViewController") as! UserProfileViewController
//        userProfileViewController.uiImageView.image = self.image
//
//
//        //performSegue(withIdentifier: "userProfileViewController", sender: self)
//        self.navigationController!.pushViewController(userProfileViewController, animated: true)
    }
   
    @objc func rightNavItemTapped(recognizer: UIGestureRecognizer) {
        print("right nav tapped")
//        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
//        //settingViewController.uiImageView.image = self.image
//
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        self.navigationItem.backBarButtonItem = backItem
//        self.navigationController!.pushViewController(settingViewController, animated: true)
    }
   
    
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        print("image clicked")
//        let userProfileViewController = storyboard?.instantiateViewController(withIdentifier: "userProfileViewController") as! UserProfileViewController
//        userProfileViewController.imageA1 = self.image
//        userProfileViewController.hidesBottomBarWhenPushed = true
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        self.navigationItem.backBarButtonItem = backItem
//        self.navigationController!.pushViewController(userProfileViewController, animated: true)
    }
    
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
