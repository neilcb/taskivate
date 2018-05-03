//
//  UserError.swift
//  taskivate
//
//  Created by Neil Baron on 3/5/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
public struct UserError: Error {
    let msg: String
    
}

extension UserError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}
