//
//  RTmodel.swift
//  codepath_wk1a1
//
//  Created by Victor Liew on 5/5/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import Foundation
import AFNetworking

class RTmodel: NSObject {

    var boxOfficeData: NSDictionary?
    
    func getBoxOffice(callBack: (AnyObject?)-> Void, errorCallBack: (AnyObject?) -> Void) {
//        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=3&country=us&apikey=f2fk8pundhpxf77fscxvkupy"
        
        // use this so as to not spam api server
        let url = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
        
        let manager = AFHTTPRequestOperationManager()
        let request = AFJSONRequestSerializer().requestWithMethod("GET", URLString: url, parameters: nil, error: nil)
        let op = AFHTTPRequestOperation(request: request)
        op.responseSerializer = AFJSONResponseSerializer()
        // github response with a text/plain, so we have to inform AFNetworking that this is ok.
        op.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
        op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, dataObject) -> Void in
            self.boxOfficeData = dataObject as? NSDictionary
            callBack(dataObject)
        }, failure: {
            (operation, error)-> Void in
            println("Error in RTmodel, getBoxoffice: \(error)")
            errorCallBack(error)
        })
        
        NSOperationQueue.mainQueue().addOperation(op)
    }
    
    func getBoxOfficeDataCount() -> Int {
        if let data = self.boxOfficeData {
            return data["movies"]!.count
        }
        
        return 0
    }
    
    func getBoxOfficeSynopsisForIndex(idx: Int) -> String {
        let synopsis = self.boxOfficeData!["movies"]![idx]["synopsis"] as! String
        return synopsis
        
    }
    
    func getBoxOfficeMovieTitleForIndex(idx: Int) -> String {
        let title = self.boxOfficeData!["movies"]![idx]["title"] as! String
        return title
    }
    
    func getBoxOfficeThumbUrlForIndex(idx: Int) -> NSURL {
        let posterJson = self.boxOfficeData!["movies"]![idx]["posters"] as? NSDictionary
        let posterUrl = posterJson!["thumbnail"] as! String
        return NSURL(string: posterUrl)!
    }
    
    func getBoxOfficeHighResForIndex(idx: Int) -> NSURL {
        // return the same thing for now, since the API doesnt have high res images.
        return self.getBoxOfficeThumbUrlForIndex(idx)
    }
    
    
    func getTopDvds(callBack: (AnyObject?)-> Void) {
//        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=16&page=1&country=us&apikey=f2fk8pundhpxf77fscxvkupy"
        
        let url = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer();
        manager.GET(url, parameters: nil, success: {(operation, responseObject) -> Void in
            callBack(responseObject)
        }, failure: nil)
    }
}