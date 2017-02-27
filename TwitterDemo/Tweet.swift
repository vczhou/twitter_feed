//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/22/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    var retweeted = false
    var favorited = false
    
    init(dictionary: NSDictionary) {
        id = (dictionary["id"] as? Int) ?? 0
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
