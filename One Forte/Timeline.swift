//
//  TimeLine.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/10/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation


class Timeline {

    var user: CurrentUser
    
    var tweets = [Tweet]()
    
    var jsonManager = JSONManager()
    
    var count: Int {
        get {
            return tweets.count
        }
    }
    
    subscript(index: Int) -> Tweet {
        return tweets[index]
    }
    
    init(user: CurrentUser) {
        self.user = user
    }
    
    func includeJson(array: NSArray) {
        let newTweets = self.jsonManager.marshallJson(array)
        self.collateTweets(newTweets)
        
    }
    
    func collateTweets(newTweets: [Tweet]) {
        // do some timeline management, but for now ... 
        tweets = newTweets
    }
    
    func dumpJSON() {
        self.jsonManager.dump()
    }
    
}