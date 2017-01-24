//
//  LoginViewController.swift
//  webAcademy
//
//  Created by AndreySokol on 21.12.16.
//  Copyright © 2016 AndreySasin. All rights reserved.
//

import UIKit
import XMPPFramework
import SVProgressHUD

class LoginViewController: UIViewController,XMPPStreamDelegate,UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var logginTextInput: UITextField!
    @IBOutlet weak var viewXmpp: UIView!
    
    var activeTextField: UITextField?
    var contentInsets: UIEdgeInsets?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var resultShould = false
        
        if textField === logginTextInput {
            resultShould = passwordTextInput.becomeFirstResponder()
        } else {
            resultShould = passwordTextInput.resignFirstResponder()
        }
        
        return resultShould
    }
    
    // MARK: - Notifications
    
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        if let textFieldFrame = activeTextField?.frame, let keyboardRect = ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) {
            
            let textFieldRect = viewXmpp.convert(textFieldFrame, to: view.window)
            let offset = textFieldRect.maxY - keyboardRect.minY + 20
            
            if contentInsets == nil {
                contentInsets = scrollView.contentInset
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentInset.bottom = self.contentInsets!.bottom + keyboardRect.height
                if offset > 0 {
                    self.scrollView.contentOffset.y += offset
                }
            })
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            if let insets = self.contentInsets {
                self.scrollView.contentInset = insets
                self.contentInsets = nil
            }
        })
    }
    
    // MARK: - Action

    @IBAction func connectToXMPP(_ sender: UIButton) {
        
        let infoUser = XMPPUserInfo.sharedInstance
        
        infoUser.userName = logginTextInput.text!
        infoUser.userPassword = passwordTextInput.text!
        infoUser.isRegister = false
        
        SVProgressHUD.show(withStatus: "Connect...")
        
        XmppManager.sharedInstance.connect { (succes) in
            if succes {
                //DispatchQueue.main.asynchronously(){
                self.performSegue(withIdentifier: "ShowFriendSegue", sender: self)
                SVProgressHUD.dismiss()
                //}
            }else{
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Error", message:
                    "Dont connect to XMPP!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFriendSegue"
        {
            if segue.destination is FriendsTableViewController {
                //destinationVC.numberToDisplay = counter
            }
        }
    }
}
