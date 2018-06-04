//
//  MenuBar.swift
//  taskivate
//
//  Created by Neil Baron on 5/5/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var collectionViewSizeChanged: Bool = false
   
    private let margin: CGFloat = 2.0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0.0, right: margin)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.layer.borderColor = UIColor.black.cgColor
        cv.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        // need to set this to false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["customer-hl-30","privacy-30","about-30"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
       
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        let views: [String: Any] = [
            "collectionView": collectionView]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        
        let acctBtnVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[collectionView]|",
            metrics: nil,
            views: views)
        allConstraints += acctBtnVerticalConstraints
        
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
           // options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tag = indexPath.item
        cell.tintColor = UIColor(r: 2, g: 24, b: 39)
      //  cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
//        <#code#>
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .yellow
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "customer-hl-30")?.withRenderingMode(.alwaysTemplate)
        //iv.layer.borderColor = UIColor.black.cgColor
        //iv.layer.borderWidth = 2
       
        return iv
    }()
    
    private func setupViews() {
        
        self.layer.borderColor = UIColor.white.cgColor
        addSubview(imageView)
        let views: [String: Any] = [
            "imageView": imageView]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        // 3
        let acctBtnVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[imageView]",
            metrics: nil,
            views: views)
        allConstraints += acctBtnVerticalConstraints
        
        
//        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
//            withVisualFormat: "H:|-[imageView(28)]-|",
//            options: [.alignAllCenterY],
//            metrics: nil,
//            views: views)
//        allConstraints += topRowHorizontalConstraints
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[imageView]-|",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
       
        
        NSLayoutConstraint.activate(allConstraints)
        
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor(r: 2, g: 24, b: 39)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor(r: 2, g: 24, b: 39)
            if(isSelected) {
                print("image view selected \(imageView.tag)")
            }
            
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
