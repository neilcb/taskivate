//
//  MyFormViewController.swift
//  taskivate
//
//  Created by Neil Baron on 6/3/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Eureka
import ImageRow
import SwiftyBeaver
import Firebase
import FirebaseAuthUI

class UserProfileController: FormViewController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    var user = User()
    var defaultCellHeight = CGFloat(72)
    
    let profileImageView: UIImageView = {
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
       
        self.navigationItem.title = "Profile"
        self.navigationController?.isNavigationBarHidden = false
        
        form +++ Section("")
            <<< ImageRow() {
                $0.title = "Profile Picture"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                        self.user.profileImageUrl = profileImageUrl.absoluteString
                        self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
                    }
        
                cell.row.value = self.profileImageView.image
                    
                }
                .onChange(self.saveImgChanged)
                .cellSetup{ cell, row in
                    cell.accessoryView?.layer.cornerRadius = 20
                    cell.accessoryView?.layer.borderColor = UIColor.white.cgColor
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    cell.selectionStyle = .default
                    if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                        self.user.profileImageUrl = profileImageUrl.absoluteString
                    }
                    
                  
                    if let profileImageUrl = self.user.profileImageUrl {
                        self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl)
                    }
                    
                    cell.height = ({return self.defaultCellHeight})
                    cell.row.value = self.profileImageView.image
                    
            }
            <<< NameRow(){ displayNameRow in
                displayNameRow.title = "Display Name"
                displayNameRow.placeholder = "Enter full name"
                
            }.cellSetup{ cell, row in
                cell.height = ({return self.defaultCellHeight})
                if let dn = Auth.auth().currentUser?.displayName {
                    cell.row.value = dn
                }
            }

            <<< PhoneRow(){
                $0.title = "Phone"
                $0.placeholder = "1222333444"
            }.cellSetup{ cell, row in
                cell.height = ({return 72})
            }
           
            <<< DateRow(){
                $0.title = "Date Of Birth"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }.cellSetup{ cell, row in
                cell.height = ({return self.defaultCellHeight})
            }
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        
    }
    //
    
    func saveImgChanged(row: ImageRow){
        let imgURL = row.imageURL
       // let sv = UIViewController.displaySpinner(onView: self.view)
        if let localFile = imgURL?.absoluteURL.absoluteString {
            SwiftyBeaver.info(localFile)
        }
       
        profileImageView.image = row.value
        let pickedImage = row.value!
        let userId = Auth.auth().currentUser?.uid
        
        UserAPI.updateProfilePic(uid: userId!, profilePic: pickedImage, completion: { (status, error) in
            if let error = error {
                print(error)
                //UIViewController.removeSpinner(spinner: sv)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            } else {
                if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                    self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
                }
               // UIViewController.removeSpinner(spinner: sv)
            }
        })
        displayUserInfo()
        row.cell.update()
        
    }
    
    func displayNameChanged(row: NameRow) {
        //UserAPI.updateUser(firstName: <#T##String#>, lastName: <#T##String#>, completion: <#T##(Bool, Error?) -> Void#>)
    }
    
    func displayUserInfo() {
        
        if let id = Auth.auth().currentUser?.uid {
            UserAPI.fetchUserToDisplay(uid: id, completionHandler: { (user, error) in
                if let error = error {
                    print(error)
                    //UIViewController.removeSpinner(spinner: sv)
                    let alert = UIAlertController(title: "Error finding user", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    self.user = user!
                }
                
            })
        }
       
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                
                print("user not siged in redirecting to signin")
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! HomeViewController
                if let navc = self.navigationController {
                    navc.pushViewController(homeViewController, animated: true)
                }
                return
                
            }
            
            if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
            }
            
        }
    }
}



