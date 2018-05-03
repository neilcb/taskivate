//
//  Constants.swift
//  taskivate
//
//  Created by Neil Baron on 2/25/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
