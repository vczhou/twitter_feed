//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/21/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginButton(_ sender: Any) {
        //let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "jo7AnPgdDAvdDkjNX1Dzgnmp7", consumerSecret: "MH5lE6TCbrgMUwJ7WPkbMgDVqmuGDB6EVrRJkikJDUx33aQRX1")!
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil,success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("Got request token")
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(authURL!)
        }) { (error: Error?) -> Void in
            print("Failed to get request token")
        }
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
