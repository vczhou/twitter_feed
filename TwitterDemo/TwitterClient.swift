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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil,success: { (requestToken: BDBOAuth1Credential?) -> Void in
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(authURL!)
        }) { (error: Error?) -> Void in
            print("Failed to get request token")
            self.loginFailure?(error!)
        }

    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Got access token")
            
            self.loginSuccess?()
            
            /*currentAccount()
            homeTimeline(success: { (tweets: [Tweet]) -> () in
                for tweet in tweets {
                    print(tweet.text!)
                }
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })*/
            
        }) { (error: Error?) -> Void in
            print("Failed to get access token")
            self.loginFailure?(error!)
        }

    }
    
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
