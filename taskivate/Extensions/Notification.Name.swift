//
//  Notification.Name.swift
//  taskivate
//
//  Created by Neil Baron on 4/15/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import UIKit
extension Notification.Name {
    static let setParentId = Notification.Name("parentId")
    static let deleteTaskNotification = Notification.Name("delete Task")
    static let savedTaskNotification = Notification.Name("save Task")
    
}
