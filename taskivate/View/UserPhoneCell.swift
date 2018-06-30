//
//  UserInfoCell.swift
//  taskivate
//
//  Created by Neil Baron on 6/10/18.
//  Copyright © 2018 taskivate. All rights reserved.
//
import Eureka
import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver
import PhoneNumberKit

final class UserPhoneCell: Cell<String>, CellType, UINavigationControllerDelegate {
    
    var phoneTextField = PhoneNumberTextField()
    
    
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 16, y: (detailTextLabel?.frame.origin.y)! + 12, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.layer.borderColor = UIColor.red.cgColor
        textLabel?.layer.borderWidth = 3
        
        phoneTextField.frame = CGRect(x: 0, y: (phoneTextField.frame.origin.y) + 12, width: 40, height: 40)
        
       // detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 12, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = true
        phoneTextField.layer.borderWidth = 3
        phoneTextField.layer.borderColor = UIColor.blue.cgColor
        phoneTextField.isEnabled = true
        phoneTextField.isEnabled = false
        addSubview(phoneTextField)
        phoneTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        phoneTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
   
    
    
}

final class UserPhoneRow: Row<UserPhoneCell>, RowType {
    
    
    required init(tag: String?) {
        super.init(tag: tag)
        
    }
}
