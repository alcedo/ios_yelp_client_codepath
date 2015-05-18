//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Victor Liew on 5/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    let RESTAURANT_IMAGE = 1
    let RESTAURANT_NAME = 2
    let RESTAURANT_REVIEW = 3
    let RESTAURANT_ADDRESS = 4
    let RESTAURANT_CATEGORY = 5
    let RESTAURANT_DIST = 6
    let RESTAURANT_REVIEW_COUNT = 7
    
    var distanceText = "0.8mi"

    convenience init(id: String) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: id)
        let img = UIImageView()
        img.tag = RESTAURANT_IMAGE
        
        self.contentView.addSubview(img)
        img.snp_makeConstraints{ (make) -> Void in
            make.topMargin.equalTo(4)
            make.leftMargin.equalTo(10)
            make.height.equalTo(50)
            make.width.equalTo(50)
            return
        }
        
        let spacingView = UIView()
        self.contentView.addSubview(spacingView)
        spacingView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(5)
            make.top.equalTo(img.snp_top)
            make.bottom.equalTo(img.snp_bottom)
            make.left.equalTo(img.snp_right)
            return
        }
        
        let nameView = UILabel()
        nameView.tag = RESTAURANT_NAME
        nameView.numberOfLines = 2
        self.contentView.addSubview(nameView)
        nameView.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(spacingView.snp_right)
            make.top.equalTo(img.snp_top)
            make.width.equalTo(100)
            return
        }
        nameView.font = UIFont.boldSystemFontOfSize(12)
        
        let ratingImg = UIImageView()
        ratingImg.tag = RESTAURANT_REVIEW
        self.contentView.addSubview(ratingImg)
        ratingImg.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(nameView.snp_bottom).offset(3)
            make.left.equalTo(spacingView.snp_right)
            return
        }
        
        let address = UILabel()
        address.tag = RESTAURANT_ADDRESS
        self.contentView.addSubview(address)
        address.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(ratingImg.snp_bottom)
            make.left.equalTo(spacingView.snp_right)
            return
        }
        address.font = UIFont.systemFontOfSize(10)
        
        let category = UILabel()
        category.tag = RESTAURANT_CATEGORY
        self.contentView.addSubview(category)
        category.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(address.snp_bottom)
            make.left.equalTo(spacingView.snp_right)
            return
        }
        category.font = UIFont.systemFontOfSize(10)
        category.textColor = UIColor(hex: "#747373")
        
        let review = UILabel()
        review.tag = RESTAURANT_REVIEW_COUNT
        self.contentView.addSubview(review)
        review.snp_makeConstraints{ (make) -> Void in
            make.left.equalTo(ratingImg.snp_right).offset(4)
            make.bottom.equalTo(address.snp_top)
            return
        }
        review.font = UIFont.systemFontOfSize(10)
        review.textColor = UIColor(hex: "#747373")
        
        let distance = UILabel()
        self.contentView.addSubview(distance)
        distance.text = self.distanceText
        distance.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(5)
            make.right.equalTo(self.snp_right).offset(-5)
            return
        }
        distance.font = UIFont.systemFontOfSize(8)
        distance.textColor = UIColor(hex: "#747373")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
