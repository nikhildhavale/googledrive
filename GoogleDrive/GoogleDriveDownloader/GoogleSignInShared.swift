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
            NotificationCenter.default.post(name: NSNotification.Name( Keys.googleLogin), object: nil)
        }
    }
    private override init() {
        
    }
}
