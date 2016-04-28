//
//  ViewController.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/7/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import UIKit
import Accounts
import Social

class OFTimelineViewController: UITableViewController {
    
    // The twitter user associated wtih the timeline. The logged in user.
    private var currentUser: CurrentUser?
    
    // The twitter timeline for the current user
    var timeline: Timeline?
    
    // Any image we download is cached
    var imageCache = ImageCache()
    
    // When an account is chosen refresh the current user
    private var twitterAccount: ACAccount? {
        didSet {
            let userId = twitterAccount?.identifier
            let userDefaults = NSUserDefaults.init()
            userDefaults.setObject(userId, forKey: CurrentUser.kCurrentUserKey)
            self.currentUser = CurrentUser(userDefaults: userDefaults)
            self.timeline = Timeline(user: self.currentUser!)
        }
    }
    
    // reusable closure to ask for Twitter permission
    private lazy var deniedAccess: () -> Void = {
        // ask the user to enable Twitter in Settings -> Twitter, bottom of the screen
        let deniedMessageController = UIAlertController.init(title: "Access to Twitter",
            message: "Please open Settings.app and scroll down to Twitter. In Twitter settings enable access to \(3)",
            preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // no-op. Just let the dialog close
        }
        deniedMessageController.addAction(OKAction)
        self.presentViewController(deniedMessageController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if appDelegate.currentUser == nil {
            self.askForAccessAndUserId()
            
        } else {
            self.currentUser = appDelegate.currentUser

            // Simple closure to find the account we want to use
            let granted = {(accounts: [AnyObject]!) -> Void in
                for account in accounts as! [ACAccount] {
                    if (account.identifier == self.currentUser?.userId) {
                        self.twitterAccount = account
                        print("Found account last used")
                        break
                    }
                }
                self.loadTimeLine(nil)
            }
            // always check that access has not been revoked
            checkTwitterAccess(ifGranted: granted, ifDenied: self.deniedAccess)
        }
    }
    
    func askForAccessAndUserId() {
        
        // create access granted closure to allow user to pick which account to use 
        let granted = {(accounts: [AnyObject]!) -> Void in
            // ask the user to choose which account to use
            if accounts.count == 1 {
                self.twitterAccount = (accounts[0] as! ACAccount)
                self.loadTimeLine(nil)
                
            } else {
                let chooseAccountController = UIAlertController.init(title: "Which Account?", message: "Select an account", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                for account in accounts as! [ACAccount] {
                    let action = UIAlertAction(title: account.accountDescription, style: .Default) { (_) in
                        self.twitterAccount = account
                        // request timeline!
                        self.loadTimeLine(nil)
                    }
                    chooseAccountController.addAction(action)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.presentViewController(chooseAccountController, animated: true) {
                        print("Asking which account")
                    }
                }
            }
        }
        
        // check for access
        self.checkTwitterAccess(ifGranted: granted, ifDenied: self.deniedAccess)
    }
    
    func checkTwitterAccess(ifGranted grantedBlock: (accounts: [AnyObject]!) -> Void, ifDenied deniedBlock:() -> Void) {
        
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
            (grantedAccess, error) in
            guard let error = error else {
                if grantedAccess {
                    let accounts = accountStore.accountsWithAccountType(twitterAccountType)
                    print("Twitter access to \(accounts.count) accounts.")
                    grantedBlock(accounts: accounts)
                    
                } else {
                    print("Access to Twitter was not granted.")
                    deniedBlock()
                }
                return
            }
            print("Twitter access error:\n\(error)")
        }
    }
    
    func loadTimeLine(sinceId: String?) {
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        var params: [NSObject: AnyObject]
        params = [
            "user_id" : (currentUser?.userId)!,
            "include_rts" : "true",
            "count" : "20"]
        
        if let id = sinceId {
            params["since_id"] = id
        }
        
        let request = SLRequest.init(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url!, parameters: params)
        request.account = twitterAccount
        request.performRequestWithHandler { (data, response, error) -> Void in
            guard let data = data else {
                print("Error requesting timeline\n \(error)")
                return
            }
            if response.statusCode >= 200 && response.statusCode < 300 {
                do {
                    let timelineJson = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSArray
                    print("\(timelineJson.count) articles fetched")
                    self.timeline!.includeJson(timelineJson)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })

                } catch let error {
                    print("Error while deserializing timeline:\n\(error)")
                }
                
            } else {
                print("Wacky code for timeline:\(response.statusCode)")
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = self.timeline?.count {
            return c
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        if indexPath.row%2 == 1 {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OFTweetTableViewCell_id") as! OFTweetTableViewCell
        let tweet = self.timeline!.tweets[indexPath.row]
        
        cell.tweepHandleLabel.text = "@" + (tweet.user?.screenName)!
        cell.tweepNameLabel.text = tweet.user?.name
        cell.tweetBodyLabel.text = tweet.text
        guard let urlString = tweet.user?.httpsImageURL else {
            return cell
        }
        cell.tweepImageView.image = self.imageCache[urlString]
        if (cell.tweepImageView.image == nil) {
            self.imageCache.fetchImage(urlString, completionHandler: { (success) -> Void in
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    })
                }
            })
        }
        return cell
//        } else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("OFStackTweetTableViewCell_id") as! OFStackTweetTableViewCell
//            let tweet = self.timeline!.tweets[indexPath.row]
//            cell.tweepHandleLabel.text = "@" + tweet.user.screenName
//            cell.tweepUsernameLabel.text = tweet.user.name
//            cell.tweetBodyLabel.text = tweet.text
//            let urlString = tweet.user.httpsImageURL
//            cell.tweepImageView.image = self.imageCache[urlString]
//            if (cell.tweepImageView.image == nil) {
//                self.imageCache.fetchImage(urlString, completionHandler: { (success) -> Void in
//                    if (success) {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
//                        })
//                    }
//                })
//            }
//            
//            return cell
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.dump()
        timeline!.dumpJSON()
    }
}

