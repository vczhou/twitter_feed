//
//  User.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/22/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var tagline: String?
    
    var profileUrl: URL?
    var backgroundUrl: URL?
    
    var numTweets: Int?
    var numFavorites: Int?
    var numFollowers: Int?
    var numFollowing: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileUrlString  = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = URL(string: backgroundUrlString)
        }
        
        numTweets = (dictionary["statuses_count"] as? Int) ?? 0
        numFavorites = (dictionary["favourites_count"] as? Int) ?? 0
        numFollowers = (dictionary["followers_count"] as? Int) ?? 0
        numFollowing = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUserData") as? Data
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
                
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
            
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
                //defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

}
