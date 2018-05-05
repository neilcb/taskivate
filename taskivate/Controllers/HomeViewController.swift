//
//  ViewController.swift
//  taskivate
//
//  Created by Neil Baron on 12/10/17.
//  Copyright © 2017 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI

class HomeViewController: UIViewController, FUIAuthDelegate {
    
    
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),FUIFacebookAuth()
        ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("view did load")
        
       
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            
        }
        // Do any additional setup after loading the view, typically from a nib.
        self.auth = Auth.auth()
        
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = providers
        
        
        
        self.navigationItem.leftBarButtonItem = nil
       
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
           guard user != nil else {
                print("authstatelistener")
                self.loginAction()
                return
            }
           UserAPI.updateOnlineStatus(online: true, uid: (user?.uid)!, completion: { (status) in
             if  status  {
                    print("online status set to true")
               } else {
                   print("problem updating status")
                }
            })
          
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
       
       
        // Present the default login view controller provided by authUI
        
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                
//                print("1 user not siged in redirecting to signin")
//                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! HomeViewController
//                if let navc = self.navigationController {
//                    navc.pushViewController(homeViewController, animated: true)
 //               }
                return
                
            }
            
            
            let dashBoardViewController = DasboardViewController()
           
            if let dnavc = self.navigationController {
                dnavc.pushViewController(dashBoardViewController, animated: true)
            }
            
        }
        
        
       
        
        
        
    }

    
    func loginAction() {
        // Present the default login view controller provided by authUI
        
        let authViewController = TaskivateAuthViewController(authUI: authUI!)
     
        let navc = UINavigationController(rootViewController: authViewController)
     //
        self.parent?.present(navc, animated: true, completion: nil)
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: Firebase.User?, error: Error?) {
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
            
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
            
            ViewControllerUtils.showAlertMessage(vc: self, titleStr: "Error", messageStr: "Login error: \((detailedError as! NSError).localizedDescription)")
            
            
        }
    }
    
    
    
    @objc func signOut() {
       
        do {
            try Auth.auth().signOut()
            print("signing out")
        } catch  {
           print("problem signing out")
        }
    }
    


}

