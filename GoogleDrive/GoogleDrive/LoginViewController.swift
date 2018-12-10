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
        signInButton.isHidden = true
        signOut.isHidden = false
    }
    func setUpUI(){
        signInButton = GIDSignInButton(frame: CGRect.zero)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        self.view.addSubview(signOut)
        signOut.translatesAutoresizingMaskIntoConstraints = false
        signOut.setTitle("Sign Out", for: .normal)
        signOut.tintColor = UIColor.blue
        signOut.addTarget(self, action: #selector(self.signOutClicked), for: .touchUpInside)
         NSLayoutConstraint.activate([signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                      signOut.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                      signOut.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                                      ])
            signOut.isHidden =  (UserDefaults.standard.object(forKey: Keys.userInfo) == nil)
            signInButton.isHidden = !(UserDefaults.standard.object(forKey: Keys.userInfo) == nil)
        
        
    }
    @objc func signOutClicked(){
        GIDSignIn.sharedInstance().signOut()
        signInButton.isHidden = false
        signOut.isHidden = true
        UserDefaults.standard.removeObject(forKey: Keys.userInfo)
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

