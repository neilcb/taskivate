//
//  LaunchViewController.swift
//  taskivate
//
//  Created by Neil Baron on 6/1/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let launchImageView: UIImageView = {
        
        let lv = UIImageView()
        lv.translatesAutoresizingMaskIntoConstraints = true
        lv.layer.borderColor = UIColor.white.cgColor
        lv.layer.borderWidth = 3
        lv.image = #imageLiteral(resourceName: "iTunesArtwork")
        lv.layer.masksToBounds = true
        return lv
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpView() {
        
        view.addSubview(launchImageView)
        launchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        launchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
