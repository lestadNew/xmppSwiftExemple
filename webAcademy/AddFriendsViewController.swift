//
//  AddFriendsViewController.swift
//  webAcademy
//
//  Created by student on 29.12.16.
//  Copyright © 2016 AndreySasin. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFried: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var resultShould = false
        
        
        resultShould = textFried.resignFirstResponder()
        
        
        return resultShould
    }
    
    // MARK: - Action
    
    @IBAction func addUserActionButton(_ sender: UIButton) {
        if let text = textFried.text{
            if text != ""{
                let friend = UserFriend()//.userName = text
                friend.nameUser = text + "@xmpp.jp/1"
                
                XMPPUserInfo.sharedInstance.users.append(friend)
                navigationController!.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
