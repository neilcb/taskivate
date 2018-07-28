//
//  TaskAPI.swift
//  taskivate
//
//  Created by Neil Baron on 7/26/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

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

class TaskAPI: NSObject {
    
    static let sharedInstance = TaskAPI()
    static let userImage = "userImageKey"
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    override init() {
        
    }
    
    class func save(uid: String, task: Task, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        // user first name and last concat as display (for search)
        var cat = ""
        if let category = task.category {
            cat = category.rawValue
        }
        // get display name if available
        db.collection("users").document(uid).collection("tasks").document().setData([
            "title": task.title!,
            "category": cat,
            "subcategory": task.subCategory!,
            "dueDate": task.dueDate,
            "repeats": task.repeats.rawValue,
            "reminder": task.reminder.rawValue,
            "status": task.status.rawValue
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    class func delete(uid: String?, task: Task, completion: @escaping (Bool, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        
    
        
        db.collection("users").document(uid!).collection("tasks").document().delete{ err in
            if let err = err {
                SwiftyBeaver.error("Error removing document: \(err)")
                completion(false,err)
            } else {
                SwiftyBeaver.error("Document successfully removed!")
                completion(true,nil)
            }
        }
    }
}
