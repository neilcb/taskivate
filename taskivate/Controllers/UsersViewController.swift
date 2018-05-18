//
//  UserSearchViewController.swift
//  taskivate
//
//  Created by Neil Baron on 4/21/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import Foundation
import SwiftyBeaver
import Firebase

class UsersViewController: UITableViewController {
    var db: Firestore!
    var selectedIndexPath = IndexPath()
    var addUserFlagged = true
   
    fileprivate let searchButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    var users = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        users = UserAPI.generateUserData()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        setupSearchButtonItem()
      
       // navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
        navigationItem.title = "Users"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(r: 67, g: 133, b: 203)
      
     
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell

        self.selectedIndexPath = indexPath

        if(!users.isEmpty && users.indices.contains(indexPath.row)) {

            let user = users[indexPath.row]
            cell.textLabel?.text = user.firstName + " " + user.lastName
            cell.detailTextLabel?.text = user.email

            if let profileImageUrl = user.profileImageUrl {
                cell.profileImageView.loadImageUserCacheWithUrlString(urlString: profileImageUrl)
            }

            var frontimg = UIImage(named: "offline-circle-filled-20") // The image in the foreground

            if (user.online) {
                frontimg = UIImage(named:"filled-circle-20")
            }

            let frontimgview = UIImageView(image: frontimg) // Create the view holding the image
            frontimgview.frame = CGRect(x: 32, y: 42, width: 16, height: 16) // The size and position of the front image

            cell.addSubview(frontimgview)



        }



        return cell
    }

    func addUserButton() -> UIButton {
        
        let addUserButton = UIButton(type: .custom)
        addUserButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addUserButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
        addUserButton.setImage(UIImage(named: "add-user-blk"), for: .normal)
        addUserButton.contentMode = .scaleAspectFit
        addUserButton.setTitle("add", for: .normal)
        return addUserButton
        
    }
    
    func cancelUserButton() -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
        button.setImage(UIImage(named: "cancel-user-30"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.setTitle("canx", for: .normal)
        return button
        
    }
    
    @objc func accessoryButtonTapped(sender : UIButton){
        
       
        
        if let text = sender.titleLabel?.text {
            switch text {
            case "add":
                SwiftyBeaver.info("Add user tapped at \(sender.tag)")
                self.addUserFlagged = false
            case "canx":
                SwiftyBeaver.info("Canx user tapped at \(sender.tag)")
                self.addUserFlagged = true
            default:
                SwiftyBeaver.warning("default not expected")
                self.addUserFlagged = true
            }
        }
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
       SwiftyBeaver.info("accessbutton taped \(indexPath.row)")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SwiftyBeaver.info("index path \(indexPath)")
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let editAction = self.contextualEditAction(forRowAtIndexPath: indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let user = users[indexPath.row]
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            self.users.remove(at: indexPath.row)
                                            
                                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                            SwiftyBeaver.info("deleting \(user.firstName)")
                                            completionHandler(true)
        }
        
        action.backgroundColor = UIColor.red
        return action
    }
    
    func contextualEditAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let user = users[indexPath.row]
        
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            
                                            SwiftyBeaver.info("editing \(user.firstName)")
                                            completionHandler(true)
        }
        
        action.backgroundColor = UIColor.gray
        return action
    }
    
    func setupSearchButtonItem() {
        SwiftyBeaver.info("setting up add user button")
        navigationItem.rightBarButtonItem = self.searchButton
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.title = NSLocalizedString("Search", comment: "Label search button.")
        navigationItem.rightBarButtonItem?.image = UIImage(named: "search-30")
        navigationItem.rightBarButtonItem!.action = #selector(rightNavItemTapped(recognizer:))
        
    }
    
    
    @objc func rightNavItemTapped(recognizer: UIGestureRecognizer) {
        SwiftyBeaver.info("search  user")
        let searchUserViewController =  UserSearchViewController()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController!.pushViewController(searchUserViewController, animated: true)
    }
    
   
    

}


    




