//
//  SettingsViewController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
class SettingsViewController: UITableViewController {
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
      

    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func setUpMenuBar() {
        
        
       
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.reuseIdentifer) as? CustomHeader else {
            return nil
        }
        header.accountButton.addTarget(self, action: #selector(accountButtonTapped), for: UIControlEvents.touchUpInside)
        
        header.privButton.addTarget(self, action: #selector(accountButtonTapped), for: UIControlEvents.touchUpInside)
        
        header.backgroundColor = UIColor(r: 67, g: 133, b: 203)
       
        
        return header
        
     
        
    }
    
    
    @objc func accountButtonTapped(_ sender: AnyObject) {
        let button = sender as? UIButton
        
        if button?.isSelected == true {
            button?.isSelected = false
        }else {
            button?.isSelected = true
        }
        
       
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
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
      
        //menuBar.addSubview(helpButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomHeader : UITableViewHeaderFooterView {
   
    
    
    let accountButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("Account", for: .normal)
        btn.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        btn.setImage(UIImage(named : "customer-30"), for: UIControlState.normal)
        btn.setImage(UIImage(named : "customer-hl-30"), for: UIControlState.selected)
       
        btn.tag = 0
       
        return btn
    }()
    
    
    let privButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named : "customer-30"), for: UIControlState.normal)
        btn.setImage(UIImage(named : "customer-hl-30"), for: UIControlState.selected)
       
       // btn.backgroundColor = UIColor.clear
        btn.tag = 1
        
        return btn
    }()
    
    let comButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Contact", for: .normal)
       // btn.backgroundColor = UIColor.clear
        btn.tag = 2
        
        return btn
    }()
    
    let helpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Help", for: .normal)
      //  btn.backgroundColor = UIColor.clear
        btn.tag = 3
        return btn
    }()
    
    let accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cancel-user-30")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       // imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        //imageView.layer.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        super.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        addSubview(accountButton)
        addSubview(privButton)
        addSubview(comButton)
        addSubview(helpButton)
       

        self.layer.backgroundColor = UIColor(r: 67, g: 133, b: 203).cgColor

        let views: [String: Any] = [
            "accountButton": accountButton,
            "comButton": comButton,
            "privButton": privButton,
            "helpButton": helpButton]
        
        


        var allConstraints: [NSLayoutConstraint] = []

        // 3
        let acctBtnVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[accountButton]",
            metrics: nil,
            views: views)
        allConstraints += acctBtnVerticalConstraints


        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[accountButton(36@36)]-20-[comButton(==accountButton)]-20-[privButton(==accountButton)]-20-[helpButton(==accountButton)]-|",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        //..
        
        NSLayoutConstraint.activate(allConstraints)
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
