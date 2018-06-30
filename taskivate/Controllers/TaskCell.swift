//
//  TaskCell.swift
//  taskivate
//
//  Created by Neil Baron on 6/29/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit


struct Task {
    let description: String
    let details: String
}

class TaskCell: BaseCell<Task> {
    
    override var item: Task! {
        didSet {
            textLabel?.text = item.description
            detailTextLabel?.text = item.details
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // backgroundColor = UIColor.red
        //SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 16, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 16, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
