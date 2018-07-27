//
//  CustomTabBarController.swift
//  taskivate
//
//  Created by Neil Baron on 5/2/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import SwiftyBeaver

class CustomTabBarController : UITabBarController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyBeaver.info("Setting up custom tab bar")
        
        
        SwiftyBeaver.info("checking valid user")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
//                let dashboardBoardController = DashboardController()
//                dashboardBoardController.tabBarItem.image = #imageLiteral(resourceName: "list-1")
//                dashboardBoardController.tabBarItem.selectedImage = #imageLiteral(resourceName: "list-1-selected")
//                dashboardBoardController.title = "Dashboard"
//                let dashboardNavController = UINavigationController(rootViewController: dashboardBoardController)
//
                let flowLayout = UICollectionViewFlowLayout()
                //let customCollectionViewController = DashbaordCollectionView(collectionViewLayout: flowLayout)
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                let dashboardCollectionVC = DashbaordCollectionVC(collectionViewLayout: flowLayout)
                dashboardCollectionVC.tabBarItem.image = #imageLiteral(resourceName: "list-1")
                dashboardCollectionVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "list-1-selected")
                dashboardCollectionVC.title = "Dashboard"
                let collectionViewNavController = UINavigationController(rootViewController: dashboardCollectionVC)
//
                
              
//                let usersController = UsersViewController()
//                usersController.tabBarItem.image = #imageLiteral(resourceName: "users")
//                usersController.tabBarItem.selectedImage = #imageLiteral(resourceName: "users-selected")
//                usersController.tabBarItem.title = "Users"
//
//                let userNavController = UINavigationController(rootViewController: usersController)
//                
                let taskController = TaskViewController()
                taskController.tabBarItem.image = #imageLiteral(resourceName: "list-2")
                taskController.tabBarItem.selectedImage = #imageLiteral(resourceName: "list-2-selected")
                taskController.title = "Tasks"
                let taskNavController = UINavigationController(rootViewController: taskController)
                
                let settingsController = SettingsViewController()
                settingsController.tabBarItem.image = #imageLiteral(resourceName: "sliders")
                settingsController.tabBarItem.selectedImage = #imageLiteral(resourceName: "sliders-selected-1")
                settingsController.title = "Settings"
                let settingsNavController = UINavigationController(rootViewController: settingsController)
                
                self.viewControllers = [collectionViewNavController, taskNavController,settingsNavController]
            } else {
                SwiftyBeaver.info("user is not logged in giong to login controller")
                let loginController = HomeViewController()
               // self.navigationController?.pushViewController(loginController, animated: true)
                self.viewControllers = [loginController]
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
       
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
}


