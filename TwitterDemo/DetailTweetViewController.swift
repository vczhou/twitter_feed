//
//  DetailTweetViewController.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/27/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tweeter = tweet.user!
        profImageView.setImageWith((tweeter.profileUrl)!)
        nameLabel.text = tweeter.name
        handleLabel.text = "@\(tweeter.screenname!)"
        timestampLabel.text = tweet.timestamp?.description
        tweetLabel.text = tweet.text
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoriteCount)"

        if (tweet.favorited) {
            favButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            
        } else {
            favButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        favButton.setTitle("", for: .normal)
        
        if(tweet.retweeted){
            retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
        retweetButton.setTitle("", for: .normal)
        
        replyButton.setBackgroundImage(#imageLiteral(resourceName: "reply-icon"), for: .normal)
        replyButton.setTitle("", for: .normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onReplyButton(_ sender: Any) {
        
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if(!tweet.retweeted) {
            TwitterClient.sharedInstance.retweet(id: tweet.id!, success: { (t: Tweet) in
                self.retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
                self.tweet.retweetCount += 1
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
            self.tweet.retweeted = true
        } else {
            TwitterClient.sharedInstance.unretweet(id: tweet.id!, success: { (t: Tweet) in
                self.retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
                self.tweet.retweetCount -= 1
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
            self.tweet.retweeted = false
        }
    }

    @IBAction func onFavButton(_ sender: Any) {
        if(!tweet.favorited) {
            TwitterClient.sharedInstance.favorite(id: tweet.id!, success: { (b: NSDictionary) in
                self.favButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
                self.tweet.favoriteCount += 1
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
                self.tweet.favorited = true
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        } else {
            TwitterClient.sharedInstance.unfavorite(id: tweet.id!, success: { (b: NSDictionary) in
                self.favButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
                self.tweet.favoriteCount -= 1
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
                self.tweet.favorited = false
            }) { (error: Error) in
                print(error.localizedDescription)
            }
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
