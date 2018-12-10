//
//  GoogleSignInShared.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
import GoogleSignIn
import UIKit
class GoogleSignInShared:NSObject,GIDSignInDelegate {
   static var shared = GoogleSignInShared()
    func setupGoogleSignIn(){
        GIDSignIn.sharedInstance()?.clientID = GoogleIds.clientId
        GIDSignIn.sharedInstance()?.delegate = self
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserDefaults.standard.set(user, forKey: Keys.userInfo)
            NotificationCenter.default.post(name: NSNotification.Name( Keys.googleLogin), object: user)
        }
    }
    private override init() {
        
    }
}
