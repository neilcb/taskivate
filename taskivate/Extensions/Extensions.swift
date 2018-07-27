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
let userCache = NSCache<NSString, User>()


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

extension UINavigationItem {
    
    
    func setUpProfileImage(urlString: String) {
        
        let widthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: 40)
        
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .done, target: nil, action: nil)
        negativeSpacer.width = 25
        
        let imageItem = UIBarButtonItem.init(customView: profileImageView)
        
        self.leftBarButtonItem =  imageItem
        
        profileImageView.loadImageUserCacheWithUrlString(urlString: urlString)
        
    }
    
    
    
}
extension UIImageView {
   
    
    func loadImageUserCacheWithUrlString(urlString: String) {
        
        self.image = nil
        SwiftyBeaver.info("check for image \(urlString) ")
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
                    SwiftyBeaver.info("saving to cach \(urlString)")
                    self.image = downloadedImage
                }
            }
        }
            
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorCenter(to view: UIView, size: CGSize = .zero) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
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
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UIImage {
    
    func fixImageOrientation() -> UIImage? {
        var flip:Bool = false //used to see if the image is mirrored
        var isRotatedBy90:Bool = false // used to check whether aspect ratio is to be changed or not
        
        var transform = CGAffineTransform.identity
        
        //check current orientation of original image
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.rotated(by: CGFloat(Double.pi));
            
        case .left, .leftMirrored:
            transform = transform.rotated(by: CGFloat(Double.pi/2));
            isRotatedBy90 = true
        case .right, .rightMirrored:
            transform = transform.rotated(by: CGFloat(Double.pi/2));
            isRotatedBy90 = true
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            flip = true
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            flip = true
        default:
            break;
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        //check if we have to fix the aspect ratio
        if isRotatedBy90 {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.height,height: size.width))
        } else {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width,height: size.height))
        }
        
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage
    }
}
