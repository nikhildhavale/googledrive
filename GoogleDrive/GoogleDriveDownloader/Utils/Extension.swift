//
//  Extension.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit
extension UserDefaults{
    static func saveCustomObject(obj:Any,for key:String){
            let ecodedObject =  NSKeyedArchiver.archivedData(withRootObject: obj)
            self.standard.set(ecodedObject, forKey: key)
 

    }
    static func getCustomObjectfor(Key:String)->Any?{
        guard let encodedObject = self.standard.object(forKey: Key) as? Data else {
            return nil
        }
       return NSKeyedUnarchiver.unarchiveObject(with: encodedObject)
    }
}
extension Data {
    func converDataToString() -> String{
        return String(data: self, encoding: .utf8) ?? ""
    }
}

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
