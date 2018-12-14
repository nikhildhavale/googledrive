//
//  FileDetailViewController.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/14/18.
//  Copyright © 2018 Bá Anh Nguyễn. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
class FileDetailViewController: UIViewController {
    var file:GTLRDrive_File?
    @IBOutlet weak var buttonToDownloadOrView: UIButton!

    @IBOutlet weak var fileName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func viewOrDownloadButtonClicked(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
