//
//  CategoryAndItemTableViewCell.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class CategoryAndItemTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameLabelTrailingConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var nameLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var numberLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var checkboxImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.borderWidth = 2
       cellBackgroundView.layer.cornerRadius = 12
        
    }

}
