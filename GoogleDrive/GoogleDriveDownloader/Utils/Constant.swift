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
    static let loadingIdentifier = "loadingIdentifier"
    static let showDetails = "showDetail"
    static let showActualFile = "showActualFile"

    static let showFolderContent = "showFolderContent"
}
struct AlertMessage {
    static let selectedItemFolder = "Selected Item is a folder"
    static let folderMimeType = "application/vnd.google-apps.folder"
}
struct FileSystem {
    static let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

}
