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
}
