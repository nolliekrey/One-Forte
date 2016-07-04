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
    
    let id: Int
    let text: String
    let retweets: Int
    let favorites: Int
    
    // Tweep is optional in case of parsing error
    let user: Tweep?
    
    init?(jsonDictionary: [String:AnyObject]) {
        guard let
        id = jsonDictionary[Tweet.kId] as? Int,
        text = jsonDictionary[Tweet.kText] as? String,
        retweets = jsonDictionary[Tweet.kRetweets] as? Int,
            favorites = jsonDictionary[Tweet.kFavorites] as? Int else {
                self.id = -1
                self.text = "SATAN"
                self.favorites = -1
                self.user = nil
                return nil
        }
        self.id = id
        self.text = text
        self.retweets = retweets
        self.favorites = favorites
        user = Tweep(jsonDictionary: jsonDictionary[Tweet.kUser] as! [String:AnyObject])
    }
}

class Retweet: Tweet {
    
    
}