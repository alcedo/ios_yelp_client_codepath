//
//  ViewController.swift
//  codepath_wk1e1
//
//  Created by Victor Liew on 5/2/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import Snap
import SwiftyJSON

//http://stackoverflow.com/questions/5714528/difference-between-uitableviewdelegate-and-uitableviewdatasource
class PhotosViewController: UIViewController, UITableViewDelegate {

    var tableView: UITableView?
    var photoDataSource: PhotoTableViewDataSource?
    
    init(initWithDataSource dataSource: PhotoTableViewDataSource) {
        super.init(nibName: nil, bundle: nil);
        self.photoDataSource = dataSource
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupViewStructure()
        self.setupConstrain()
    }
    
    // MARK: - UI View Creations Goes Here
    func setupViewStructure() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, 300, 300), style: .Plain)
        if let tv = self.tableView {
            self.view.addSubview(tv)
            tv.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view.snp_top)
                make.height.equalTo(self.view.snp_height)
                make.width.equalTo(self.view.snp_width)
                return
            }
            
            tv.autoresizesSubviews = true
            tv.dataSource = self.photoDataSource;
            tv.delegate = self;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400.00
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(0, 0, 100, 20))
        label.text = self.photoDataSource!.getUserNameForSectionAtIndexPath(section)
        label.backgroundColor = UIColor.grayColor()
        return label
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let image = self.photoDataSource!.getUIImageViewForSectionAtIndex(indexPath.section)
        let vc = PhotoDetailViewController(initWithUIImageView: image!)
        vc.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(vc, animated: true)
        // remove gray shading upon selection
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Constraints
    func setupConstrain() {
        
    }
    
    func userDidRefreshTableView(refresh: UIRefreshControl) {
        self.photoDataSource?.doLoad(self.tableView!)
        refresh.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Instagram Most Popular"
        self.photoDataSource?.doLoad(self.tableView!)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "userDidRefreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView!.addSubview(refreshControl)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

