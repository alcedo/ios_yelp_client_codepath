//
//  FilterViewController.swift
//  Yelp
//
//  Created by Victor Liew on 5/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func filterView(controller:FilterViewController, options: FilterOptions) -> Void
}

//filter list -> category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
struct FilterOptions {
    var categories = [String]()
    var sort: YelpSortMode?
    var deals = false
    var radius: Int?
}

class FilterViewController: UIViewController {

    var delegate: FilterViewDelegate?
    var categories = [String]()
    var deals = false
    
    var sortGroupLastSelected: NSIndexPath?
    var radiusLastSelected: NSIndexPath?
    
    let selectionCategories = ["Thai", "Chinese", "Indian", "American"]
    let selectionCategoriesCode = ["thai", "chinese", "indpak", "newamerican"]
    let distance = [10, 30, 50]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Set Filters"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
            style: UIBarButtonItemStyle.Plain, target: self, action: "didSelectCancelButton:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .Plain, target: self, action: "didSelectSearchButton:")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "#E3001C")
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, 0, 0), style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelectSearchButton(sender: UIBarButtonItem) {
        var sortMode = YelpSortMode.BestMatched
        var distance: Int?
        
        if self.sortGroupLastSelected != nil {
            sortMode = YelpSortMode.allValues[self.sortGroupLastSelected!.row]
        }
        
        if self.radiusLastSelected != nil {
           distance = self.distance[self.radiusLastSelected!.row]
        }
        
        let filters = FilterOptions(categories: self.categories, sort: sortMode, deals: self.deals, radius: distance)
        self.delegate?.filterView(self, options: filters)
        self.dismissViewControllerAnimated(true, completion: nil)
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

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categories"
        }
        if section == 1 {
            return "Radius"
        }
        if section == 2 {
            return "Deals"
        }
        if section == 3 {
            return "Sort"
        }
        return "" 
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.selectionCategories.count
        }
        
        if section == 1 {
            return 3
        }
        
        if section == 3 {
            return 3
        }
        
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = self.selectionCategories[indexPath.row]
            let toggle = UISwitch()
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: "didSelectCategorySwitch:", forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = toggle
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = String(self.distance[indexPath.row]) + " mile"
            cell.tag = self.distance[indexPath.row]
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = UITableViewCell()
            cell.selectionStyle = .None
            cell.textLabel?.text = "Offering a deal"
            let toggle = UISwitch()
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: "didSelectDealsSwitch:", forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = toggle
            return cell
        }
        
        
        if indexPath.section == 3 {
            let cell = UITableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let sortMode = YelpSortMode.allValues[indexPath.row]
            cell.textLabel?.text = sortMode.description
            cell.tag = sortMode.hashValue
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            // un-select the older row
            if let selected = self.radiusLastSelected {
                tableView.cellForRowAtIndexPath(selected)?.accessoryType = .None
            }
            
            // select the new row
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.radiusLastSelected = indexPath
        }
        if indexPath.section == 3 {
            // un-select the older row
            if let selected = self.sortGroupLastSelected {
                tableView.cellForRowAtIndexPath(selected)?.accessoryType = .None
            }
            
            // select the new row
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.sortGroupLastSelected = indexPath
        }
    }
    
}

// Action Handlers
extension FilterViewController {
    func didSelectCategorySwitch(sender: UISwitch) {
        let idx = sender.tag
        let category = self.selectionCategoriesCode[idx]
        // entry exist, remove it
        if (find(self.categories, category) != nil) {
            self.categories = self.categories.filter({ el in
                return el != category
            })
        }else {
            self.categories.append(category)
        }
    }
    
    func didSelectDealsSwitch(sender: UISwitch) {
        self.deals = sender.on
    }
}

