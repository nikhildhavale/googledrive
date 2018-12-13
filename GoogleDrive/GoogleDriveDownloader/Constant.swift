//
//  Constant.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/13/18.
//  Copyright © 2018 Bá Anh Nguyễn. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
struct Google {
    static let scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile]
}
struct Keys {
    static let googleLogin = "loginSucessful"
    static let userInfo = "userInfo"
    
}
struct Identifiers {
    static let fileItemIdentifier = "fileItemIdentifier"
}
