//
//  LogoutUtils.swift
//  taskivate
//
//  Created by Neil Baron on 2/23/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI


class LogoutUtils {
    
    
    
    static func signOut() {
        
        do {
            try Auth.auth().signOut()
            print("signing out")
        } catch  {
            print("problem signing out")
        }
    }
    
}
