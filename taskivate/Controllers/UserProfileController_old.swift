//
//  UserProfileController.swift
//  taskivate
//
//  Created by Neil Baron on 5/23/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver
import Eureka

class UserProfileController_old: UIViewController {
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
   
    
    
    let metrics = [
        "horizontalPadding": Metrics.padding,
        "iconImageViewWidth": Metrics.iconImageViewWidth]
    
    var allConstraints: [NSLayoutConstraint] = []
    
   
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "compact-camera-30")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        tf.leftView = paddingView
        tf.leftViewMode = UITextFieldViewMode.always
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1.0
        tf.placeholder = "First Name"
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        tf.leftView = paddingView
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1.0
        tf.placeholder = "Last Name"
        tf.layer.cornerRadius = 10
       
        
        tf.leftViewMode = UITextFieldViewMode.always
        return tf
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle("Save", for: .normal)
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Me"
        
        setupViews()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // handleOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    

    private func setupViews() {
   

        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
            let newImage = resizeImage(image: self.profileImageView.image!, targetSize: CGSize(width: 150, height: 150))
            self.profileImageView.image = newImage
        }
        
      
        view.addSubview(profileImageView)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(saveButton)
        view.addSubview(editImageView)
      
        
        profileImageView.layer.cornerRadius = 75
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        
        
        editImageView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        editImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        
        
        firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 8).isActive = true
        lastNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 8).isActive = true
        saveButton.layer.cornerRadius = 10
        saveButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width

        var newSize: CGSize

        newSize = CGSize(width: size.width * widthRatio,  height: size.width * widthRatio)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
  

}

private enum Metrics {
    static let padding: CGFloat = 15.0
    static let iconImageViewWidth: CGFloat = 30.0
}
