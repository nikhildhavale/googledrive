//
//  ViewController.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import UIKit
import GoogleSignIn
class LoginViewController: UIViewController,GIDSignInUIDelegate{

    @IBOutlet  var signInButton: GIDSignInButton!
    var signOut = UIButton(type: UIButton.ButtonType.system)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.signInDone(notificaton:)), name:  NSNotification.Name( Keys.googleLogin), object: nil)

        setUpUI()
        
        
    }
    @objc func signInDone(notificaton:Notification){
        toggleSignInSignOutUI()

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

