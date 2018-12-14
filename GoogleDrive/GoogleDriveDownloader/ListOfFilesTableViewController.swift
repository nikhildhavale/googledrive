//
//  ListOfFilesTableViewController.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/13/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
class ListOfFilesTableViewController: UITableViewController,GIDSignInDelegate, GIDSignInUIDelegate {
   // var service = GTLRDriveService()
    var fileArray = [GTLRDrive_File]()
    var authoriser:GTMFetcherAuthorizationProtocol?
    var pageToken:String? = ""
    var shouldPaginate = false
    var currentFolderId: String = "" // root
    {
        didSet{
            if currentFolderId.count > 0 {
                gtlQuery()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()

    }
    
    func setUpUI(){
        self.tableView.register(UINib(nibName: "FileItemTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.fileItemIdentifier)
        self.tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.loadingIdentifier)
        self.tableView.tableFooterView = UIView()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = Google.scopes
    }
    func gtlQuery(){
        // GTLRDriveQuery_FilesGet
        // let query = GTLRQuery
        fileArray.removeAll()
        let query =  GTLRDriveQuery_FilesList.query()
        query.pageSize = 50
        if currentFolderId == "" { // Root
            query.q = "trashed=false"
        } else {
            query.q = "'\(currentFolderId)' in parents and trashed=false"
        }
        query.fields = "nextPageToken,files(id, mimeType, name, parents, createdTime, size)"
        query.pageToken = pageToken
    
        GoogleSignInShared.shared.gtlDriveService.executeQuery(query, completionHandler: {(ticket,files,error) in
            self.shouldPaginate = ticket.shouldFetchNextPages
            if  let fileList = files as? GTLRDrive_FileList {
            
                if (self.pageToken?.count == 0){
                    self.fileArray = fileList.files ?? [GTLRDrive_File]()

                }
                else {
                    self.fileArray.append(contentsOf:fileList.files ?? [GTLRDrive_File]() )
                }
                self.pageToken = fileList.nextPageToken
                
                self.tableView.reloadData()
            }
            
        })
    }
    func clearFileList(){
        self.fileArray.removeAll()
        self.tableView.reloadData()

    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AlertMessage.folderMimeType != self.fileArray[indexPath.row].mimeType {
            self.parent?.performSegue(withIdentifier: Identifiers.showDetails, sender: self.fileArray[indexPath.row])

        }
        else{
            self.parent?.performSegue(withIdentifier: Identifiers.showFolderContent, sender: self.fileArray[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  pageToken != nil {
            return self.fileArray.count + 1 

        }
        else {
            return self.fileArray.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.fileArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.fileItemIdentifier, for: indexPath) as! FileItemTableViewCell
            let file = self.fileArray[indexPath.row]
            cell.fileNameLabel.text = file.name
            if AlertMessage.folderMimeType == file.mimeType  {
                
                cell.fileIconImageView.image = UIImage(named: "folder")
                
                
            }
            else {
                cell.fileIconImageView.image = UIImage(named: "fileimage");
                
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.loadingIdentifier, for: indexPath) as! LoadingTableViewCell
            cell.loadingView.startAnimating()
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is LoadingTableViewCell  && self.fileArray.count != 0 {
            gtlQuery()
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            GoogleSignInShared.shared.gtlDriveService.authorizer = nil
            print(error)
            
        } else {
            GoogleSignInShared.shared.gtlDriveService.authorizer = user.authentication.fetcherAuthorizer()
            if let parent = self.parent as? LoginViewController {
                parent.toggleSignInSignOutUI()
            }
            self.gtlQuery()
            
            //navigationItem.rightBarButtonItem = logoutButton
            
        }
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
