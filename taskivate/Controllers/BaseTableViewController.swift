//
//  BaseTableViewController.swift
//  taskivate
//
//  Created by Neil Baron on 6/29/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import SwiftyBeaver

class BaseTableViewController<T: BaseCell<C>, C>: UITableViewController {

    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    let cellId = "cellId"
    var items = [C]()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.frame = CGRect(x:0.0,y:0.0, width:32,height:32.0)
        
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
        
        setUpProfileImage()
        
        tableView.register(T.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseCell<C>
        cell.item = self.items[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
