//
//  ViewController.swift
//  taskivate
//
//  Created by Neil Baron on 5/6/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
class TestViewController: UIViewController {
    private var collectionViewSizeChanged: Bool = false
    private let margin: CGFloat = 20.0
    var pageControl = UIPageControl.init()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 67, g: 133, b: 203)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //view.addSubview(contentView)
       // setupLayout()
        
        setupMenuBar()
       
    }
    
   
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
        
    }()
    
    private func setupMenuBar() {
        
        
        view.addSubview(menuBar)
        let views: [String: Any] = [
            "menuBar": menuBar]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        // 3
        let acctBtnVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-100-[menuBar(50)]",
            metrics: nil,
            views: views)
        allConstraints += acctBtnVerticalConstraints
        
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[menuBar(50)]|",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        allConstraints += topRowHorizontalConstraints
       
        NSLayoutConstraint.activate(allConstraints)
        
        
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if collectionViewSizeChanged {
            collectionViewSizeChanged = false
            menuBar.collectionView.performBatchUpdates({}, completion: nil)
        }
    }
    
    
   
    private func setupLayout() {
       
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: view.frame.width).isActive = true
        //contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        //contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
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
