//
//  ViewController.swift
//  taskivate
//
//  Created by Neil Baron on 2/10/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
//    class func addSettingsIcon(image: UIImage) -> UIImageView {
//        
//        let logoImage = image
//        let iconImageView = UIImageView.init(image: logoImage)
//        iconImageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40.0)
//        iconImageView.contentMode = .scaleAspectFit
//        let imageItem = UIBarButtonItem.init(customView: iconImageView)
//        
//        iconImageView.isUserInteractionEnabled = true
//        
//        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsItemTapped(recognizer:)))
//        singleTap.numberOfTapsRequired = 1;
//        iconImageView.addGestureRecognizer(singleTap)
//        
//        
//        
//        let widthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 40)
//        let heightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 40)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        negativeSpacer.width = 25
//        
//        imageItem.target = self
//        
//        return iconImageView
//        
//    }
    
//    @objc func settingsItemTapped(recognizer: UIGestureRecognizer) {
//        print("right nav tapped")
//        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
//        //settingViewController.uiImageView.image = self.image
//
//        let backItem = UIBarButtonItem()
//        backItem.title = "Back"
//        self.navigationItem.backBarButtonItem = backItem
//        self.navigationController!.pushViewController(settingViewController, animated: true)
//    }
    
    
    
    
}
