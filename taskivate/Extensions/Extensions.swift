//
//  Extensions.swift
//  taskivate
//
//  Created by Neil Baron on 4/28/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBeaver

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
   
    
    func loadImageUserCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off fresh downlaod from storage
        let url = URL(string: urlString)
        ImageHelper.getDataFromUrl(url: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            SwiftyBeaver.info("download finished")
            
            if error != nil {
                SwiftyBeaver.error("Unable to download image \(error.debugDescription)")
            }
            
            DispatchQueue.main.async() {
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                }
            }
        }
            
    }
}

extension UIColor {
    convenience init(r: CGFloat,g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}


