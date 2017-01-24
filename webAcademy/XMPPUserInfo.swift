//
//  XMPPUserInfo.swift
//  webAcademy
//
//  Created by AndreySokol on 26.12.16.
//  Copyright © 2016 AndreySasin. All rights reserved.
//

import UIKit
import Foundation

class XMPPUserInfo: NSObject {
    
    static let sharedInstance : XMPPUserInfo = {
        let instance = XMPPUserInfo()
        return instance
    }()
    
    var userName : String?
    var userPassword : String?
    var isRegister : Bool?
    
    
    var users = [UserFriend]()
}
