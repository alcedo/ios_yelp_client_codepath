//
//  ViewController.swift
//  codepath_wk1_e1storyboard
//
//  Created by Victor Liew on 5/6/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var photos = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        var clientId = "6943d041e2bf4e99955bd465f081baf9"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as NSArray
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("instagramPhotoCell", forIndexPath: indexPath) as PrototypeTableViewCell
        if let images = self.photos[indexPath.row]["images"] as? NSDictionary {
            let url = images["low_resolution"]!["url"] as String
            cell.photoImage.setImageWithURL(NSURL(string: url))
        }
        
        if let caption =  self.photos[indexPath.row]["caption"] as? NSDictionary {
            let captionText = caption["text"]! as String
            cell.photoTitle.text = captionText
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var vc = segue.destinationViewController as PhotoDetailViewController
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        
        if let indexPath = indexPath {
            if let images = self.photos[indexPath.row]["images"] as? NSDictionary {
                let url = images["low_resolution"]!["url"] as String
                vc.detailedPhotoImageUrl = NSURL(string: url)
            }
        }
        
        
    }
}

