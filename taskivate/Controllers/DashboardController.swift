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

class DashboardController: BaseViewController {
    var titleText = "Hello"

    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    var db: Firestore!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = titleText
        checkIfUserIsLoggedIn()
        setUpDisplayName()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDisplayName()
        setUpProfileImage()
      
    }
    func checkIfUserIsLoggedIn() {
        SwiftyBeaver.info("checking valid user")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                SwiftyBeaver.info("user is logged \(user?.uid ?? "none for user")")
            } else {
                SwiftyBeaver.info("user is not logged in giong to login controller")
                let loginController = HomeViewController()
                self.navigationController?.pushViewController(loginController, animated: true)
            }
        }
    }
    
    func setUpDisplayName() {
        if let user = Auth.auth().currentUser {
            if(!(user.displayName?.isEmpty)!) {
                var stringArr = user.displayName?.components(separatedBy: " ")
                self.navigationItem.title = "Hello \(stringArr![0])"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayUserInfo() {
       
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }
            
       
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
