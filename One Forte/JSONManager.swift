//
//  JSONManager.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/9/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation

class JSONManager {
    
    var json = [AnyObject]()
    
    var count: Int {
        get {
            return json.count
        }
    }
    
    subscript(index: Int) -> AnyObject {
        return json[index]
    }
    
    func marshallJson(json: NSArray) -> [Tweet] {
        // make tweets
        var tweets = [Tweet]()
        for jsonDictionary in json {
            guard let rawTweet = jsonDictionary as? [String:AnyObject] else {
                continue
            }
            tweets.append(Tweet(jsonDictionary: rawTweet)!)
        }
        
        // save JSON
        self.json.append(json as [AnyObject])
        return tweets
    }
    
    func dump() {
        print("Dumping JSON for \(json.count) tweets")
        json.removeAll()
    }
    
}
