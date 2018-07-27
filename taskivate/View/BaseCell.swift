//
//  BaseCell.swift
//  taskivate
//
//  Created by Neil Baron on 6/30/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class BaseCell<U>: UITableViewCell {
    
    var item: U!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
