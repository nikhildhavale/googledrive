//
//  Constant.swift
//  GoogleDrive
//
//  Created by Nikhil Modi on 12/10/18.
//  Copyright © 2018 Nikhil Dhavale. All rights reserved.
//

import Foundation
struct Google {
    static let clientId = "642109055015-4icuhs4tvlikh1j0t81nqkfv8upt1ruo.apps.googleusercontent.com"
    static let scope = "https://www.googleapis.com/auth/drive"
    static let listOfFiles = "https://www.googleapis.com/drive/v3/files?key="
    static let redirectURI = "com.googleusercontent.apps.642109055015-4icuhs4tvlikh1j0t81nqkfv8upt1ruo:/oauth2redirect/google"
}
struct Keys {
    static let googleLogin = "loginSucessful"
    static let userInfo = "userInfo"

}
struct Identifiers {
    static let fileItemIdentifier = "fileItemIdentifier"
}
