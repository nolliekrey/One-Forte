//
//  Tweep.swift
//  One Forte
//
//  Created by Jon Whitmore on 2/8/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import Foundation

class Tweep {
    
    
    /*
     As yet unused
     
     "follow_request_sent" = 0;
     "friends_count" = 442;
     "geo_enabled" = 1;
     "has_extended_profile" = 0;
     "id_str" = 1849211953;
     "is_translation_enabled" = 0;
     "is_translator" = 0;
     lang = en;
     "listed_count" = 8;
     notifications = 0;
     protected = 0;
     "statuses_count" = 972;
     "time_zone" = "Eastern Time (US & Canada)";
     url = "http://t.co/JH19A8WiLJ";
     "utc_offset" = "-14400";
     verified = 0;
     
     */
    
    
    static let kId = "id"
    static let kName = "name"
    static let kScreenName = "screen_name"
    static let kFavoritesCount = "favourites_count"
    static let kFollowersCount = "followers_count"
    static let kFollowing = "following"
    static let kLocation = "location"
    static let kProfileBGColor = "profile_background_color"
    static let kProfileBGImageURL = "profile_background_image_url"
    static let kProfileBGImageURLHTTPS = "profile_background_image_url_https"
    static let kProfileBGTile = "profile_background_tile"
    static let kProfileBannerURL = "profile_banner_url"
    static let kProfileImageURL = "profile_image_url"
    static let kProfileImageURLHTTPS = "profile_image_url_https"
    static let kProfileLinkColor = "profile_link_color"
    static let kProfileSidebarBorderColor = "profile_sidebar_border_color"
    static let kProfileSidebarFillColor = "profile_sidebar_fill_color"
    static let kProfileTextColor = "profile_text_color"
    static let kProfileUseBGImage = "profile_use_background_image"
    
    let userId: Int
    let name: String
    let screenName: String
    let profileImageURL: String
    let profileBannerURL: String?
    let favorites: Int
    let followers: Int
    let following: Int
    let profileBGColor: String
    
    init?(jsonDictionary: [String:AnyObject]) {
        guard let
            userId = jsonDictionary[Tweep.kId] as? Int,
            name = jsonDictionary[Tweep.kName] as? String,
            screenName = jsonDictionary[Tweep.kScreenName] as? String,
            httpsImageURL = jsonDictionary[Tweep.kProfileImageURLHTTPS] as? String,
            favorites = jsonDictionary[Tweep.kFavoritesCount] as? Int,
            followers = jsonDictionary[Tweep.kFollowersCount] as? Int,
            following = jsonDictionary[Tweep.kFollowing] as? Int,
            bgColor = jsonDictionary[Tweep.kProfileBGColor] as? String
            
            else {
                // set values for declared vars before returning nil
                self.profileImageURL = ""
                self.profileBannerURL = ""
                self.name = ""
                self.screenName = ""
                self.userId = -1
                self.favorites = -1
                self.followers = -1
                self.following = -1
                self.profileBGColor = ""
                return nil
        }

        self.userId = userId
        self.name = name
        self.screenName = screenName
        self.profileImageURL = httpsImageURL
        // we don't get profile_banner_url all the time. e.g. a RT
        self.profileBannerURL = jsonDictionary[Tweep.kProfileBannerURL] as? String
        self.favorites = favorites
        self.following = following
        self.followers = followers
        self.profileBGColor = bgColor
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