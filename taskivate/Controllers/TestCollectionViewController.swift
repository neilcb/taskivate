//
//  TestCollectionViewController.swift
//  taskivate
//
//  Created by Neil Baron on 7/10/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver

private let reuseIdentifier = "cellId"
private let headerId = "dashboardHeaderId"
private let taskHeadderId = "taskHeaderId"

class DashbaordCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var customElements: [CustomElementModel]!
    var sizeForItems: [CGSize]!
    var today = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.width
        
        customElements = [
            SectionHeaderElement(sectionTitle: "DASHBOARD", size: .init(width: width, height: 30)),
            DashBoardElement(image: #imageLiteral(resourceName: "list-2"), completedTasks: 10, remainingTaks: 10, totalTasks: 10, size: .init(width: width, height: 300)),
            SectionHeaderElement(sectionTitle: "TASKS", size: .init(width: width, height: 30)),
            TaskInfoElement(taskName: "throw out trash", taskDescription: "do it", taskDueDate: Date(), size: .init(width: width, height: 200)),
            TaskInfoElement(taskName: "blah", taskDescription: "do it", taskDueDate: Date(),size: .init(width: width, height: 200)),
            
            TaskInfoElement(taskName: "blah", taskDescription: "do it", taskDueDate: Date(),size: .init(width: width, height: 200))
           
        ]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        self.collectionView!.register(DashboardElementCell.self, forCellWithReuseIdentifier: CustomElementType.dashboard.rawValue)
        
        self.collectionView!.register(TaskElementCell.self, forCellWithReuseIdentifier: CustomElementType.task.rawValue)
        
        self.collectionView!.register(SectionElementCell.self, forCellWithReuseIdentifier: CustomElementType.section.rawValue)
     
        self.collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
         //collectionView?.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        collectionView?.backgroundColor = UIColor.white
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return customElements.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellModel = customElements[indexPath.row]
        let cellIdentifier = cellModel.type.rawValue
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomElementCell
        
        customCell.configure(withModel: cellModel)
        
        return customCell as! UICollectionViewCell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        SwiftyBeaver.info(customElements[indexPath.row].type.rawValue)
        SwiftyBeaver.info(customElements[indexPath.row].size!)
        return customElements[indexPath.row].size!

        //        if(indexPath.item == 0) {
//            return CGSize(width: view.frame.width, height: 400)
//        }
       
       // return CGSize(width: view.frame.width, height: 200)
        
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
//
//        if(indexPath.item == 0) {
//
//        }
//        header.backgroundColor = .red
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//         return CGSize(width: view.frame.width, height: 50)
//    }
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

enum CustomElementType: String {
    case dashboard
    case task
    case message
    case image
    case section
    
}

protocol CustomElementModel: class {
    
    var type: CustomElementType { get }
    var size: CGSize?{ get set}
    
}



protocol CustomElementCell: class {
    
    func configure(withModel: CustomElementModel)
    
}

class DashBoardElement: CustomElementModel {
    var size: CGSize?
    
    
    
    //var image: UIImage?
    var compeletedTasks: Int
    var remainingTasks: Int
    var totalTasks: Int
    var type: CustomElementType { return .dashboard }
    
    init(image: UIImage?, completedTasks: Int, remainingTaks: Int, totalTasks: Int, size: CGSize = .zero) {
        //self.image = image
      
        
        self.compeletedTasks = completedTasks
        self.remainingTasks = remainingTaks
        self.totalTasks = totalTasks
        self.size = size
       
        
        
        
        
    }
}

class DashboardElementCell: UICollectionViewCell, CustomElementCell {
    
    
    var model: DashBoardElement!
    

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
       
        return label
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? DashBoardElement else {
            print("Unable to cast model as DashbaordElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = UIColor.white
        
        
        addSubview(containerView)
        containerView.addSubview(nameLabel)
       
        containerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        nameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        
        //
    }
    
    
    
    func configureUI() {
       nameLabel.text = String(model.compeletedTasks)
    }
}

class TaskInfoElement: CustomElementModel {
    var size: CGSize?
    //var image: UIImage?
    var taskName: String
    var taskDescription: String
    var taskDueDate: Date
    
    var type: CustomElementType { return .task }
    
    init(taskName: String, taskDescription: String, taskDueDate: Date, size: CGSize = .zero) {
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.taskDueDate = taskDueDate
        self.size = size
        
    }
    
}

class TaskElementCell: UICollectionViewCell, CustomElementCell {
   
    var model: TaskInfoElement!
    
   
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        
        return label
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.white
        //cv.layer.borderColor = UIColor.lightGray.cgColor
        //cv.layer.borderWidth = 2
        return cv
    }()
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? TaskInfoElement else {
            print("Unable to cast model as DashbaordElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        addSubview(containerView)
        containerView.addSubview(nameLabel)

        containerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        nameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        
        //
    }
    
    func configureUI() {
        nameLabel.text = model.taskName
    }
    
    
}

class SectionHeaderElement: CustomElementModel {
    var size: CGSize?
    var sectionTitle = ""
    var type: CustomElementType { return .section }
    
    init(sectionTitle: String, size: CGSize = .zero) {
        self.sectionTitle = sectionTitle
        self.size = size
    }
}

class SectionElementCell: UICollectionViewCell, CustomElementCell {
   
    
   
    var model: SectionHeaderElement!
    
    
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue", size: 12)!
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? SectionHeaderElement else {
            print("Unable to cast model as DashbaordElement: \(elementModel)")
            return
        }
        
        self.model = model
        configureUI()
    }
    
    func setupViews() {
        addSubview(sectionLabel)
        sectionLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 150, height: 30))
    }
    
    func configureUI() {
        self.backgroundColor = .lightGray
        self.sectionLabel.text = model.sectionTitle
       
    }
    
    
    
    
}
