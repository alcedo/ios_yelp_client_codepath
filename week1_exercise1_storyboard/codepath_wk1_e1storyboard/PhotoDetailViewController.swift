//
//  PhotoDetailViewController.swift
//  codepath_wk1_e1storyboard
//
//  Created by Victor Liew on 5/6/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var detailedPhotoImage: UIImageView!
    var detailedPhotoImageUrl: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailedPhotoImage.setImageWithURL(self.detailedPhotoImageUrl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        var vc = segue.destinationViewController as PhotoDetailViewController
//        
//    }

}
