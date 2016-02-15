//
//  Tweet.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/10/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation

class Tweet {
    
    static let kId = "id"
    static let kText = "text"
    static let kRetweets = "retweet_count"
    static let kFavorites = "favorite_count"
    static let kUser = "user"
    
    // var user: Tweep
    let id: Int
    let text: String
    let retweets: Int
    let favorites: Int
    let user: Tweep
    
    init(jsonDictionary: [String:AnyObject]) {
        id = jsonDictionary[Tweet.kId] as! Int
        text = jsonDictionary[Tweet.kText] as! String
        retweets = jsonDictionary[Tweet.kRetweets] as! Int
        favorites = jsonDictionary[Tweet.kFavorites] as! Int
        user = Tweep(jsonDictionary: jsonDictionary[Tweet.kUser] as! [String:AnyObject])
        
    }
    
    
}

class Retweet: Tweet {
    
    
}