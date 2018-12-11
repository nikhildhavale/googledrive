//
//  GoogleUserProfile.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
//
//  UserProfile.swift
//  Amara
//
//  Created by Nikhil Modi on 5/3/17.
//  Copyright © 2017 Nikhil Modi. All rights reserved.
//

import Foundation
struct UserProfileKey {
  
    static let tokenKey = "token"
    static let idKey = "id"
    static let userEmailKey = "userEmail"
    static let firstName = "firstName"
    static let familyName = "familyName"
    static let authCode = "authCode"
    static let oAuthToken = "oAuthToken"
    
}
@objc(UserProfile)
class GoogleUserProfile:NSObject,NSCoding,Codable{
    var token:String?
    var id:String?
    var userEmail:String?
    var firstName:String?
    var familyName:String?
    var authCode:String?
    var oAuthToken:String?
    
    override init() {
        
    }
    func encode(with aCoder: NSCoder){
       
        aCoder.encode(token, forKey: UserProfileKey.tokenKey)
        aCoder.encode(id, forKey: UserProfileKey.idKey)
        aCoder.encode(userEmail, forKey: UserProfileKey.userEmailKey)
        aCoder.encode(familyName, forKey: UserProfileKey.familyName)
        aCoder.encode(firstName, forKey: UserProfileKey.firstName)
        aCoder.encode(authCode, forKey: UserProfileKey.authCode)
        aCoder.encode(oAuthToken, forKey: UserProfileKey.oAuthToken)

    }
    required init?(coder aDecoder: NSCoder) {
      
        token = aDecoder.decodeObject( forKey: UserProfileKey.tokenKey) as? String
        id = aDecoder.decodeObject( forKey: UserProfileKey.idKey) as? String
        userEmail =   aDecoder.decodeObject( forKey: UserProfileKey.userEmailKey) as? String
        firstName = aDecoder.decodeObject(forKey:UserProfileKey.firstName) as? String
        familyName = aDecoder.decodeObject(forKey:UserProfileKey.familyName) as? String
        authCode = aDecoder.decodeObject(forKey:UserProfileKey.authCode) as? String
        oAuthToken = aDecoder.decodeObject(forKey:UserProfileKey.oAuthToken) as? String
    }
    
}
