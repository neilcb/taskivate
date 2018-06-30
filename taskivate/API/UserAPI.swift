//
//  UserAPI.swift
//  taskivate
//
//  Created by Neil Baron on 3/3/18.
//  Copyright © 2018 taskivate. All rights reserved.
//


import Foundation
import Firebase
import FirebaseAuthUI

import SwiftyBeaver

class UserAPI: NSObject {
    
    static let sharedInstance = UserAPI()
    static let userImage = "userImageKey"
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    override init() {
        
    }
    
    
    
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.sendEmailVerification(completion: nil)
                let storageRef = Storage.storage().reference().child("usersProfilePics").child(user!.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["name": withName, "email": email, "profilePicLink": path!]
                        Database.database().reference().child("users").child((user?.uid)!).child("details").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                    }
                })
            }
            else {
                completion(false)
            }
        })
    }
    
    class func registerChildUser(withName: String, email: String, password: String, parentUid: String, completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FirebaseOptions.init(contentsOfFile: path)
        FirebaseApp.configure(name: "SecondaryApp", options: options!)
        let secondary_app = FirebaseApp.app(name: "SecondaryApp")
        let second_auth = Auth.auth(app: secondary_app!)
       
            second_auth.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                // new firebase document
                    second_auth.sendPasswordReset(withEmail: email) { error in
                        if let err = error {
                            SwiftyBeaver.error("Unable to send password reset message\(err.localizedDescription) ")
                        } else {
                            SwiftyBeaver.info("password reset message sent")
                        }
                }
                
               
                do {
                    try! second_auth.signOut()
                   
                    
                }
                  
                    
                   
               
                completion(true,nil)
                
                } else {
                    SwiftyBeaver.error(error.debugDescription)
                    completion(false,error)
                }
            })
       
        
    }
    
    class func queryUser(uid: String) -> User {
        var user = User()
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                SwiftyBeaver.info("Document data: \(dataDescription)")
                
                user = User().mapUser(dictionary: document.data()!)
                user.id = document.documentID
                
                
               
            } else {
                SwiftyBeaver.info("user doesn't exist")
            }
        }
        return user
        
        
    }
    
    class func fetchUserToDisplay(uid:String, completionHandler: @escaping (User?, Error?) -> Swift.Void) {
        var user = User()
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                SwiftyBeaver.info("Document data: \(dataDescription)")
                
                user = User().mapUser(dictionary: document.data()!)
                completionHandler(user,nil)
                
                
                
            } else if let err = error{
                SwiftyBeaver.error(err.localizedDescription)
                completionHandler(nil,err)
            }
        }
    }
    
    class func updateUser(displayName: String, firstname: String, lastName: String, dob: Date, phone: String, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        let uid = Auth.auth().currentUser?.uid
        let email = Auth.auth().currentUser?.email
        let url = Auth.auth().currentUser?.photoURL
        changeRequest?.displayName = displayName
        
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("display \(error)")
                completion(false, error)
            } else {
                let user = User()
                user.firstName = firstname
                user.lastName = lastName
                user.id = uid!
                user.email = email!
                user.phone = phone
                user.dateOfBirth = dob
                user.profileImageUrl = url?.absoluteString
                syncUserData(user: user, completion: { (status, error) in
                    if(status) {
                        SwiftyBeaver.info("user synch success")
                    } else if let e = error {
                        SwiftyBeaver.error("problem synch data \(e)")
                    }
                })
                completion(true, nil)
            }
        }
        
        
    }
    /*
    
    */
    class func syncUserData(user: User, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        // user first name and last concat as display (for search)
        
        // get display name if available
        if let dn = Auth.auth().currentUser?.displayName {
            user.displayName = dn
        }
        db.collection("users").document(user.id).setData([
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email,
            "prorfileImageUrl": user.profileImageUrl!,
            "displayName": user.displayName,
            "dob": user.dateOfBirth,
            "phone": user.phone,
            "lastAccessDt": DateUtils.getCurrentTimestamp()
            
        ],options: SetOptions.merge()) { err in
            if let err = err {
                SwiftyBeaver.error("Error writing document: \(err)")
                completion(false,err)
            } else {
                SwiftyBeaver.info("Document successfully written!")
                completion(true,nil)
            }
        }
    }
    
    class func updateProfilePic(uid: String, profilePic: UIImage, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("usersProfilePics").child(uid!)
        let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
            if err == nil {
                let path = metadata?.downloadURL()
              
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = path
                changeRequest?.commitChanges { (error) in
                    if let error = error {
                        print(error)
                        completion(false, error)
                    } else {
                        print("profile pic udpated")
                        completion(true, nil)
                    }
                }
            } else {
                completion(false, err)
            }
        })
    }
    
    class func getUserProfilePicUrl(uid: String,  completion: @escaping (URL, Error?) -> Swift.Void) {
        
        
        let storageRef = Storage.storage().reference().child("usersProfilePics").child(uid)
        
        storageRef.downloadURL { url, error in
            if let error = error {
                SwiftyBeaver.error("unable to download url")
                completion(url!, error)
            } else {
                if let downloadUrl = url {
                    SwiftyBeaver.info(downloadUrl.absoluteString)
                    completion(url!, nil)
                }
            }
        }
    }
    // update email
    class func updateEmail(newEmailAddress: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        let uid = Auth.auth().currentUser?.uid
        Auth.auth().currentUser?.updateEmail(to: newEmailAddress) { (error) in
            if let error = error {
                completion(false, error)
            } else {
                syncEmail(email: newEmailAddress, uid: uid!, completion: { (status, error) in
                    if let err = error {
                        SwiftyBeaver.error(err.localizedDescription)
                    }
                })
                completion(true, nil)
            }
        }
    }
    
    class func updateDisplayName(displayName: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
      
        changeRequest?.displayName = displayName
        
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("display \(error)")
                completion(false, error)
            } else {
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).setData([
                        "displayName": displayName
                    ],options: SetOptions.merge()) { err in
                        if let err = err {
                            SwiftyBeaver.error("Error saving phone to document: \(err)")
                            completion(false,err)
                        } else {
                            SwiftyBeaver.info("Phone Updated")
                            completion(true,nil)
                        }
                    }
                completion(true,nil)
                }
            }
        }
    }
    
    class func updatePhone(phone: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            
            db.collection("users").document(uid).setData([
                
                "phone": phone
                
            ],options: SetOptions.merge()) { err in
                if let err = err {
                    SwiftyBeaver.error("Error saving phone to document: \(err)")
                    completion(false,err)
                } else {
                    SwiftyBeaver.info("Phone Updated")
                    completion(true,nil)
                    
                }
            }
        }
    }
    
    class func queryUserPhone(uid: String, completion: @escaping (String,Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            
        }
            
        
    }
    
    class func updateFirstName(firstName: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            SwiftyBeaver.info("firstName \(firstName)")
            db.collection("users").document(uid).setData([
                
                "firstName": firstName
                
            ],options: SetOptions.merge()) { err in
                if let err = err {
                    SwiftyBeaver.error("Error saving fname to document: \(err)")
                    completion(false,err)
                } else {
                    SwiftyBeaver.info("fn Updated")
                    completion(true,nil)
                }
            }
        }
    }
    
    class func updateLastName(lastName: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            SwiftyBeaver.info("lastname \(lastName)")
            db.collection("users").document(uid).setData([
                
                "lastName": lastName
                
            ],options: SetOptions.merge()) { err in
                if let err = err {
                    SwiftyBeaver.error("Error saving fname to document: \(err)")
                    completion(false,err)
                } else {
                    SwiftyBeaver.info("ln Updated")
                    completion(true,nil)
                }
            }
        }
    }
    
    class func syncEmail(email: String, uid:String, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).setData([
           
            "email:": email
            
        ],options: SetOptions.merge()) { err in
            if let err = err {
                SwiftyBeaver.error("Error synching email document: \(err)")
                completion(false,err)
            } else {
                SwiftyBeaver.info("Email synced!")
                completion(true,nil)
            }
        }
    }
    
    
    
    class func updateOnlineStatus(online: Bool, uid: String, completion: @escaping (Bool) -> Swift.Void) {
      
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "online": online,
            "lastAccessDt": DateUtils.getCurrentTimestamp()
           
        ],options: SetOptions.merge()) { err in
            if let err = err {
                SwiftyBeaver.error("Error writing document: \(err)")
            } else {
                SwiftyBeaver.info("Document successfully written!")
            }
        }
        
    }
    
    
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        
        let uid = Auth.auth().currentUser?.uid
        
        updateOnlineStatus(online: false, uid: (uid)!, completion: { (status) in
            if  status  {
                print("online status set to false")
            } else {
                print("problem updating status")
            }
        })
       
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            UserDefaults.standard.removeObject(forKey: userImage)
            
            completion(true)
        } catch _ {
            print("error logging out")
            completion(false)
        }
    }
    
    static func generateUserData() -> [User] {
        
        
        let user1 = User();
        user1.firstName = "Neil"
        user1.lastName = "Baron"
        user1.email = "test@test.com"
        user1.id = "jz2ZSMto3UUxKy1yLEcXY5Y3Agu2"
        user1.online = true
        user1.profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/taskivate.appspot.com/o/usersProfilePics%2FOH4k0h26wJZ8fDgCQPUxjkBCHMp2?alt=media&token=1d60b501-52cd-4bad-a6fd-c01b7f70ca21"
        
        let user2 = User();
        user2.firstName = "Christin"
        user2.lastName = "Smrtka Baron"
        user2.id = "k2srX63kJUhQOuw7RxruI83ROOw2"
        user2.email = "test@test2.com"
        user2.profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/taskivate.appspot.com/o/usersProfilePics%2Fk2srX63kJUhQOuw7RxruI83ROOw2?alt=media&token=f3c0a9f2-5487-4c6e-8701-8a5053d82f18"
        let user3 = User();
        user3.firstName = "Avery"
        user3.lastName = "Baron"
        user3.id = "nnfHkZCEOSaQveTGKARKr8Bl4kIj2"
        user3.email = "user@user.com"
       
        user3.profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/taskivate.appspot.com/o/usersProfilePics%2Fjz2ZSMto3UUxKy1yLEcXY5Y3Agu2?alt=media&token=397e0d2e-8a51-461c-8742-4221af513b68"
        let user4 = User();
        user4.firstName = "Avery"
        user4.lastName = "Baron"
        user4.id = "v3hSvkzEYhUGftptWX5I7TDpx4S2"
        user4.email = "neilcb71@hotmail.com"
        
        return [
            user1,user2,user3,user4
        ]
    }
    
    

}
