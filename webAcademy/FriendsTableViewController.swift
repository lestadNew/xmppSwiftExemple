//
//  FriendsTableViewController.swift
//  webAcademy
//
//  Created by student on 29.12.16.
//  Copyright © 2016 AndreySasin. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return XMPPUserInfo.sharedInstance.users.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFriend", for: indexPath) as! FriendsTableViewCell
        
        let separate = (XMPPUserInfo.sharedInstance.users[indexPath.row].nameUser)!.components(separatedBy: "@")
        
        cell.labelName.text = separate.first

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Chats", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chats" ,
            let nextScene = segue.destination as? ChatsViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedChats = XMPPUserInfo.sharedInstance.users[indexPath.row]
            nextScene.currentChats = selectedChats
        }
    }
}
