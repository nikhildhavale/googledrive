//
//  ViewController.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import UIKit
import GoogleSignIn
import OAuthSwift
import AppAuth
import GTMAppAuth
class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate{

    @IBOutlet  var signInButton: GIDSignInButton!
    var signOut = UIButton(type: UIButton.ButtonType.system)
    var flowSession:OIDAuthorizationFlowSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.signInDone(notificaton:)), name:  NSNotification.Name( Keys.googleLogin), object: nil)
        GIDSignIn.sharedInstance()?.scopes = Google.scopes
        setUpUI()
    
      
        
    }
    
    @objc func signInDone(notificaton:Notification){
        toggleSignInSignOutUI()
        refreshListOfFiles()

    }
    func refreshListOfFiles(){
        for child in self.children {
            if let listOfFilesController = child as? ListOfFilesTableViewController {
                listOfFilesController.gtlQuery()
                break
            }
        }
    }
    func setUpUI(){
        signInButton = GIDSignInButton(frame: CGRect.zero)
        signOut.addTarget(self, action: #selector(signOutClicked), for: .touchUpInside)
        signOut.setTitle("Sign Out", for: .normal)
        signOut.tintColor = UIColor.blue
        toggleSignInSignOutUI()
        
    }
    
    func toggleSignInSignOutUI(){
        if UserDefaults.getCustomObjectfor(Key: Keys.userInfo) == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signInButton)
            
        }
        else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)
            refreshListOfFiles()
            
        }
    }
    @objc func signOutClicked(){
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: Keys.userInfo)
        toggleSignInSignOutUI()

    }
    @objc func loginButtonClicked(){
        if GIDSignIn.sharedInstance()!.hasAuthInKeychain(){
            GIDSignIn.sharedInstance()?.signInSilently()
        }
        else{
            GIDSignIn.sharedInstance()?.signIn()
        }
        
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)

    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error != nil) {
            print(error)
        }
        else{
            GoogleSignInShared.shared.gtlDriveService.authorizer = user.authentication.fetcherAuthorizer()
            refreshListOfFiles()
        }


    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

