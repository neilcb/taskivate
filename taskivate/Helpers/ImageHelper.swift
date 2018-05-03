//
//  ImageHelper.swift
//  taskivate
//
//  Created by Neil Baron on 1/21/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    static var image:UIImage!
    // get data from url
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func downloadImage(url: URL) -> UIImage {
        if(self.image == nil) {
            print("Download Started")
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        }
        return image
    }
    
}


