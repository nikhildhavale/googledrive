//
//  FileDetailViewController.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/14/18.
//  Copyright © 2018 Bá Anh Nguyễn. All rights reserved.
//

import UIKit
import SafariServices
import GoogleAPIClientForREST
class FileDetailViewController: UIViewController {
    var file:GTLRDrive_File?
    @IBOutlet weak var buttonToDownloadOrView: UIButton!

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var fileName: UILabel!
    var fileExists = false
    var destinationURL:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpUI()
    }
    func setUpUI(){
        fileName.text = file?.name
        if let driveFile = file {
            
            guard  let mimeType = driveFile.mimeType, let fileIdentifier =  driveFile.identifier else {
                return
            }
            guard let fileExtension  = mimeType.components(separatedBy: "/").last else{
                return
            }
            
            let document = URL(fileURLWithPath: FileSystem.documentDirectory)
            destinationURL = document.appendingPathComponent(fileIdentifier + "." + fileExtension)
            do {
                fileExists = try destinationURL?.checkResourceIsReachable() ?? false
                self.changeButtonTitle()
            }
            catch{
                
            }
            
            
        }
    }
    func changeButtonTitle(){
        if fileExists {
            buttonToDownloadOrView.setTitle("View", for: .normal)
        }
        else{
            buttonToDownloadOrView.setTitle("Download", for: .normal)
            
        }
    }
    @IBAction func viewOrDownloadButtonClicked(_ sender: Any) {
        if !fileExists {
            downloadFile()
            buttonToDownloadOrView.isEnabled = false
        }
        else {
            if let url = destinationURL {
                self.performSegue(withIdentifier: Identifiers.showActualFile, sender: url)
            }
        }
    }
    func downloadFile(){
        if let driveFile = file {
            guard  let fileIdentifier =  driveFile.identifier else {
                return
            }
            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileIdentifier)
            GoogleSignInShared.shared.gtlDriveService.executeQuery(query, completionHandler: {(ticket,gtlrData,error) in
                if let gtlrDataObject = gtlrData as? GTLRDataObject {
                    if let url = self.destinationURL {
                        do {
                          try  gtlrDataObject.data.write(to: url)
                            self.fileExists = true
                            self.changeButtonTitle()
                        }
                        catch{
                            print(error)
                        }
                        self.buttonToDownloadOrView.isEnabled = true
                    }
                }
            })
            
        }
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController {
            if let rootController = destination.topViewController as? WebViewController {
                rootController.destinationURL = destinationURL
            }
            
        }
    }
 

}
