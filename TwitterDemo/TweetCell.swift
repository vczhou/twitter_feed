//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/26/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var reweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet! {
        didSet{
            let tweeter = tweet.user!
            profileImageView.setImageWith((tweeter.profileUrl)!)
            let imageView = profileImageView!
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector(("imageTapped:")))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            nameLabel.text = tweeter.name
            handleLabel.text = "@\(tweeter.screenname!)"
            timestampLabel.text = timeAgoSince(tweet.timestamp!)
            tweetTextLabel.text = tweet.text
            reweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoriteCount)"

            if (tweet.favorited) {
                favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
                
            } else {
                favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
            favoriteButton.setTitle("", for: .normal)

            if(tweet.retweeted){
                retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            } else {
                retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
            retweetButton.setTitle("", for: .normal)
        }
    }
    
    func imageTapped(img: UIGestureRecognizer) {
        print("image was clicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.user = tweet.user
        
        window?.rootViewController = vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        if(!tweet.retweeted) {
            TwitterClient.sharedInstance.retweet(id: tweet.id!, success: { (t: Tweet) in
                self.retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
                self.tweet.retweetCount += 1
                self.reweetCountLabel.text = "\(self.tweet.retweetCount)"
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
            self.tweet.retweeted = true
        } else {
            TwitterClient.sharedInstance.unretweet(id: tweet.id!, success: { (t: Tweet) in
                self.retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
                self.tweet.retweetCount -= 1
                self.reweetCountLabel.text = "\(self.tweet.retweetCount)"
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
            self.tweet.retweeted = false
        }
    }
    
    @IBAction func onFavButton(_ sender: Any) {
        if(!tweet.favorited) {
            TwitterClient.sharedInstance.favorite(id: tweet.id!, success: { (b: NSDictionary) in
                self.favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
                self.tweet.favoriteCount += 1
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
                self.tweet.favorited = true
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        } else {
            TwitterClient.sharedInstance.unfavorite(id: tweet.id!, success: { (b: NSDictionary) in
                self.favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
                self.tweet.favoriteCount -= 1
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
                self.tweet.favorited = false
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        }
    }
}
