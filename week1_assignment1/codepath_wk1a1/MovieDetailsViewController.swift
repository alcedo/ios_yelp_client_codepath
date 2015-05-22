//
//  MovieDetailsViewController.swift
//  codepath_wk1a1
//
//  Created by Victor Liew on 5/6/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movieImageUrl: NSURL?
    var movieSynopsisText: String?
    
    var image: UIImageView?
    var synopsis: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    func setUpView() {
        self.view.backgroundColor = UIColor.whiteColor()
        // set up movie IMG
        if let url = self.movieImageUrl {
            self.image = UIImageView()
            self.image!.setImageWithURL(url)
        }
        
        if let img = self.image {
            self.view.addSubview(self.image!)
            img.snp_makeConstraints{ (make) -> Void in
                make.width.equalTo(self.view.snp_width)
                make.height.equalTo(300)
                if let nvc = self.navigationController {
                    let navigationBarHeight: CGFloat = nvc.navigationBar.frame.height
                    make.top.equalTo(self.view.snp_top).offset(navigationBarHeight)
                }
                return
            }
        }
        
        // Make movie synopsis caption text
        self.synopsis = UITextView()
        if let synopsis = self.synopsis {
            self.view.addSubview(synopsis)
            synopsis.text = self.movieSynopsisText
            synopsis.font = UIFont(name: "Arial", size: 28)
            
            synopsis.snp_makeConstraints{ (make) -> Void in
                make.top.equalTo(self.image!.snp_bottom).offset(20)
                make.width.equalTo(self.view.snp_width)
                make.bottom.equalTo(self.view.snp_bottom)
                return
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
