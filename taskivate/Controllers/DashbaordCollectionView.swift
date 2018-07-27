//
//  CollectionViewController.swift
//  taskivate
//
//  Created by Neil Baron on 7/7/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DashbaordCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    var items: [DashBaord] = [
        DashBaord(totalTasks: 6, completedTasks: 3, taskName: "walk"),
        DashBaord(totalTasks: 12, completedTasks: 12, taskName: "run")
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        
        // Register cell classes
        self.collectionView!.register(DashBoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DashBoardCell

        let item = items[indexPath.row]
        customCell.displayData(dasboardInfo: item)

        return customCell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
struct DashBaord {
    let totalTasks : Int?
    let completedTasks: Int?
    let taskName: String?
    
}
class DashBoardCell: UICollectionViewCell  {
    
    let cellId = "cellId"
    
    var items: [DashBaord] = [
        DashBaord(totalTasks: 6, completedTasks: 3, taskName: "walk"),
        DashBaord(totalTasks: 12, completedTasks: 12, taskName: "run")
   
    ]
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        
        label.numberOfLines = 2
        return label
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.red
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = items[indexPath.row]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DashBoardCell
//
//        cell.displayData(dasboardInfo: item)
//        return cell
//
//    }
    
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayData(dasboardInfo: DashBaord) {
        if let completed = dasboardInfo.completedTasks {
            nameLabel.text = String(completed)
        }
    }
    
    
    
    func setUpViews() {
        //backgroundColor = UIColor.red
        
       
         addSubview(containerView)
         containerView.addSubview(nameLabel)
//        collectionView.fillSuperview()
         containerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
         nameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 100, height: 50))

//
    }
    
}

protocol ListItem {
    var isDashboardItem: Bool {get}
    var isTaskItem: Bool {get}
    var isTextItem: Bool {get}
    var isImageItem: Bool {get}
    var isAdItem: Bool {get}
}
