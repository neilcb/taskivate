//
//  BaseCollectionViewCell.swift
//  taskivate
//
//  Created by Neil Baron on 7/2/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class BaseCollectionViewCell<U>: UICollectionViewCell {
    
   var item: U!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
