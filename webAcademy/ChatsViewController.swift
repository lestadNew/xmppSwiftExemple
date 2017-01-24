//
//  ChatsViewController.swift
//  webAcademy
//
//  Created by admin on 09.01.17.
//  Copyright © 2017 AndreySasin. All rights reserved.
//

import UIKit
import Foundation

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

class ChatsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    var currentChats : UserFriend?
    var contentInsets: UIEdgeInsets?
    
    @IBOutlet weak var textMessageView: UITextView!
    @IBOutlet weak var viewTextSend: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewText: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatsViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatsViewController.receivedMessageNotification), name: XmppManager.sharedInstance.notificationNameMessage, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: XmppManager.sharedInstance.notificationNameMessage, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Private methodes
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(rect.size.width, rect.size.height)
        return size
    }
    
   
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: -UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Notifications
    
    func receivedMessageNotification(notification: Notification){
        tableView.reloadData()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomViewText?.constant = 0.0
            } else {
                self.bottomViewText?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
        
}
    
    func keyboardDidHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomViewText?.constant = 0.0
            } else {
                self.bottomViewText?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }

    }

    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let numberRow = currentChats?.message.count{
            return numberRow
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentChats?.message[indexPath.row].isOwnner == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCell", for: indexPath) as? ChatsOwnerCellTableViewCell
            
            if let messageText = currentChats?.message[indexPath.row].message{
                cell?.messageText?.text = messageText
            }else{
                print("Nil")
            }
            
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as? ChatOtherTableViewCell
            
            if let messageText = currentChats?.message[indexPath.row].message{
                cell?.textMessageOtherCell?.text = messageText
            }else{
                print("Nil")
            }
            return cell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let labelSize = rectForText(text: (currentChats?.message[indexPath.row].message)!, font: UIFont.systemFont(ofSize: 18), maxSize: CGSize(100,999))
        return labelSize.height + 60
    }
    
    // MARK: - Actions
    
    @IBAction func actionSend(_ sender: UIButton) {
        dismissKeyboard()
        XmppManager.sharedInstance.sendMessage(toUser: (currentChats?.nameUser!)!, messageToUser: textMessageView.text)
        
        let message = MessageShared()
        message.isOwnner =  true
        message.message = textMessageView.text
        currentChats?.message.append(message)
        
        tableView.reloadData()
    }
}
