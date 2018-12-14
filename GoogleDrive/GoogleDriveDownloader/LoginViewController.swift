//
//  LoginViewController.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/13/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class LoginViewController: UIViewController {
    var signInButton = UIButton(type: UIButton.ButtonType.system)
    var signOut = UIButton(type: UIButton.ButtonType.system)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if GIDSignIn.sharedInstance()!.hasAuthInKeychain(){
            GIDSignIn.sharedInstance()?.signInSilently()
            toggleSignInSignOutUI()
        }
    }


    /// This function does inital ui setup
    func setUpUI(){
        signInButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        signOut.addTarget(self, action: #selector(signOutClicked), for: .touchUpInside)
        signOut.setTitle("Sign Out", for: .normal)
        signOut.tintColor = UIColor.blue
        signInButton.tintColor = UIColor.blue
        signInButton.setTitle("Sign In", for: .normal)

        toggleSignInSignOutUI()
        
    }
    /// This function changes UI for sign out and sign in
    func toggleSignInSignOutUI(){
        if !GIDSignIn.sharedInstance()!.hasAuthInKeychain() {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signInButton)
            
        }
        else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)
           // refreshListOfFiles()
            
        }
    }
    /// This function changes performs signout
    @objc func signOutClicked(){
        GIDSignIn.sharedInstance().signOut()
        for child in self.childViewControllers {
            if let listOfFilesController = child as? ListOfFilesTableViewController {
                listOfFilesController.clearFileList()
                break
            }
        }
        toggleSignInSignOutUI()
        
    }
    /// This function changes performs login
    @objc func loginButtonClicked(){
        if GIDSignIn.sharedInstance()!.hasAuthInKeychain(){
            GIDSignIn.sharedInstance()?.signInSilently()
        }
        else{
            GIDSignIn.sharedInstance()?.signIn()
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let file = sender as? GTLRDrive_File {
            if let destination = segue.destination as? ListOfFilesTableViewController {
                destination.currentFolderId = file.identifier ?? "" 
            }
            else if let destination = segue.destination as? FileDetailViewController {
                destination.file = file
            }
            
            
        }
    }
 

}
