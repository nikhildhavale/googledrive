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
import GoogleAPIClientForREST
import GGLCore
class GoogleSignInShared:NSObject,GIDSignInDelegate {
   static var shared = GoogleSignInShared()
    var user:GIDGoogleUser?
    let gtlDriveService = GTLRDriveService()
    var authorizer:GTMFetcherAuthorizationProtocol?
    func setupGoogleSignIn(){
        var error:NSError?
        GGLContext.sharedInstance()?.configureWithError(&error)
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
//            let profile = GoogleUserProfile()
//            profile.firstName =  user.profile.name
//            profile.familyName = user.profile.familyName
//            profile.userEmail = user.profile.email
//            profile.id = user.userID
//            profile.token = user.authentication.idToken
            
           // UserDefaults.saveCustomObject(obj: profile, for: Keys.userInfo)
            self.user = user
            NotificationCenter.default.post(name: NSNotification.Name( Keys.googleLogin), object: nil)
        }
    }
    private override init() {
        
    }
}
