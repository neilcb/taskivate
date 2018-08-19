//
//  TestCollectionViewController.swift
//  taskivate
//
//  Created by Neil Baron on 7/10/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver


private let reuseIdentifier = "cellId"
private let headerId = "dashboardHeaderId"
private let taskHeadderId = "taskHeaderId"

class DashbaordCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var customElements: [CustomElementModel]!
    var sizeForItems: [CGSize]!
    var today = Date()
    var tasksCompleted = 0
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.frame = CGRect(x:8.0,y:8.0, width:40,height:40.0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        
        return imageView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        let width = view.frame.width
        setUpProfileImage()
        customElements = [
            //SectionHeaderElement(sectionTitle: "DASHBOARD", size: .init(width: width, height: 30)),
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
        

        collectionView?.backgroundColor = UIColor.white
        
        

        
      
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setUpProfileImage()
    }
    
    // todo make this work in an extension or subclass it
    func setUpProfileImage() {
        
        let widthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 40)

        heightConstraint.isActive = true
        widthConstraint.isActive = true

        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25

        let imageItem = UIBarButtonItem.init(customView: profileImageView)

        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTaped(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        profileImageView.addGestureRecognizer(singleTap)

        navigationItem.leftBarButtonItems =  [negativeSpacer,imageItem]

        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }


    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func profileImageTaped(recognizer: UIGestureRecognizer) {
        print("image clicked")
        SwiftyBeaver.info("profile image selected/tapped")
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let userProfileController = UserProfileController()
        userProfileController.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        self.navigationItem.backBarButtonItem = backItem
        
        if let id = Auth.auth().currentUser?.uid {
            UserAPI.fetchUserToDisplay(uid: id, completionHandler: { (user, error) in
                if let error = error {
                    print(error)
                    UIViewController.removeSpinner(spinner: sv)
                    let alert = UIAlertController(title: "Error finding user", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                } else {
                    UIViewController.removeSpinner(spinner: sv)
                    userProfileController.user = user!
                    //userProfileController.supportedInterfaceOrientations = .portrait
                    self.navigationItem.backBarButtonItem = backItem
                    self.navigationController?.pushViewController(userProfileController, animated: false)
                }

            })
        }
        
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
    var circularPath: UIBezierPath!
    var tasksCompleted = 0
    let shapeLayer: CAShapeLayer = {
        let sl = CAShapeLayer()
        
        sl.strokeColor = UIColor.red.cgColor
        sl.lineWidth = 5
        sl.fillColor = UIColor.clear.cgColor
        sl.lineCap = kCALineCapRound
        sl.strokeEnd = 0
        
        return sl
    }()
    
    let trackLayer: CAShapeLayer = {
        let tl = CAShapeLayer()
        tl.strokeColor = UIColor.lightGray.cgColor
        tl.lineWidth = 5
        tl.fillColor = UIColor.clear.cgColor
        tl.lineCap = kCALineCapRound
        return tl
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.center = CGPoint(x: 160, y: 285)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textAlignment = .center
        return label
    }()
    
    
    let tasksLabel: UILabel = {
        let label = UILabel()
        //label.text = "0 Tasks"
        
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
        SwiftyBeaver.info("init")
        super.init(frame: frame)
        setUpViews()
    }
    
    override func didAddSubview(_ subview: UIView) {
        SwiftyBeaver.info("did add subviews")
        
        let center = CGPoint(x: self.frame.width / 2, y: 150)
        circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.position = center
        trackLayer.position = center
      
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        SwiftyBeaver.info("width \(self.frame.width / 2))")
        
        SwiftyBeaver.info("width \(self.center.x))")
        
        
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
    
        backgroundColor = UIColor.white
        addSubview(dateLabel)
        addSubview(percentageLabel)
       
        dateLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.frame.width, height: 50))
      
        percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        percentageLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.frame.width, height: 50))
        self.layer.addSublayer(trackLayer)
       
        
       
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
        
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
      
    }
    
    @objc func handleTap() {
        print("Attempting to animate stroke")
        calculateTasks()
        //animateCircle()
        
    }
    
    func configureUI() {
        
        dateLabel.text = "Today"
        calculateTasks()
    }
    
    
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
    func calculateTasks() {
        let totalTasks = 100
        tasksCompleted = 75
      
       
        SwiftyBeaver.info("tasks completed \(tasksCompleted)")
        let percentage = CGFloat(tasksCompleted) / CGFloat(totalTasks)
        
       
        DispatchQueue.main.async {
            if(percentage >= 0.50 && percentage < 1.0) {
                self.shapeLayer.strokeColor = UIColor.orange.cgColor
            } else if(percentage >= 1.0) {
                self.shapeLayer.strokeColor = UIColor.green.cgColor
            }
            self.percentageLabel.text = "\(Int(percentage*100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        SwiftyBeaver.info("Percentage \(percentage)")
    }
}

//class TaskInfoElement: CustomElementModel {
//    var size: CGSize?
//    //var image: UIImage?
//    var taskName: String
//    var taskDescription: String
//    var taskDueDate: Date
//    
//    var type: CustomElementType { return .task }
//    
//    init(taskName: String, taskDescription: String, taskDueDate: Date, size: CGSize = .zero) {
//        self.taskName = taskName
//        self.taskDescription = taskDescription
//        self.taskDueDate = taskDueDate
//        self.size = size
//        
//    }
//    
//}

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
        nameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: containerView.frame.width, height: 50))
        
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
        sectionLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 200, height: 30))
    }
    
    func configureUI() {
        self.backgroundColor = .lightGray
        self.sectionLabel.text = model.sectionTitle
       
    }
    
    
    
    
}
