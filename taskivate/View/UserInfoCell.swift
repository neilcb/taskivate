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

final class UserInfoCell: Cell<User>, CellType, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var userImageView: UIImageView!
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var dateLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var newImage = UIImage()
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)! - 12, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 12, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imagePicker.delegate = self
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func setup() {
        super.setup()
        
        selectionStyle = .default
        
        
        
        // specify the desired height for our cell
        height = { return 94 }
        
        // set a light background color for our cell
        backgroundColor = UIColor(r: 67, g: 133, b: 203)
    }
    
    override func update() {
        super.update()
        
        SwiftyBeaver.info("update called")
        guard let user = row.value else { return }
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            user.profileImageUrl = profileImageUrl.absoluteString
        }
        
        // set the image to the userImageView. You might want to do this with AlamofireImage or another similar framework in a real project
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl)
        }
        
        textLabel?.text = user.firstName + " " + user.lastName
        detailTextLabel?.text = user.email
        
    }
    
   
    
    
}

final class UserInfoRow: Row<UserInfoCell>, RowType {
    
    
    required init(tag: String?) {
        super.init(tag: tag)
        
    }
}
