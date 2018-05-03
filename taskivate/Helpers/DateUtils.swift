//
//  DateUtils.swift
//  taskivate
//
//  Created by Neil Baron on 3/20/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class DateUtils: NSObject {
    // get current date 
    static func getCurrentTimestamp() -> NSDate {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        return time
    }
    
    // something here

}
