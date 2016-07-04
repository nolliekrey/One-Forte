//
//  OFProfileViewController.swift
//  One Forte
//
//  Created by Jon Whitmore on 5/9/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import UIKit


class OFProfileViewController: UITableViewController {
    
    var tweep :Tweep!
    
    // Any image we download is cached
    var imageCache = ImageCache()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("OFProfileHeaderViewCell_id") as! OFProfileHeaderViewCell
        guard let urlString = tweep.profileBannerURL else {
            cell.customImageView.alpha = 0.0
            cell.backgroundColor = UIColor.init(withHexString: tweep.profileBGColor)
            
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(OFProfileViewController.navigateBack(_:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            tapRecognizer.numberOfTouchesRequired = 1
//            cell.backButton.addGestureRecognizer(tapRecognizer)
            
            cell.setNeedsDisplay()
            return cell
        }
        
        cell.customImageView.image = self.imageCache[urlString]
        if (cell.customImageView.image == nil) {
            cell.customImageView.alpha = 1.0
            
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(OFProfileViewController.navigateBack(_:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            tapRecognizer.numberOfTouchesRequired = 1
//            cell.backButton.addGestureRecognizer(tapRecognizer)
            
            self.imageCache.fetchImage(urlString, completionHandler: { (success) -> Void in
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.customImageView.image = self.imageCache[urlString]
                        tableView.reloadData()
                    })
                }
            })
        }
        return cell

    }
    
    func navigateBack(sender:UITapGestureRecognizer) {
        print("NOPE!! :) ")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 101.0
    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let c = self.timeline?.count {
//            return c
//        } else {
//            return 0
//        }
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageCache.dump()
    }
    
}
