//
//  HTTPRequest.swift
//  AsyncImages
//
//  Created by Spencer Kohan on 12/2/14.
//  Copyright (c) 2015 Spencer Kohan. All rights reserved.
//

import UIKit

//NSURLConnection wrapper to provide closure-based response handling

typealias RequestFunc = (request: HTTPRequest) -> ()
typealias RequestErrorFunc = (request: HTTPRequest, error: NSError) -> ()

class HTTPRequest: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {

    //request configuration parameters
    var urlString: NSString?
    var body: NSData?
    var method: NSString = "GET"
    
    //response and failure callbacks
    var onFinish: RequestFunc = {(request: HTTPRequest) in }
    var onFail: RequestErrorFunc = {(request: HTTPRequest, error: NSError) in }
    
    var connection: NSURLConnection?
    var responseData: NSMutableData = NSMutableData()
    
    func start(){
    
        let request = NSMutableURLRequest(URL: NSURL(string: urlString!)!)
        
        //set method
        request.HTTPMethod = method
        
        //start connection
        connection = NSURLConnection(request: request, delegate: self)
        connection?.start()
    
    }
    
    func cancel() {
        connection?.cancel()
    }
    
    func connection( connection: NSURLConnection,
        didReceiveResponse response: NSURLResponse){
    }
    
    func connection( connection: NSURLConnection,
        didReceiveData data: NSData){
        responseData.appendData(data)
    }
    
    func connection( connection: NSURLConnection,
        didFailWithError error: NSError){
        onFail(request: self, error: error)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        onFinish(request: self)
    }
   
}
