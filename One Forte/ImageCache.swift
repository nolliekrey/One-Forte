//
//  ImageCache.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/10/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    var totalBytes = 0
    
    var urlToImage = [String:UIImage]()
    
    func dump() {
        urlToImage.removeAll()
        print("Dumping \(totalBytes) bytes")
        totalBytes = 0
    }
    
    subscript(urlString: String) -> UIImage? {
        get {
            return urlToImage[urlString]
        }
        
        set {
            urlToImage[urlString] = newValue
        }
    }
    
    func fetchImage(urlString: String, completionHandler: (success: Bool) -> Void) {
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, httpResponse, error) -> Void in
            guard let data = data else {
                print("No data")
                if let error = error {
                    print("\(error)")
                }
                completionHandler(success: false)
                return
            }
            guard let image = UIImage(data: data) else {
                print("corrupt image data")
                completionHandler(success: false)
                return
            }
            self.totalBytes += data.length
            self.reportTotalBytes()
            self[urlString] = image
            completionHandler(success: true)
            
        }.resume()
    }
    
    func reportTotalBytes() {
        switch totalBytes {
        case let bytes where bytes > 1_000 && bytes < 1_000_000:
            let kb = Double(bytes)/1000.00
            print("Image size total: \(kb) KB")
            
        case let bytes where bytes > 1_000_000 && bytes < 1_000_000_000:
            let mb = Double(bytes)/1_000_000.00;
            print("Image size total: \(mb) MB")
            
        case let bytes where bytes > 1_000_000_000:
            let gb = Double(bytes)/1_000_000_000.00;
            print("Image size total: \(gb) GB")
        default:
            print("Image size total: \(self.totalBytes) bytes")
            
        }
        
        
    }
}
