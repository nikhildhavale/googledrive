//
//  Constant.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
struct Google {
    static let clientId = "1095264136507-g9mec4bd2bgq1ut8oofi2dhvdloice9i.apps.googleusercontent.com"
    static let scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile]
    static let listOfFiles = "https://www.googleapis.com/drive/v3/files?key="
    static let redirectURI = "com.googleusercontent.apps.1095264136507-g9mec4bd2bgq1ut8oofi2dhvdloice9i/google"
}
struct Keys {
    static let googleLogin = "loginSucessful"
    static let userInfo = "userInfo"

}
struct Identifiers {
    static let fileItemIdentifier = "fileItemIdentifier"
}
