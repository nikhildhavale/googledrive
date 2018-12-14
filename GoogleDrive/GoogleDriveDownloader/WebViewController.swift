//
//  WebViewController.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/14/18.
//  Copyright © 2018 Bá Anh Nguyễn. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    var destinationURL:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        let wKWebView = WKWebView(frame: CGRect.zero)
        if let url = destinationURL {
            wKWebView.load(URLRequest(url: url))
            wKWebView.translatesAutoresizingMaskIntoConstraints = false
            self.view .addSubview(wKWebView)
            NSLayoutConstraint.activate([wKWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),wKWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),wKWebView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),wKWebView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)])
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
