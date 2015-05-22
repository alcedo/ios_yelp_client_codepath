//
//  PhotoDetailViewController.swift
//  codepath_wk1e1
//
//  Created by Victor Liew on 5/3/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var imageHolder: UIImageView?
    
    init(initWithUIImageView uiImage: UIImageView) {
        self.imageHolder = uiImage
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        if let image = self.imageHolder {
            self.view.addSubview(image)
        }
        // Do any additional setup after loading the view.
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
