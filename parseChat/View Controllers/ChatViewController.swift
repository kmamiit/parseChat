//
//  ChatViewController.swift
//  parseChat
//
//  Created by Kyle Mamiit (New) on 11/1/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatMessageField: UITextField!
    
    //@IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 50
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        messagesTableView.insertSubview(refreshControl, at: 0)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer() {
        fetchMessages()
    }

    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMessages()
    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        // query.addAscendingOrder("createdAt")
        query.addDescendingOrder("createdAt")
        // let response = query.findObjectsInBackground()
        query.findObjectsInBackground { (pfobject, error) in
            if error == nil {
                if let pfobject = pfobject {
                    self.messages = pfobject
                    print(self.messages)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        self.messagesTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage.saveInBackground { (success, error: Error?) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        let messageText = message["text"] as? String
        cell.messageLabel.text = messageText
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
