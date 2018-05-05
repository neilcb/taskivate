//
//  DashboardController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver

class DashboardController: UIViewController {
    var titleText = "Hello"
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    //var demoFeatures: [DemoFeature] = []
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    var db: Firestore!
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
       
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = titleText
        
        setUpDisplayName()
        setUpProfileImage()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpDisplayName() {
        if let user = Auth.auth().currentUser {
            if(!(user.displayName?.isEmpty)!) {
                var stringArr = user.displayName?.components(separatedBy: " ")
                self.navigationItem.title = "Hello \(stringArr![0])"
            }
        }
    }
    
    func setUpProfileImage() {
        // add contraints
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
           self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }
        
        let widthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        let imageItem = UIBarButtonItem.init(customView: profileImageView)
    
      
        navigationItem.leftBarButtonItem =  imageItem
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
