//
//  Extension.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
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
