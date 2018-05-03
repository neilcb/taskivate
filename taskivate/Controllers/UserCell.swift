//
//  UserCell.swift
//  taskivate
//
//  Created by Neil Baron on 4/27/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
class UserCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
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
        //imageView.layer.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImage: UIImage = {
        var image = UIImage()
        
        return image
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        // nameLabel.text = "User Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    
    
    
    
    @objc func addUserImageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            SwiftyBeaver.info("Add User - Invite")
            
        }
    }

}
