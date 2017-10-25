//
//  ViewController.swift
//  Vo Chat
//

import UIKit
import Firebase
import ChameleonFramework
import Alamofire
import SwiftyJSON

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    let FCM_URL = "https://fcm.googleapis.com/fcm/send"
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        // Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        // Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        // Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
        // Subscribe to usaa labs topic
        FIRMessaging.messaging().subscribe(toTopic: "/topics/usaalabs")
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    // Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == FIRAuth.auth()?.currentUser?.email as String! {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    
    // Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    // Declare tableViewTapped here:
    func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    // Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    // Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    // Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        // Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = FIRDatabase.database().reference().child("Messages")
        let messageDictionary = ["Sender": FIRAuth.auth()?.currentUser?.email, "MessageBody": messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, ref) in
            if error != nil {
                print(error)
            }
            else {
                print("Message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                
                // send notification
                self.sendFcmMessage(url: self.FCM_URL, message: self.messageTextfield.text!)
            }
        }
        
        
    }
    
    // Create the retrieveMessages method here:
    func retrieveMessages() {
        let messagesDB = FIRDatabase.database().reference().child("Messages")
        messagesDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        })
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the sendFcmMessage method here:
    func sendFcmMessage(url: String, message: String) {
        let FCM_SERVER_KEY = "AAAAJHlWgyQ:APA91bGHh6YFioKjg0LPuE8s0Le6EkvzB5ZzXLsBlCLwQs2IhZ_GAFoUZtuKDkGDoRdKC3Ej7hDWB3Xohl1iuKN9IOD26WYzVxtxp9BGJTmUgQKj2XcBYvZ0udKpz8Pmb7BSfKnGkBUp"
        let params : [String : Any] =
            ["to": "/topics/usaalabs", "data": ["message": message]]
        let headers: HTTPHeaders = [
            "Authorization": "key=\(FCM_SERVER_KEY)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                print("Send response: \(response)")
            }
            else {
                print("Failed to send message.")
            }
        }
    }
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        // Unsubscribe to usaa labs topic
        FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/usaalabs")
        
        // Log out the user and send them back to WelcomeViewController
        do {
            try FIRAuth.auth()?.signOut()
            print("User signed out")
        }
        catch {
            print("error: there was a problem signing out")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No View Controllers to pop off")
                return
        }
        
    }
    


}
