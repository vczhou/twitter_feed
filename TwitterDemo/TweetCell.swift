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
            nameLabel.text = tweeter.name
            handleLabel.text = "@\(tweeter.screenname!)"
            timestampLabel.text = timeAgoSince(tweet.timestamp!)
            tweetTextLabel.text = tweet.text
            reweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            let favoriteImage = UIImage(named: "favor-icon")
            favoriteButton.setBackgroundImage(favoriteImage, for: .normal)
            retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
