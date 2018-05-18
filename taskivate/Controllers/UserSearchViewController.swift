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

class UserSearchViewController: UITableViewController {
    var db: Firestore!
    var selectedIndexPath = IndexPath()
    var addUserFlagged = true
    
    var users = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        users = UserAPI.generateUserData()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
            navigationItem.title = "Users"
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            navigationController?.navigationBar.barTintColor = UIColor(r: 67, g: 133, b: 203)
            
            let searchController = UISearchController(searchResultsController: nil) // Search Controller
            
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.tintColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                    
                }
            }
            searchController.searchBar.backgroundColor = UIColor(r: 67, g: 133, b: 203)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Find Users"
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
            searchController.searchBar.tintColor = UIColor.white
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
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
            
            var cellButton = UIButton()
            if(addUserFlagged) {
                cellButton = addUserButton()
            } else {
                cellButton = cancelUserButton()
            }
            
            cellButton.tag = indexPath.row
            cell.accessoryView = cellButton as UIView
            
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
   
    

}

class UserSearchCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-filled-blue-50")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        
        //imageView.layer.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
      
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
      
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImage: UIImage = {
        var image = UIImage()
        
        return image
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
       // nameLabel.text = "User Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    @objc func addUserImageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            SwiftyBeaver.info("Add User - Invite")
            
        }
    }
}

extension UserSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
  
        let searchBar = searchController.searchBar
        SwiftyBeaver.info(searchBar.text!)
        
        self.users.removeAll()
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
      
        // Create a query against the collection. According to Firebase doc 'OR' statements should be
        // seperate queries.  This could use some further thought, regarding using range operator instead
        let fNameQuery = db.collection("users").whereField("firstName", isEqualTo: searchBar.text!)
        
        let lNameQuery =  db.collection("users").whereField("lastName", isEqualTo: searchBar.text!)
     
        let displayNameQuery = db.collection("users").whereField("displayName", isEqualTo: searchBar.text!)
    
        let emailQuery = db.collection("users").whereField("email", isEqualTo: searchBar.text!.lowercased())
       
        fNameQuery.getDocuments(completion: { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.handleDocumentsInQuery(snapshot: (querySnapshot?.documents)!)
            }
        })
        
        lNameQuery.getDocuments(completion: { (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.handleDocumentsInQuery(snapshot: (querySnapshot?.documents)!)
            }
        })
        
        
        displayNameQuery.getDocuments(completion: { (querySnapshot, err) in
    
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.handleDocumentsInQuery(snapshot: (querySnapshot?.documents)!)
            }
        })
        
        emailQuery.getDocuments(completion: { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.handleDocumentsInQuery(snapshot: (querySnapshot?.documents)!)
            }
        })
        
        // [END simple_queries]
       
        
    }
    /*
    
    */
    func handleDocumentsInQuery(snapshot: [QueryDocumentSnapshot]) {
        for document in snapshot {
            print("\(document.documentID) => \(document.data())")
            
            let user = User().mapUser(dictionary: document.data())
            user.id = document.documentID
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }

    }
}
