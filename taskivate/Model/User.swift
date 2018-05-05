//
//  User.swift
//  taskivate
//
//  Created by Neil Baron on 3/3/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class User  {
    
    static let userSynchKey = "userSynchedOnLogin"
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
    var id: String = ""
    var age: Int = 0
    var online: Bool = false
    var profileImageUrl: String?
    
   
   

}

extension User {
    func mapUser(dictionary: [String: Any]) -> User {
        
        let mappedUser = User()
        
        guard let name = dictionary["firstName"] as? String else { return mappedUser }
        
        mappedUser.firstName = name
        
        guard let lastName = dictionary["lastName"] as? String else { return mappedUser }
        mappedUser.lastName = lastName
        
        if let profileImageUrl = (dictionary["profileImageUrl"]) {
            mappedUser.profileImageUrl = profileImageUrl as? String
        }
        
        if let email = (dictionary["email"]) {
            mappedUser.email = email as! String
        }
        
        if let ph = (dictionary["phone"]) {
            mappedUser.phone = ph as! String
        }
        
        if let age = (dictionary["age"]) {
            mappedUser.age =  age as! Int
        }
        
        mappedUser.online = (dictionary["online"] as? Bool)!
        
        return mappedUser
        
    }
}

