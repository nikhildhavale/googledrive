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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        setUpUI()
        
    }
    func setUpUI(){
        signInButton = GIDSignInButton(frame: CGRect.zero);
        signInButton.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(signInButton)
        NSLayoutConstraint.activate([signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
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

