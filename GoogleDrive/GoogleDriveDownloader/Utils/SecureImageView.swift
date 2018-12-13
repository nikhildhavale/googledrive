//
//  SecureImageView.swift
//  Edition
//
//  Created by Nikhil Dhavale on 17/07/15.
//  Copyright (c) 2015 Nikhil Dhavale. All rights reserved.
//

import UIKit
import Foundation
protocol SecureImageViewDelegate:class{
    //Not used for now
    func secureImageDidLoad(_ indexPath:IndexPath)
}
protocol DownloadingCompletedDelegate:class{
    // The callback informs the delegate that image is downloaded
    func downloadCompleted(_ complete:Bool,index:Int?)
}
protocol ImageSetDelegate:class{
    // This is callback to inform the delegate if set that UIImage has been set. This mainly needed since this imageview has code to download uiimage
    func imageIsSet()
}
struct ImageTag {
    static  let spinnyTag = 5555
    static let buttonTag = 100
    static let progressViewTag = 2000
    static let imageDownloaded = "ImageDownloaded"

}
class SecureImageView: UIImageView,IconDownloaderDelegate {
    var filename:String?
    var shouldSaveToDisk = true
    var index:String = "-1"
    var progressView:UIProgressView?
    var indexPath:IndexPath?
    var renderMode = UIImage.RenderingMode.automatic
    override var image:UIImage? {
        didSet{
            if image != nil {
                
               // self.contentMode = .scaleAspectFit
                self.removeActivityIndicator()
                self.removeButton()
              //  print("image aspect ratio \(image!.size.width/image!.size.height)")
                DispatchQueue.main.async{
                    if oldValue == nil  {
                        self.delegateImageSet?.imageIsSet()
                        if self.progressView != nil  {
                        self.progressView?.superview?.isHidden = true
                        }
                    }
                }

            }
        }
    }

