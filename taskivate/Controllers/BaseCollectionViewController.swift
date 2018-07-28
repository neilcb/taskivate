//
//  BaseCollectionViewController.swift
//  taskivate
//
//  Created by Neil Baron on 7/2/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver



class BaseCollectionViewController<T: BaseCollectionViewCell<C>, C>: UICollectionViewController {
    let cellId = "cellId"
    var items = [C]()
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.frame = CGRect(x:0.0,y:0.0, width:40,height:40.0)
        
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
        collectionView?.register(T.self, forCellWithReuseIdentifier: cellId)
        setUpProfileImage()
    }
    
    func setUpProfileImage() {
        
        let widthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 40)
        
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .done, target: nil, action: nil)
        negativeSpacer.width = 25
        
        let imageItem = UIBarButtonItem.init(customView: profileImageView)
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTaped(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        profileImageView.addGestureRecognizer(singleTap)
        
        navigationItem.leftBarButtonItem =  imageItem
        
        if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            self.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl.absoluteString)
        }
    }
    
    @objc func profileImageTaped(recognizer: UIGestureRecognizer) {
        print("image clicked")
        SwiftyBeaver.info("profile image selected/tapped")
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let userProfileController = UserProfileController()
        userProfileController.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseCollectionViewCell<C>
        
        cell.item = self.items[indexPath.row]
       

        // Configure the cell
    
        return cell
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
