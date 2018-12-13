//
//  ImageCache.swift
//  Edition
//
//  Created by Nikhil Dhavale on 17/07/15.
//  Copyright (c) 2015 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit
 

class ImageCache {
    static  var uiImageCache:[String:String] = [String:String]()
  //  static var actualImageCache:[String:UIImage] = [String:UIImage]()
    static  var downloaderCache:[String:IconDownloader] = [String:IconDownloader]()
    static var documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static var cacheDirectory =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    /// This function retirves the image from LocalPath or writes image to local path
    static func cachedImageWithContentsOfFile(_ path:String, withImage image:UIImage?,shouldSaveToDisk:Bool ) ->UIImage?{
        
        if let result = uiImageCache[path]{
            let fileManager = FileManager.default

            if shouldSaveToDisk  && result.range(of: "Document") == nil
            {
                let paths  = documentDirectory
               // paths = paths.stringByAppendingPathComponent(editionId)
                var directory = ObjCBool(true)
                let splitImagePath = path.components(separatedBy: "?")
                let firstString = splitImagePath[0]

                if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
                    do{
                    try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch{
                        
                    }
                }
                let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
                do{
                 try fileManager.copyItem(atPath: result, toPath: filePathToWrite)
                }
                catch{
                    
                }
                uiImageCache.updateValue(filePathToWrite, forKey: path)
            }
            if fileManager.fileExists(atPath: result) {
            return UIImage(contentsOfFile: result)
            }else{
                return nil 
            }
            
        }
        
        return writeToFileSystem(path, image: image,shouldSaveToDisk: shouldSaveToDisk)

        

     


        
        
    }
    static func checkIfFileExist(_ path:String, editionId:String) -> Bool {
        let paths  = cacheDirectory
      return  FileManager.default.fileExists(atPath: paths)
        
    }
    static func deleteFileAtPath(_ path:String, editionId:String)  {
        let paths  = cacheDirectory
        let splitImagePath = path.components(separatedBy: "?")
        let firstString = splitImagePath[0]
        let filePath = "\(paths)/\((firstString as NSString).lastPathComponent)"
        do{
         try   FileManager.default.removeItem(atPath: filePath)
        }
        catch{
            
        }
    }
    static func deleteFileInCache(remoteURL:String){
        let imageName = remoteURL.replacingOccurrences(of: "/", with: "")
        let splitImagePath = imageName.components(separatedBy: "?")
        let firstString = splitImagePath[0]
        let path = ImageCache.cacheDirectory + "/\(firstString)"
        do {
            try FileManager.default.removeItem(atPath: path)
        }
        catch{
            print(error)
        }
    }
    /// This function adds local path of image to ImageCache dictionary
    static func cachedImageWithLocationOfFile(_ path:String, withImage image:URL?,shouldSaveToDisk:Bool , editionId:String){
        if let result = uiImageCache[path]{
            if shouldSaveToDisk  && result.range(of: "Document") == nil
            {
                let fileManager = FileManager.default
                let paths  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                var directory = ObjCBool(true)
                let splitImagePath = path.components(separatedBy: "?")
                let firstString = splitImagePath[0]
                
                if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
                    do{
                        try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch{
                        
                    }
                }
                let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
                do {
                    try fileManager.moveItem(atPath: result, toPath: filePathToWrite)
                    try (URL(fileURLWithPath: filePathToWrite) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
                }
                catch{
                    
                }
                uiImageCache.updateValue(filePathToWrite, forKey: path)
                return
            }
           // return UIImage(contentsOfFile: result)
            
        }
        
         writeToFileSystemWithURL(path, url: image, editionId: editionId,shouldSaveToDisk: shouldSaveToDisk)
        
        
        
        
        
        
        
        
    }
    /// This function does mapping from global path to local path
    static func writeToFileSystemWithURL(_ path:String,url:URL?,editionId:String,shouldSaveToDisk:Bool) {


        let fileManager = FileManager.default
        var paths = ""
        if shouldSaveToDisk{
            paths  = documentDirectory
        }else{
            paths  = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
        var directory = ObjCBool(true)
        
        if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
            do {
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                
            }
        }
        let pathImageName = path.replacingOccurrences(of: "/", with: "")
        let filePathToWrite = "\(paths)/\(pathImageName)"
        
        //
        //Check the file is already present or not.
        if (fileManager.fileExists(atPath: filePathToWrite))
        {
            //   println("FILE AVAILABLE");
            uiImageCache.updateValue(filePathToWrite, forKey: path)
//            if let image = UIImage(contentsOfFile: filePathToWrite) {
//            //    actualImageCache.updateValue(image, forKey: path)
//
//            }
        }
        else if url != nil
        {
            do {
                try fileManager.moveItem(at: url!, to: URL(fileURLWithPath: filePathToWrite))
                try (URL(fileURLWithPath: filePathToWrite) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)

            }
            catch{
                
            }
//            if let image = UIImage(contentsOfFile: filePathToWrite) {
//                actualImageCache.updateValue(image, forKey: path)
//                
//            }
            uiImageCache.updateValue(filePathToWrite, forKey: path)

        }
        //return nil
        
    }
// This function actually writes UIImage to file system it could be document's directory and Cache directory
    static func writeToFileSystem(_ path:String,image:UIImage?,shouldSaveToDisk:Bool) -> UIImage?{

        let fileManager = FileManager.default
        var paths = ""
        if shouldSaveToDisk{
           paths  = documentDirectory
        }else{
          paths  = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
        //paths = paths.stringByAppendingPathComponent(editionId)
        var directory = ObjCBool(true)

        if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
            do{
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
            }
            catch{
                
            }
        }
//        let pathImageName = path.replacingOccurrences(of: "/", with: "")
//        let getImagePath = paths + "/\(pathImageName)"
        //
        //Check the file is already present or not.
        if (fileManager.fileExists(atPath: path))
        {
            uiImageCache.updateValue(path, forKey: path)
            return UIImage(contentsOfFile: path)
        }
        else if image != nil
        {
            autoreleasepool(){
                
                var imageData = UIImagePNGRepresentation(image!)
            do{
                fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
                try (URL(fileURLWithPath: path) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
            }
            catch{
                
            }
            uiImageCache.updateValue(path, forKey: path)
            imageData = nil
            }
            return image
          //  println("writing to imagepath :\(filePathToWrite)")
            // println("FILE NOT AVAILABLE");
        }
        
        return nil

    }
/// It clears the dictionary
    static func clearCache(){
         uiImageCache.removeAll(keepingCapacity: false)
        downloaderCache.removeAll(keepingCapacity: false)
     //   actualImageCache.removeAll()
    }
    /// It removes icondownloads of a path.
    static func removeFromDownloaderCache (_ path : String){
        if downloaderCache.keys.contains(path){
            if  let iconDowloader = downloaderCache.removeValue(forKey: path) {
                iconDowloader.imageConnection?.invalidateAndCancel()
            }
        
        }
        
        
    }
    /// Get the icon downloader if exists or adds the downloader to downloader cache if absent.
    static func downloaderCache(_ path:String, andWith imageDownloader:IconDownloader?) ->IconDownloader?{

        if let image = downloaderCache[path]{
            return image
        }
        else  {
            downloaderCache.updateValue(imageDownloader!, forKey: path)
        }
        return nil
        

    }
}
