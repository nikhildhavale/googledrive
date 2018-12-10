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
        do{
            let ecodedObject = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
            self.standard.set(ecodedObject, forKey: key)
        }
        catch{
            
        }

    }
    static func getCustomObjectfor(Key:String)->Any?{
        guard let encodedObject = self.standard.object(forKey: Key) as? Data else {
            return nil
        }
        do{
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedObject)

        }
        catch{
            
        }
            return nil
        
    }
}
