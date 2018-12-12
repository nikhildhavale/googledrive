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
class LoginViewController: UIViewController,GIDSignInUIDelegate{

    @IBOutlet  var signInButton: GIDSignInButton!
    var signOut = UIButton(type: UIButton.ButtonType.system)
    var flowSession:OIDAuthorizationFlowSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.signInDone(notificaton:)), name:  NSNotification.Name( Keys.googleLogin), object: nil)
        GIDSignIn.sharedInstance()?.scopes.append(Google.scope)
        setUpUI()
        let request = OIDAuthorizationRequest(configuration: GTMAppAuthFetcherAuthorization.configurationForGoogle(), clientId: Google.clientId, clientSecret: nil, scope: Google.scope, redirectURL: URL(string:"http://127.0.0.1:64184/"), responseType: OIDResponseTypeCode, state: nil, codeVerifier: nil, codeChallenge: nil, codeChallengeMethod: nil, additionalParameters: nil)
          flowSession =   OIDAuthState.authState(byPresenting: request, presenting: self, callback: {(authstate,error) in
                print(authstate)
                print(error)
            })
    
      
        
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
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)

    }
}

