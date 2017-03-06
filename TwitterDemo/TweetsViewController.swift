//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/26/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.dataSource = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        loadTimeline()
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadTimeline()
        refreshControl.endRefreshing()
    }
    
    func loadTimeline() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onNewButton(_ sender: Any) {
        performSegue(withIdentifier: "compose", sender: self)
    }
    
    @IBAction func onProfImButton(_ sender: Any) {
        performSegue(withIdentifier: "userDetail", sender: (sender as! UIButton).superview?.superview as! TweetCell)
    }
    
    /*@IBAction func onReplyButton(_ sender: Any) {
        performSegue(withIdentifier: "compose", sender: (sender as! UIButton).superview?.superview as! TweetCell)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets{
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("Prepare for segue called")
        print(segue.identifier ?? "no identifier")
        
        if (segue.identifier == "compose"){
            print("Hello ")
            let destination = segue.destination as! ComposeTweetViewController
            destination.isReply = false
        } else if (segue.identifier == "userDetail") {
            print("Hello hello")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweetCell = tweets![indexPath!.row]
            
            let destination = segue.destination as! ProfileViewController
            destination.user = tweetCell.user
        } else {
            print("Lols why")
            let cell = sender as! TweetCell
            
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
        
            let detailViewController = segue.destination as! DetailTweetViewController
            detailViewController.tweet = tweet
        }
    }
    
}
