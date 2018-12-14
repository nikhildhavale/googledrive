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

    }
    func refreshListOfFiles(){
        for child in self.childViewControllers {
            if let listOfFilesController = child as? ListOfFilesTableViewController {
                listOfFilesController.gtlQuery()
                break
            }
        }
    }
    @objc func signInDone(notificaton:Notification){
        toggleSignInSignOutUI()
        refreshListOfFiles()
        
    }

    func setUpUI(){
        signInButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        signOut.addTarget(self, action: #selector(signOutClicked), for: .touchUpInside)
        signOut.setTitle("Sign Out", for: .normal)
        signOut.tintColor = UIColor.blue
        signInButton.tintColor = UIColor.blue
        signInButton.setTitle("Sign In", for: .normal)

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
