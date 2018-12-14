//
//  Extension.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit
/// This extension provide covience to convert data to string
extension Data {
    func converDataToString() -> String{
        return String(data: self, encoding: .utf8) ?? ""
    }
}
/// This is needed in UIAlert
extension UIApplication {
    
    var frontmostViewController: UIViewController? {
        let window = UIApplication.shared.keyWindow
        var viewController = window!.rootViewController
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        
        return viewController
    }
    
    func openSystemSettings() {
        // openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
/// This is provide convienence to sow alerts.
extension UIViewController{
    func showAlertOK(title:String,message:String){
        print("show alert \(message)")
        showAlertOk(title: title, message: message,alertAction:nil)
    }
    func showAlertOk(title:String,message:String,alertAction:UIAlertAction?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if alertAction == nil {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        else{
            alertController.addAction(alertAction!)
            
        }
        
        if UIApplication.shared.frontmostViewController?.presentedViewController == nil {
            UIApplication.shared.frontmostViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
