//
//  ListOfFilesTableViewController.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
// https://stackoverflow.com/questions/46210827/google-drive-api-ios-permissions-of-gtlrdriveservice

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
class ListOfFilesTableViewController: UITableViewController {
    var fileArray = [GTLRDrive_File]()
    var authoriser:GTMFetcherAuthorizationProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        GoogleSignInShared.shared.gtlDriveService.apiKey = GoogleSenstive.driveAPIKey
        
    }
    
    func setUpUI(){
        self.tableView.register(UINib(nibName: "FileItemTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.fileItemIdentifier)
        self.tableView.tableFooterView = UIView()

    }
    func gtlQuery(){
       // GTLRDriveQuery_FilesGet
       // let query = GTLRQuery
        
      let query =  GTLRDriveQuery_FilesList.query()
        GoogleSignInShared.shared.gtlDriveService.apiKey = GoogleSenstive.driveAPIKey
     //   query.corpora = "user"
//        query.teamDriveId = GoogleSignInShared.shared.user?.userID
//        query.includeTeamDriveItems = true
 //       gtlDriveService.authorizer = GoogleSignInShared.shared.user?.authentication.fetcherAuthorizer()
//        if let userProfile = UserDefaults.getCustomObjectfor(Key: Keys.userInfo) as? GoogleUserProfile{
//            query.includeTeamDriveItems = true
//            query.teamDriveId = userProfile.id
//
//        }
//        query.fields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)"
       // authoriser = GIDSignIn.sharedInstance()?.currentUser.authentication.fetcherAuthorizer()
      //  GoogleSignInShared.shared.gtlDriveService.authorizer = authoriser
        GoogleSignInShared.shared.gtlDriveService.executeQuery(query, completionHandler: {(ticket,files,error) in
            if  let fileList = files as? GTLRDrive_FileList {
                self.fileArray.removeAll()
                self.fileArray = fileList.files ?? [GTLRDrive_File]()
                self.tableView.reloadData()
            }
            print(error)
            
        })
    }
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fileArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.fileItemIdentifier, for: indexPath) as! FileItemTableViewCell

        cell.fileNameLabel.text = self.fileArray[indexPath.row].name

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
