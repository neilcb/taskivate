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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyBeaver.info("Setting up custom tab bar")
        checkIfUserIsLoggedIn()
        // set up tab controller views
        
        let dashboardBoardController = DashboardController()
        dashboardBoardController.tabBarItem.image = #imageLiteral(resourceName: "list-1")
        dashboardBoardController.tabBarItem.selectedImage = #imageLiteral(resourceName: "list-2-selected")
        dashboardBoardController.title = "Dashboard"
        let dashboardNavController = UINavigationController(rootViewController: dashboardBoardController)
        
        let usersController = UsersViewController()
        usersController.tabBarItem.image = #imageLiteral(resourceName: "users")
        usersController.tabBarItem.selectedImage = #imageLiteral(resourceName: "users-selected")
        usersController.tabBarItem.title = "Users"
       
        let userNavController = UINavigationController(rootViewController: usersController)
        
        let taskController = TaskViewController()
        taskController.tabBarItem.image = #imageLiteral(resourceName: "list-2")
        taskController.tabBarItem.selectedImage = #imageLiteral(resourceName: "list-2-selected")
        taskController.title = "Tasks"
        let taskNavController = UINavigationController(rootViewController: taskController)
        
        let settingsController = SettingsViewController()
        settingsController.tabBarItem.image = #imageLiteral(resourceName: "sliders")
        settingsController.tabBarItem.selectedImage = #imageLiteral(resourceName: "sliders-selected-1")
        let settingsNavController = UINavigationController(rootViewController: settingsController)
        
        viewControllers = [dashboardNavController,userNavController,taskNavController,settingsNavController]
        
    }
    
    func checkIfUserIsLoggedIn() {
        SwiftyBeaver.info("checking valid user")
        if (Auth.auth().currentUser?.uid == nil) {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            SwiftyBeaver.info("performing logout")
        } else {
            SwiftyBeaver.info("synching user \(Auth.auth().currentUser?.uid ?? "")")
            synchUser()
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


