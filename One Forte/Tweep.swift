//
//  Tweep.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/8/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation

class Tweep {
    
    static let kId = "id"
    static let kName = "name"
    static let kScreenName = "screen_name"
    static let kHTTPSimageURL = "profile_image_url_https"
    
    let userId: Int
    let name: String
    let screenName: String
    let httpsImageURL: String
    
    init(jsonDictionary: [String:AnyObject]) {
        userId = jsonDictionary[Tweep.kId] as! Int
        name = jsonDictionary[Tweep.kName] as! String
        screenName = jsonDictionary[Tweep.kScreenName] as! String
        httpsImageURL = jsonDictionary[Tweep.kHTTPSimageURL] as! String
    }
}


class CurrentUser {
    
    static let kCurrentUserKey = "CurrentTwitterUser"
    static let kSinceTweetIdKey = "TimelineSinceId"
    
    let userDefaults: NSUserDefaults
    
    init?(userDefaults: NSUserDefaults) {
        self.userDefaults = userDefaults
        if let twitterId = userDefaults.objectForKey(CurrentUser.kCurrentUserKey) {
            sinceId = userDefaults.objectForKey(CurrentUser.kSinceTweetIdKey) as? String
            userId = twitterId as! String
        } else {
            sinceId = "1"
            userId = "nope"
            return nil
        }
    }
    
    var sinceId: String? {
        didSet {
            self.userDefaults.setObject(self.sinceId, forKey: CurrentUser.kSinceTweetIdKey)
            self.userDefaults.synchronize()
        }
    }
    
    var userId: String {
        didSet {
            self.userDefaults.setObject(self.userId, forKey: CurrentUser.kCurrentUserKey)
            self.userDefaults.synchronize()
        }
    }
}