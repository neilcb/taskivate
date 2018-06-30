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
import PhoneNumberKit
import NotificationCenter

class UserProfileController: FormViewController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    var persist = false
    var user:User!
    var defaultCellHeight = CGFloat(72)
    
   
    
    let tf = PhoneNumberTextField()
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.displayUserInfo()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        self.navigationController?.isNavigationBarHidden = false
        SwiftyBeaver.info("view did load")
        
       
        
        
        
        if user == nil {
            displayUserInfo()
        }
        setupUserForm()
        
        
    }
    func setupUserForm() {
        form +++ Section("")
            <<< ImageRow() {
                $0.title = "Profile Picture"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                        self.user.profileImageUrl = profileImageUrl.absoluteString
                        self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteURL.absoluteString)
                    }
                    
                    cell.row.value = self.profileImageView.image
                    
                }
                .onChange(saveImgChanged)
                
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
                displayNameRow.placeholder = "Enter Display name"
                
                }.cellSetup{ cell, row in
                    cell.height = ({return self.defaultCellHeight})
                    
                    if let dn = Auth.auth().currentUser?.displayName {
                        cell.row.value = dn
                    }
                }
                .onCellHighlightChanged{ cell, row in
                    self.displayNameChanged(row: row)
                }
                //.onChange{ row in
                 //   self.displayNameChanged(row: row)
              //}
            
            <<< NameRow(){ fNameRow in
                fNameRow.title = "First Name"
                fNameRow.placeholder = "Enter First Name"
                
                }.cellSetup{ cell, row in
                    cell.height = ({return self.defaultCellHeight})
                    
                    
                    cell.row.value = self.user.firstName
                    cell.textField.text = self.user.firstName
                    
                }
                .onCellHighlightChanged{ cell, row in
                    self.firstNameChanged(row: row)
                }
              //  .onChange{ row in
              //      self.firstNameChanged(row: row)
                    
                
            //}
            
            <<< NameRow(){ displayNameRow in
                displayNameRow.title = "Last Name"
                displayNameRow.placeholder = "Enter Last Name"
                
                }.cellSetup{ cell, row in
                    cell.height = ({return self.defaultCellHeight})
                    
                    cell.row.value = self.user.lastName
                    cell.textField.text = self.user.lastName
                }
               
                .onCellHighlightChanged{ cell, row in
                    self.lastNameChanged(row: row)
                }
            
            <<< PhoneRow("phoneRowTag"){
                
                $0.title = "Phone"
                $0.placeholder = "1(123) 456-7890"
                
                $0.validationOptions = .validatesOnChange
                
                }.cellSetup{ cell, row in
                    cell.height = ({return 72})
                    
                    
                    
                    // Remove original textField from cell so we can then replace it with an as-you-type phone formatting field
                    cell.textField.removeFromSuperview()
                    
                    // Add as-you-type phone formatting field
                    self.tf.maxDigits = 11
                    
                    self.tf.translatesAutoresizingMaskIntoConstraints = false
                    cell.textField = self.tf
                    cell.contentView.addSubview(self.tf)
                    row.value = self.user.phone
                    SwiftyBeaver.info("phone row setup \(row.value ?? "empty")")
                    SwiftyBeaver.info("user phone \(self.user.phone)")
                    cell.textField.text = self.user.phone
                    
                }
                .onCellHighlightChanged{ phoneCell, phoneRow in
                    phoneRow.value = phoneCell.textField.text
                    SwiftyBeaver.info("phone row \(phoneRow.value ?? "empty")")
                    self.phoneNumberChanged(row: phoneRow)
            }
            <<< DateRow(){
                $0.title = "Date Of Birth"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
                }
                .cellSetup{ cell, row in
                    cell.height = ({return self.defaultCellHeight})
                    cell.row.value = self.user.dateOfBirth
                }
        
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
    }
    
    func saveImgChanged(row: ImageRow){
        
            let imgURL = row.imageURL
        
            //let sv = UIViewController.displaySpinner(onView: self.view)
            if let localFile = imgURL?.absoluteURL.absoluteString {
                SwiftyBeaver.info(localFile)
            }
           
            profileImageView.image = row.value
            let pickedImage = row.value!
            let userId = Auth.auth().currentUser?.uid
            
            UserAPI.updateProfilePic(uid: userId!, profilePic: pickedImage, completion: { (status, error) in
                if let error = error {
                    print(error)
                  // UIViewController.removeSpinner(spinner: sv)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    if let profileImageUrl = Auth.auth().currentUser?.photoURL {
                        self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
                    }
                   //UIViewController.removeSpinner(spinner: sv)
                }
            })
            //displayUserInfo()
            row.cell.update()
        
        
    }
    
    func displayNameChanged(row: NameRow) {
        if let name = row.value {
            
            UserAPI.updateDisplayName(displayName: name, completion: {(status, error) in
                if let error = error {
                    SwiftyBeaver.error(error)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    SwiftyBeaver.info("display name changed")
                }
            })
        }
            
            
       
    }
    
    func firstNameChanged(row: NameRow) {
        if let fName = row.value {
            SwiftyBeaver.info("firstname \(fName)")
            UserAPI.updateFirstName(firstName: fName, completion: { (status, error) in
                if let error = error {
                    SwiftyBeaver.error(error)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    
                    SwiftyBeaver.info("fn name changed")
                }
            })
           
            
        }
        
        
       
    }
    
    func lastNameChanged(row: NameRow) {
        if let lName = row.value {
            SwiftyBeaver.info("lastname \(lName)")
            UserAPI.updateLastName(lastName: lName, completion: { (status, error) in
                if let error = error {
                    SwiftyBeaver.error(error)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    
                    SwiftyBeaver.info("ln name changed")
                }
            })
            
            
        }
    }
    
    func phoneNumberChanged(row: PhoneRow) {
        
        let errors = row.validate()
        guard errors.isEmpty else {
            SwiftyBeaver.error(errors[0])
            return
        }
        
        
        
        if let phone = row.value {
            
            
            
            UserAPI.updatePhone(phone: phone, completion: { (status, error) in
                if let error = error {
                    SwiftyBeaver.error(error)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    SwiftyBeaver.info("ph # changed")
                    row.cell.update()
                }
            })
            
        }
    }
    
    func displayUserInfo() {
        
        if let id = Auth.auth().currentUser?.uid {
            let sv = UIViewController.displaySpinner(onView: self.view)
            UserAPI.fetchUserToDisplay(uid: id, completionHandler: { (user, error) in
                if let error = error {
                    print(error)
                    UIViewController.removeSpinner(spinner: sv)
                    let alert = UIAlertController(title: "Error finding user", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    self.user = user!
                    for row in self.form.allRows {
                        row.updateCell()
                        UIViewController.removeSpinner(spinner: sv)
                    }
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



