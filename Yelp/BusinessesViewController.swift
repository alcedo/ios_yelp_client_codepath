//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SnapKit
class BusinessesViewController: UIViewController, FilterViewDelegate {

    var businesses: [Business]!
    var tableView: UITableView!
    let RESTAURANT_IMAGE = 1
    let RESTAURANT_NAME = 2
    let RESTAURANT_REVIEW = 3
    let RESTAURANT_ADDRESS = 4
    let RESTAURANT_CATEGORY = 5
    let RESTAURANT_DIST = 6
    let RESTAURANT_REVIEW_COUNT = 7
    
    var searchTerm = ""
    var appliedFilters: FilterOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Yelp"
        self.view.backgroundColor = UIColor.whiteColor()
        
        // filter button
        let filterButton = UIBarButtonItem(title: "Filters", style: UIBarButtonItemStyle.Done, target: self, action: "didSelectFilterButton:")
        filterButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = filterButton
        
        // navigation bar + search bar
        let sb = UISearchBar()
        sb.delegate = self
        self.navigationItem.titleView = sb
        
        self.setupView()
        self.doSearchYelp()
    }
    
    func doSearchYelp() {
        if self.appliedFilters != nil {
            Business.searchWithTerm(self.searchTerm, sort: self.appliedFilters!.sort, categories: self.appliedFilters!.categories, deals: self.appliedFilters!.deals) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
            
        }else {
            Business.searchWithTerm(self.searchTerm, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            })
        }
        
    }
    
    func didSelectFilterButton(sender: UIBarButtonItem) {
        let vc = FilterViewController()
        let nvc = UINavigationController(rootViewController: vc)
        vc.delegate = self
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView = UITableView()
        if let tv = self.tableView {
            self.view.addSubview(tv)
            tv.rowHeight = UITableViewAutomaticDimension
            tv.estimatedRowHeight = 200
            
            tv.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view.snp_top)
                make.height.equalTo(self.view.snp_height)
                make.width.equalTo(self.view.snp_width)
                return
            }
            
            tv.delegate = self
            tv.dataSource = self
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

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    func buildCell(indexPath: NSIndexPath) -> BusinessTableViewCell {
        let cell = BusinessTableViewCell(id: "restaurant_cell")
        
        if let b = self.businesses {
            
            if let restaurantImg = cell.contentView.viewWithTag(RESTAURANT_IMAGE) as! UIImageView! {
                if let imgUrl = b[indexPath.row].imageURL {
                    restaurantImg.setImageWithURL(imgUrl)
                }
            }
            
            if let restaurantName = cell.contentView.viewWithTag(RESTAURANT_NAME) as! UILabel! {
                if let name = b[indexPath.row].name {
                    restaurantName.text = name
                }
            }
            
            if let restaurantReviews = cell.contentView.viewWithTag(RESTAURANT_REVIEW) as! UIImageView! {
                if let ratingUrl = b[indexPath.row].ratingImageURL {
                    restaurantReviews.setImageWithURL(ratingUrl)
                }
            }
            
            if let restaurantAddress = cell.contentView.viewWithTag(RESTAURANT_ADDRESS) as! UILabel! {
                if let add = b[indexPath.row].address {
                    restaurantAddress.text = add
                }
            }
            
            if let restaurantCategory = cell.contentView.viewWithTag(RESTAURANT_CATEGORY) as! UILabel! {
                if let category = b[indexPath.row].categories {
                    restaurantCategory.text = category
                }
            }
            
            if let restaurantReview = cell.contentView.viewWithTag(RESTAURANT_REVIEW_COUNT) as! UILabel! {
                if let count = b[indexPath.row].reviewCount {
                    restaurantReview.text = count.stringValue + " Reviews"
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "restaurant_cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BusinessTableViewCell?
        cell = self.buildCell(indexPath)
        
        return cell!
        
    }
    func filterView(controller: FilterViewController, options: FilterOptions) {
        self.appliedFilters = options
        self.doSearchYelp()
        println("filter view controller closed")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let b = self.businesses {
            return self.businesses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
          // not sure why these autolayout calc isnt working. height is always 0 -> Hope ben can help!
        
//        //Layout and Autolayout update UIView
//        cell!.setNeedsUpdateConstraints()
//        cell!.updateConstraintsIfNeeded()
//        cell!.contentView.setNeedsLayout()
//        cell!.contentView.layoutIfNeeded()
//        let h = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//        println(h)
//        println(cell!.frame.size.height)

        
//        let cell = self.buildCell(indexPath)
//        cell.updateConstraintsIfNeeded()
//        cell.layoutIfNeeded()
//        let h = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//        println(h)
//
//        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
//            println(cell.frame.size.height)
//            return cell.frame.size.height
//        }
        return 80
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
        self.doSearchYelp()
        self.appliedFilters = nil
    }
}
