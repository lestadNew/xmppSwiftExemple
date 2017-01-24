//
//  XmppManager.swift
//  webAcademy
//
//  Created by AndreySokol on 21.12.16.
//  Copyright © 2016 AndreySasin. All rights reserved.
//

import UIKit
import Foundation
import XMPPFramework

class XmppManager: NSObject,XMPPStreamDelegate {
    
    static var kDOMAIN = "xmpp.jp"
    let notificationNameMessage = Notification.Name("NotificationNameMessage")
    
    var xmppStream :XMPPStream?
    //let b = XMPPJID.user
    static let sharedInstance : XmppManager = {
        let instance = XmppManager()
        instance.setupStream()
        return instance
    }()
    
    
    var complitionHandlerXMPP: ((Bool)->(Void))!
    
    //MARK: - Private Methods
    
    func sendMessage(toUser jid:String, messageToUser message:String) -> () {
       
       /* let senderJID = XMPPJID(string:jid)
        let msg = XMPPMessage(type: "chat", to: senderJID)
        
        msg?.addBody(message)
        self.xmppStream?.send(msg)*/
        let body = DDXMLElement.element(withName: "body") as! DDXMLElement
        let messageID = self.xmppStream?.generateUUID()
        
        //body.setStringValue("Message")
        body.stringValue = message
        //body = DDXMLElement(name: "body", stringValue: "Message")
        let completeMessage = DDXMLElement.element(withName: "message") as! DDXMLElement
        
        completeMessage.addAttribute(withName: "id", stringValue: messageID!)
        completeMessage.addAttribute(withName: "type", stringValue: "chat")
        completeMessage.addAttribute(withName: "to", stringValue: jid)
        completeMessage.addChild(body)
        
        let active = DDXMLElement.element(withName: "active", stringValue:
            "http://jabber.org/protocol/chatstates") as! DDXMLElement
        completeMessage.addChild(active)
        
        self.xmppStream?.send(completeMessage)
    }
    
    func setupStream() {
        self.xmppStream = XMPPStream()
        self.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    func connect(completionHandler: @escaping (_ succes:Bool) -> Void){
        
        complitionHandlerXMPP = completionHandler
        
        if !(self.xmppStream?.isConnected())! {
          
        
            if !(xmppStream?.isDisconnected())! {
                //return true
            }
            
            self.xmppStream?.myJID =  XMPPJID.init(user:XMPPUserInfo.sharedInstance.userName!,domain: XmppManager.kDOMAIN,resource:"1")
            self.xmppStream?.hostName = XmppManager.kDOMAIN;
            
            do {
                try xmppStream?.connect(withTimeout: XMPPStreamTimeoutNone)
                print("Connection success")
                //return true
            } catch {
                print("Something went wrong!")
                //return false
            }
        } else {
            complitionHandlerXMPP(false)
        }
    }

    //MARK: XMPPStreamDelegate
    
    func xmppStreamWillConnect(_ sender: XMPPStream!){
        print("xmppStreamWillConnect")

    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream!){
        do {
            try	xmppStream?.authenticate(withPassword: XMPPUserInfo.sharedInstance.userPassword!)
        } catch {
            print("Could not authenticate")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        print("xmppStreamDidAuthenticate")
        complitionHandlerXMPP(true)
        // goOnline()
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!){
        complitionHandlerXMPP(false)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        print("Did receive IQ")
        return false
    }
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool{
        print("Did receive IQ")
        return false
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        print("Did receive message \(message)")
        
        if let item = XMPPUserInfo.sharedInstance.users.first(where:{$0.nameUser == message.fromStr()}) {
            let newMessage = MessageShared()
            newMessage.message = message.body()
            newMessage.isOwnner =  false
            item.message.append(newMessage)
            NotificationCenter.default.post(name: notificationNameMessage, object: self, userInfo: nil)
            // item is the first matching array element
        } else {
            // not found
        }
        
        /*if let user = XMPPUserInfo.sharedInstance.users.contains(where: {$0.nameUser == message.fromStr()}) {
            
            // it exists, do something
        } else {
            // item not found
        }*/
        
       /* if let found = find(XMPPUserInfo.sharedInstance.users.map({ $0.nameUser }), "Foo") {
            let obj = array[found]
        }*/
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        print("Did send message \(message)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!){
        print("didFailToSend \(message) \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!){
         print("didReceiveError \(sender) \(error)")
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let presenceType = presence.type()
        let myUsername = sender.myJID.user
        let presenceFromUser = presence.from().user
        
        /*if presenceFromUser != myUsername {
            print("Did receive presence from \(presenceFromUser)")
            if presenceType == "available" {
                delegate.buddyWentOnline("\(presenceFromUser)@gmail.com")
            } else if presenceType == "unavailable" {
                delegate.buddyWentOffline("\(presenceFromUser)@gmail.com")
            }
        }*/
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print("Did receive Roster item")
    }

}
