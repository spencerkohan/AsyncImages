//
//  ViewController.swift
//  AsyncImages
//
//  Created by Spencer Kohan on 12/2/14.
//  Copyright (c) 2015 Spencer Kohan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let kClientId = "INSTAGRAM_CLIENT_ID"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = HTTPRequest()
        
        request.urlString = NSString(format:"https://api.instagram.com/v1/media/popular?client_id=%@", kClientId)
        request.onFinish = {(request: HTTPRequest) in
        
            let dataString = NSString(data: request.responseData, encoding: NSUTF8StringEncoding)
            
            let response = NSJSONSerialization.JSONObjectWithData(request.responseData, options: nil, error: nil) as NSDictionary
            
            let results = response["data"] as NSArray
            
            self.images = NSMutableArray()
            
            for i in 0...results.count - 1 {
                if let result: NSDictionary = results[i] as? NSDictionary {
                    if let images: NSDictionary = result["images"] as? NSDictionary {
                        if let thumb: NSDictionary = images["thumbnail"] as? NSDictionary {
                            self.images.addObject(thumb["url"]!)
                        }
                    }
                }
            }
            
            NSLog("images: %@", self.images)
            self.collectionView.reloadData()
            
        }
        
        request.start()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let imageView = cell.viewWithTag(1) as UIImageView
        
        let imageURLString = images[indexPath.row] as String
        imageView.setImageWithURLString(imageURLString)
        //imageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
        
        return cell
    
    }


}

