//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/22/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "jo7AnPgdDAvdDkjNX1Dzgnmp7", consumerSecret: "MH5lE6TCbrgMUwJ7WPkbMgDVqmuGDB6EVrRJkikJDUx33aQRX1")!
    
    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            print("name: \(user.name)")
            print("screename: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("decription: \(user.tagline)")
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Failed to verify credentials")
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Failed to get home timeline")
            failure(error)
        })
    }
}
