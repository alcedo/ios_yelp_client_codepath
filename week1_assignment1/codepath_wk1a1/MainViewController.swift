//
//  ViewController.swift
//  codepath_wk1a1
//
//  Created by Victor Liew on 5/2/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import Snap
import SVProgressHUD

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var boxOfficeModel = RTmodel()
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    var errorHud: UIView?
    var refreshControl: UIRefreshControl?
    var layoutControl: UISegmentedControl?
    
    var searchController: UISearchDisplayController!
    
    let ERROR_HUD_TAG = 1
    let TABLE_VIEW_TAG = 2
    let COLLECTION_VIEW_TAG = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show loading spinner
        SVProgressHUD.show()
        
        self.title = "Rotten Tomatoes"
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Load box office List
        self.boxOfficeModel.getBoxOffice({ (data) -> Void in
            SVProgressHUD.dismiss()
            self.tableView!.reloadData()
            self.collectionView!.reloadData()
            self.hideErrorHud()
        }, errorCallBack: {(error) -> Void in
            self.showErrorHud()
        })
        
        self.setupView()
        self.hideErrorHud()
    }
    
    func setupView() {
        // Segmented control
        self.layoutControl = UISegmentedControl(items: ["Table", "Grid"])
        if let sc = self.layoutControl {
            self.view.addSubview(sc)
            
            sc.snp_makeConstraints{ (make) -> Void in
                let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
                make.top.equalTo(self.view.snp_top).offset(navigationBarHeight + 30)
                make.centerX.equalTo(self.view.snp_centerX)
                make.height.equalTo(30)
                make.width.equalTo(160)
                return
            }
            sc.addTarget(self, action: "didSelectLayoutChange:", forControlEvents: .ValueChanged);
            sc.selectedSegmentIndex = 0
        }
        
        // Add table view
        self.tableView = UITableView(frame: CGRectMake(0, 0, 100, 100), style: .Plain)
        if let tv = self.tableView {
            tv.hidden = false
            tv.tag = TABLE_VIEW_TAG
            self.view.addSubview(tv)
            
            tv.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.layoutControl!.snp_bottom).offset(5)
                make.height.equalTo(self.view.snp_height)
                make.width.equalTo(self.view.snp_width)
                return
            }
            
            tv.delegate = self
            tv.dataSource = self
        }
        
        
        // add a search bar
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 44))
        searchBar.delegate = self
        self.tableView?.tableHeaderView = searchBar
        self.searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        self.searchController.searchResultsDataSource = self
        self.searchController.searchResultsDelegate = self
        self.searchController.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "photo_cell_identifier")
        
        // Add collection view 
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.frame,
            collectionViewLayout: collectionViewFlowLayout)
        
        if let cv = self.collectionView {
            cv.tag = COLLECTION_VIEW_TAG
            cv.backgroundColor = UIColor.whiteColor()
            cv.hidden = true
            cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
            self.view.addSubview(cv)
            
            cv.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.layoutControl!.snp_bottom).offset(5)
                make.height.equalTo(self.view.snp_height)
                make.width.equalTo(self.view.snp_width)
                return
            }
            
            cv.dataSource = self
            cv.delegate = self
        }
        
        // Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "userDidRefreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        // Add network error messsages
        let errorHud = UIView(frame: CGRectMake(0, 0, 0, 0))
        errorHud.tag = self.ERROR_HUD_TAG
        self.view.addSubview(errorHud)
        self.errorHud = errorHud
        errorHud.backgroundColor = UIColor.redColor()
        errorHud.snp_makeConstraints { (make) -> Void in
            if let nvc = self.navigationController {
                let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
                let errorHudHeight = 20
                make.top.equalTo(self.view.snp_top).offset(navigationBarHeight + 20)
                make.width.equalTo(self.view.snp_width)
                make.height.equalTo(errorHudHeight)
            }
            return
        }
        
        // errorHud label
        let errorHudLabel = UILabel()
        errorHudLabel.text = "Network Error, please try again"
        errorHudLabel.sizeToFit()
        errorHud.addSubview(errorHudLabel)
        
        
    }
    
    func hideErrorHud() {
        // we can refer to self.errorHud too, but for learning sake, im doing this
        let hud = self.view.viewWithTag(self.ERROR_HUD_TAG)
        if let hud = hud {
            hud.hidden = true
        }
    }
    
    func showErrorHud() {
        if let hud = self.errorHud {
            hud.hidden = false
        }
    }
    
    func userDidRefreshTableView(refresh: UIRefreshControl) {
        self.boxOfficeModel.getBoxOffice({ (data) -> Void in
            self.tableView!.reloadData()
            refresh.endRefreshing()
            self.hideErrorHud()
        }, errorCallBack: {(error) -> Void in
            refresh.endRefreshing()
            self.showErrorHud()
        })
    }
    
    func didSelectLayoutChange(sender: UISegmentedControl) {
        if sender == self.layoutControl {
            let selected = sender.selectedSegmentIndex
            let layout = sender.titleForSegmentAtIndex(selected)
            
            if layout == "Table" {
                self.tableView!.hidden = false
                self.collectionView!.hidden = true
            }
            
            if layout == "Grid" {
                self.tableView!.hidden = true
                self.collectionView!.hidden = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Delegates
    
    //MARK: Data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boxOfficeModel.getBoxOfficeDataCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if tableView == self.tableView {
//            println(tableView)
//        }
//        if tableView != self.tableView {
//            println(tableView)
//        }
        let cellIdentifier = "photo_cell_identifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if let cell = cell {
            let data = NSData(contentsOfURL: self.boxOfficeModel.getBoxOfficeThumbUrlForIndex(indexPath.row))
            if let data = data {
                cell.imageView?.image = UIImage(data: data)
                cell.textLabel?.text = self.boxOfficeModel.getBoxOfficeMovieTitleForIndex(indexPath.row)
                cell.detailTextLabel?.text = self.boxOfficeModel.getBoxOfficeSynopsisForIndex(indexPath.row)
                return cell
            }
        }
        
        return UITableViewCell() // return empty cell if all else fails
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = MovieDetailsViewController()
        vc.movieSynopsisText = self.boxOfficeModel.getBoxOfficeSynopsisForIndex(indexPath.row)
        vc.movieImageUrl = self.boxOfficeModel.getBoxOfficeHighResForIndex(indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Collection View delegate and data source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell;
        
        let data = NSData(contentsOfURL: self.boxOfficeModel.getBoxOfficeThumbUrlForIndex(indexPath.row))
        let image = UIImageView(image: UIImage(data:data!))
        image.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(200)
            return
        }
        cell.contentView.addSubview(image)
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var vc = MovieDetailsViewController()
        vc.movieSynopsisText = self.boxOfficeModel.getBoxOfficeSynopsisForIndex(indexPath.row)
        vc.movieImageUrl = self.boxOfficeModel.getBoxOfficeHighResForIndex(indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boxOfficeModel.getBoxOfficeDataCount()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(150, 200);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10, 10, 150, 10)
        
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        // this is laggy as hell!
        println("test changed in search bar \(searchText)")
    }
}
