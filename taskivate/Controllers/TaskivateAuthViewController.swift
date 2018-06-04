//
//  TaskivateAuthViewController.swift
//  taskivate
//
//  Created by Neil Baron on 1/26/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI

class TaskivateAuthViewController : FUIAuthPickerViewController {
    
    let contententView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let uiImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        let image = #imageLiteral(resourceName: "white_logo_transparent")
        view.image = image
        
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        // button.setImage(#imageLiteral(resourceName: "ItunesArtwork-1"), for: .normal)
        //button.setImage(UIImage(named:"favicon"), for: .normal)
        
        //button.imageEdgeInsets = UIEdgeInsets(top: 0,left: -23,bottom: 6,right: 14)
      //  button.titleEdgeInsets = UIEdgeInsets(top: 0,left: -30,bottom: 0,right: 34)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 12.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
       
        return button
    }()
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        view.insertSubview(uiImageView, at: 0)
        view.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        view.autoresizesSubviews = true
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //view.addSubview(uiImageView)
        setUpImageContainterView()
     //   setUpLoginRegistrationButton()
        self.navigationItem.leftBarButtonItem = nil
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
       // self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
       // AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // reset when view is being removed
        //AppUtility.lockOrientation(.all)
    }
    
    func setUpImageContainterView() {
        
        let topImageContainerView = UIView()
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.backgroundColor = view.backgroundColor
        view.addSubview(topImageContainerView)
        
        topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        topImageContainerView.addSubview(uiImageView)
       
        uiImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        uiImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        uiImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.8).isActive = true
        
    }
    
    func setUpLoginRegistrationButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor,constant: 200).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
}


