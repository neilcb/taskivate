//
//  SettingsViewController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseAuth
import Firebase
import FirebaseAuthUI

class SettingsViewController: UITableViewController {
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth?
    private var collectionViewSizeChanged: Bool = false
    private let margin: CGFloat = 20.0
    var pageControl = UIPageControl.init()
    
    var userOptions = [AccountAction.changeEmail.rawValue,AccountAction.changePassword.rawValue,AccountAction.signOut.rawValue]
   
    var currentOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifer)
        self.tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        let footerView = UIView()
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.backgroundColor = UIColor.clear
        
        currentOptions = userOptions
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
        
    }()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionViewSizeChanged = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if collectionViewSizeChanged {
            SwiftyBeaver.info("collectin view sized changed")
            menuBar.collectionView.collectionViewLayout.invalidateLayout()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOptions.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if collectionViewSizeChanged {
            collectionViewSizeChanged = false
            menuBar.collectionView.performBatchUpdates({}, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifer, for: indexPath) as! SettingsCell

        cell.textLabel?.text = currentOptions[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAction = currentOptions[indexPath.row]
        
        SwiftyBeaver.info(selectedAction)
        
        switch selectedAction {
        case AccountAction.signOut.rawValue:
            UserAPI.logOutUser(completion: {(status) in
                if status != true {
                    print("sign out failed!  This should not happen")
                }
            })
        default:
            SwiftyBeaver.info(selectedAction)
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.reuseIdentifer) as? CustomHeader else {
            return nil
        }

        header.addSubview(menuBar)
        header.bringSubview(toFront: menuBar)
        header.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        
        let views: [String: Any] = [
            "menuBar": menuBar]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        // 3
        let acctBtnVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[menuBar(50)]",
            metrics: nil,
            views: views)
        allConstraints += acctBtnVerticalConstraints
        
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[menuBar(750@50)]|",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
        return header



    }
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
   

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

}

class SettingsCell: UITableViewCell {
    
     static let reuseIdentifer = "SettingsReuseIdentifier"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SwiftyBeaver.info("layout sub views")
        textLabel?.frame = CGRect(x: 16, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 16, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
      
        //menuBar.addSubview(helpButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomHeader : UITableViewHeaderFooterView {
    
    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(r: 67, g: 133, b: 203)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}

class SettingsNavButton: UIButton {
    fileprivate var titleColorNormal: UIColor = .white
    fileprivate var titleColorHighlighted: UIColor = .black
    fileprivate var backgroundColorNormal: UIColor = .clear
    fileprivate var backgroundColorHighlighted: UIColor = .white
    override var isHighlighted: Bool {
        willSet(newValue){
            if newValue {
                self.setTitleColor(titleColorHighlighted, for: state)
                self.backgroundColor = backgroundColorHighlighted
            }else {
                self.setTitleColor(titleColorNormal, for: state)
                self.backgroundColor = backgroundColorNormal
            }
        }
    }
    
    
        
}
