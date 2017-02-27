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
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "PdPOZuL0M99HamGyjwZesURzT", consumerSecret: "OYHSMf5kre6891O1aHVcSKgUvBfdXDmHcQTtvhFcskpsga1ovI")!
    
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
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Got access token")
            
            self.currentAccount(sucess: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) -> Void in
            print("Failed to get access token")
            self.loginFailure?(error!)
        }

    }
    
    func currentAccount(sucess: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            sucess(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Failed to verify credentials")
            failure(error)
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
    
    func retweet(id: Int, success: @escaping(Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response: Any?) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Failed to retweet on id: \(id)")
            failure(error)
        })
    }
    
    func favorite(id: Int, success: @escaping(Bool) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask?, response: Any?) -> Void in
            let favSuccess = response as! Bool
            success(favSuccess)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Failed to favorite on id: \(id)")
            failure(error)
        })
    }
}
