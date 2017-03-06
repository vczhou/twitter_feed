//
//  ComposeTweetViewController.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 3/1/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    var replyText: String = ""
    var isReply: Bool = false
    var replyId: Int = 0
    var user: User!
    let maxCharacters = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.currentUser

        if (!replyText.isEmpty) {
            tweetTextField.text = replyText
        }
        tweetTextField.becomeFirstResponder()
        
        profImageView.setImageWith(user.profileUrl!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("I'm editing???")
        charCountLabel.text = "\(maxCharacters - (tweetTextField.text?.characters.count)!)"
    }

    @IBAction func onTweetButton(_ sender: Any) {
        print(tweetTextField.text ?? "no text")
        // Tweet is too long
        if ((tweetTextField.text?.characters.count)! > maxCharacters) {
            let alertController = UIAlertController(title: "Max characters exceeded.", message: "Tweet exceeds max length of \(maxCharacters) characters", preferredStyle: .alert)
            
            // create a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
            return
        }
        
        TwitterClient.sharedInstance.tweet(tweet: tweetTextField.text!, isReply: isReply, id: replyId, success: { (tweet: Tweet) in
                self.dismiss(animated: true, completion: nil)
            }) { (error: Error) in
                print("Failed to compose/ reply to tweet")
                print(error.localizedDescription)
        }        
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
