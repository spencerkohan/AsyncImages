//
//  UIImageView+Async.swift
//  AsyncImages
//
//  Created by Spencer Kohan on 12/2/14.
//  Copyright (c) 2015 Spencer Kohan. All rights reserved.
//

import UIKit


private let _theCache = URLImageCache()

class URLImageCache: NSObject {
    
    var cachedImages = NSMutableDictionary()
    var imageRequests = NSMutableDictionary()
    
    class var theCache: URLImageCache {
        return _theCache
    }
    
    class func notificationNameForURLString(urlString: NSString) -> NSString {
    
        return NSString(format: "URLImageCacheRequestDidFinish:%@", urlString)
    
    }
    
    func requestImageForURLString(urlString: NSString) -> UIImage? {
        
        if(cachedImages[urlString] != nil){
            return cachedImages[urlString] as? UIImage
        }
        
        if(imageRequests[urlString] == nil){
            
            //request image if no request exists
            let imageRequest = HTTPRequest()
            imageRequest.urlString = urlString
            imageRequest.onFinish = {(request: HTTPRequest) in
                
                let image = UIImage(data: request.responseData)
                self.cachedImages[urlString] = image
                self.imageRequests.removeObjectForKey(urlString)
                NSNotificationCenter.defaultCenter().postNotificationName(URLImageCache.notificationNameForURLString(urlString), object: nil)
                
            }
            imageRequest.start()
            
        }
        
        return nil
        
    }
}

extension UIImageView {
   
    func setImageWithURLString(urlString: NSString){
    
        let image = URLImageCache.theCache.requestImageForURLString(urlString)
        
        if(image != nil){
            self.image = image
        }else{
            NSNotificationCenter.defaultCenter().addObserverForName(URLImageCache.notificationNameForURLString(urlString), object: nil, queue: nil, usingBlock: {(n: NSNotification!) in
            
                self.setImageWithURLString(urlString)
            
            })
        }
    }
    
}
