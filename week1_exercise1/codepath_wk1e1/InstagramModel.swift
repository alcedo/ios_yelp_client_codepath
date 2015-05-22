//
//  InstagramModel.swift
//  codepath_wk1e1
//
//  Created by Victor Liew on 5/3/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import Foundation
import Alamofire


class InstagramModel {
    
    func getPopular(callback: (AnyObject?)->Void) {
        let api = "https://api.instagram.com/v1/media/popular"
        Alamofire.request(Alamofire.Method.GET, api,
            parameters: ["client_id":"6943d041e2bf4e99955bd465f081baf9"])
            
            .responseJSON{ (request, response, data, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(request)
                    println(response)
                }else {
                    callback(data)
                }
            }
        
        
        
    }
    
   
}