    weak var delegateImageSet:ImageSetDelegate?
    weak var  delegate:DownloadingCompletedDelegate?
   // lazy var progressView:CustomProgressView = CustomProgressView()
    /// This function set image if available else if sends request from server
    func getImageWithImageId(_ idForImage:String? ,shouldSaveToDisk:Bool){
        self.removeButton()
        self.shouldSaveToDisk = shouldSaveToDisk
        if idForImage != nil  {
            self.filename = idForImage
            let imageName = idForImage?.replacingOccurrences(of: "/", with: "")
            let path = ImageCache.cacheDirectory + "/\(imageName!)"
            if let image  = ImageCache.cachedImageWithContentsOfFile(path, withImage: nil,shouldSaveToDisk: shouldSaveToDisk) {
                if Thread.isMainThread{
                    self.removeActivityIndicator()
                    self.image=image.withRenderingMode(self.renderMode)
                }else{
                    DispatchQueue.main.async{
                        self.removeActivityIndicator()
                        
                        self.image=image.withRenderingMode(self.renderMode)
                    }
                }

                self.removeActivityIndicator()
                self.setNeedsLayout()
            }
            else if   idForImage != nil{
            
                self.addActivityIndicator()
              //  self.image=nil
                if idForImage!.range(of: "magnified") != nil{
                    print("download started \(String(describing: idForImage))")
                }
              conditionallyUseIconDownloader()
                // image is nil 
               // Thus try to check if image exist in regular interval
                self.perform( #selector(SecureImageView.setImageWithInterval), with: nil, afterDelay: 5)
            }
            
        }else{
            self.filename = nil
            self.image = nil
            self.removeActivityIndicator()
            self.setNeedsLayout()
        }
    }
    @objc func setImageWithInterval (){
       
                DispatchQueue.main.async{
                if self.filename != nil {
                        if let image  = ImageCache.cachedImageWithContentsOfFile(self.filename!, withImage: nil,shouldSaveToDisk: self.shouldSaveToDisk) {

                        self.removeActivityIndicator()
                        self.image=image
                     
                        }
                        else{
                            self.perform( #selector(SecureImageView.setImageWithInterval), with: nil, afterDelay: 5)
  
                        }
                    }
                }
            
        
    }
    func appImageDidLoad(_ url: String, WithError error: NSError?) {
        if error != nil {
            self.removeActivityIndicator()
        }else{
                if self.filename != nil {
                if let image:UIImage = ImageCache.cachedImageWithContentsOfFile(filename!, withImage: nil,shouldSaveToDisk: shouldSaveToDisk) {
                    NotificationCenter.default.post(name: Notification.Name(ImageTag.imageDownloaded), object: nil)
                    DispatchQueue.main.async{
                        self.removeActivityIndicator()
                        self.image=image.withRenderingMode(self.renderMode)
                        self.setNeedsLayout()
                        }
                    }
                }
        }
    }
    
  func progress(_ totalBytesWritten:Int64,totalBytesExpectedToWrite:Int64,url:String)
    {
        if self.filename == url {
            /// For some reason the progressview was becoming nil and this code is reused so there was an issue so two conditions
            if ( progressView == nil && index != "-1"){
                if let progressView =   superview?.viewWithTag(ImageTag.progressViewTag){
                    if progressView is UIProgressView {
                        self.progressView = progressView as? UIProgressView
                    }
                }
            }
            progressView?.setProgress(Float(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)), animated: false)
        }
    }
    func reloadImage(_ sender:UIButton){
        self.removeButton()
        self.addActivityIndicator()
        conditionallyUseIconDownloader()
    }
    /// This optionally creates IconDownloader to start downloading images.
    func conditionallyUseIconDownloader(){
        if let iconDownloader = ImageCache.downloaderCache[filename!]{
            if(iconDownloader.delegate == nil){
            iconDownloader.delegate = self
            }
            else{
                NotificationCenter.default.addObserver(self, selector: #selector(SecureImageView.imageDownloaded(notification:)), name:  Notification.Name(ImageTag.imageDownloaded), object: nil)
            }
            iconDownloader.shouldSaveToDisk = shouldSaveToDisk
            if iconDownloader.error != nil && iconDownloader.downloadTask?.state != .running && iconDownloader.downloadTask?.state != .completed {
                iconDownloader.startDownload()
            }
        }else{
            let iconDownloader:IconDownloader = IconDownloader()
            iconDownloader.url=filename
            iconDownloader.shouldSaveToDisk = shouldSaveToDisk
            iconDownloader.delegate=self
           _ =  ImageCache .downloaderCache(filename!, andWith: iconDownloader)
            iconDownloader .startDownload()
            
        }
    }
    @objc func imageDownloaded(notification:Notification){
        DispatchQueue.main.async {
            let  image  = ImageCache.cachedImageWithContentsOfFile(self.filename!, withImage: nil,shouldSaveToDisk: false)
            self.image = image?.withRenderingMode(self.renderMode)
        }
    }
    func setColorToBorderAndBackground(){
//        let color = UIColor(rgba:"#d3d1d1")
//      //  self.backgroundColor = color
//        self.layer.borderColor = color.cgColor
//        self.layer.borderWidth = 1.0
    }

    func callAppImageDidLoad(_ userInfo:Timer?){
        self.appImageDidLoad(filename!, WithError: nil)
      //  self.delegate?.downloadCompleted()
    }
    let initialLabel = UILabel()

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func addActivityIndicator(){

    }
    //// Make the view circular
    func configureView() {
        self.layer.cornerRadius = self.frame.size.width / 2

    }
/// This function removes activity indicator hne called
    func removeActivityIndicator(){
        for view in subviews{
            if view is UIActivityIndicatorView{
                view.removeFromSuperview()
            }
        }
    }
    
    func removeButton(){
        if let button = self.viewWithTag(ImageTag.buttonTag) as? UIButton{
            button.removeFromSuperview()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
