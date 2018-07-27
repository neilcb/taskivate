//
//  DashboardController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver

class DashboardController: BaseViewController {
    
    
    
    
    
    var titleText = "Hello"
    
  

    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    var db: Firestore!
    
    var circularPath: UIBezierPath!
    
    let shapeLayer: CAShapeLayer = {
        let sl = CAShapeLayer()
        
        sl.strokeColor = UIColor.red.cgColor
        sl.lineWidth = 10
        sl.fillColor = UIColor.clear.cgColor
        sl.lineCap = kCALineCapRound
        sl.strokeEnd = 0
       
        return sl
    }()
    
    let trackLayer: CAShapeLayer = {
        let tl = CAShapeLayer()
        tl.strokeColor = UIColor.lightGray.cgColor
        tl.lineWidth = 10
        tl.fillColor = UIColor.clear.cgColor
        tl.lineCap = kCALineCapRound
        return tl
    }()
    
    let topView: UIView = {
        let tv = UIView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
        
    }()
    
    let centerView: UIView = {
        let tv = UIView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.yellow
        return tv
    }()
    
    let bottomView: UIView = {
        let tv = UIView()
        tv.translatesAutoresizingMaskIntoConstraints = false
       
        return tv
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.center = CGPoint(x: 160, y: 285)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
   
    
    override func viewDidLayoutSubviews() {
       // self.shapeLayer.frame = self.bottomView.bounds
       
        let center = CGPoint(x: bottomView.frame.width / 2, y: 150)
        circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        trackLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath

        shapeLayer.position = center
        trackLayer.position = center
        //shapeLayer.position = center
        //trackLayer.position = center

        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        SwiftyBeaver.info("width \(bottomView.frame.width / 2))")

        SwiftyBeaver.info("width \(self.view.center.x))")
        percentageLabel.frame = CGRect(x: bottomView.center.x ,y: 200, width: 100, height: 100)
        percentageLabel.center = center

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = titleText
        checkIfUserIsLoggedIn()
        setUpDisplayName()
      //  setUpCollectionView()
        setUpViews()
        

    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDisplayName()
        setUpProfileImage()
        
    }
    
    
    func setUpViews() {
       
       
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        view.addSubview(percentageLabel)
        percentageLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        percentageLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 135).isActive = true
        //percentageLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
       
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        bottomView.backgroundColor = UIColor.cyan
        
      
        bottomView.layer.addSublayer(trackLayer)
        
        shapeLayer.frame = bottomView.bounds
        trackLayer.frame = bottomView.bounds
      
        bottomView.layer.addSublayer(shapeLayer)
        
        
        shapeLayer.position = bottomView.center
        trackLayer.position = bottomView.center
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

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
        let totalTasks = 10
        let tasksCompleted = 10
     //   let remaining = totalTasks - tasksCompleted
        
        let percentage = CGFloat(tasksCompleted) / CGFloat(totalTasks)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage*100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        SwiftyBeaver.info("Percentage \(percentage)")
    }
    
    @objc func handleTap() {
        print("Attempting to animate stroke")
        calculateTasks()
        //animateCircle()
   
    }
    
    
    func checkIfUserIsLoggedIn() {
        SwiftyBeaver.info("checking valid user")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                SwiftyBeaver.info("user is logged \(user?.uid ?? "none for user")")
            } else {
                SwiftyBeaver.info("user is not logged in giong to login controller")
                let loginController = HomeViewController()
                self.navigationController?.pushViewController(loginController, animated: true)
            }
        }
    }
    
    func setUpDisplayName() {
        if let user = Auth.auth().currentUser {
            if(!(user.displayName?.isEmpty)!) {
                var stringArr = user.displayName?.components(separatedBy: " ")
                self.navigationItem.title = "Hello \(stringArr![0])"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayUserInfo() {
       
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }
            
       
    }
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





