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
           // "subcategory": task.subCategory!,
            "dueDate": task.dueDate,
            "priority": task.priority.rawValue,
            "repeats": task.repeats.rawValue,
            "reminder": task.reminder.rawValue,
            "status": task.status.rawValue
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false,err)
            } else {
                print("Document successfully written!")
                completion(true,nil)
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
    
    class func fetchTasksByDate(uid: String?, startDate: Date, endDate:Date, completion: @escaping ([Task], Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        var tasks = [Task]()
        
        if uid == nil {
            // get form current user Auth.auth
        }
       
        let query = db.collection("users").document(uid!).collection("tasks").order(by: "dueDate", descending: false).whereField("dueDate", isGreaterThan: startDate).whereField("dueDate", isLessThan: endDate)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completion([Task](),err)
            } else {
                for document in (querySnapshot?.documents)! {
                    SwiftyBeaver.info(document.data())
                    var task = Task()
                    task = task.mapTask(dictionary: document.data())
                    tasks.append(task)
                }
                completion(tasks,nil)
            }
               
        })
    }
    
    
   
   
}
