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
    
    func setCellColorAndImageDisplay(colorSelector: CellColorAndImageDisplaySelector, doneStatus: Bool?) {
        
        var done = Bool()
        
        if let doneStatus = doneStatus {
            done = doneStatus
            
        }
        
        switch colorSelector {
            
        case .regular:
            
            if done {
                checkboxImageView.image = Keywords.shared.checkboxChecked
                cellBackgroundView.backgroundColor = Keywords.shared.lightGreenBackground12
                cellBackgroundView.layer.borderColor = Keywords.shared.greenBorder.cgColor
            } else {
                checkboxImageView.image = Keywords.shared.checkboxEmpty
                cellBackgroundView.backgroundColor = UIColor.white
                cellBackgroundView.layer.borderColor = Keywords.shared.greyBorder.cgColor
            }
            
        case .groupingUnselected:
            checkboxImageView.image = (done) ? Keywords.shared.blueCheck : Keywords.shared.blueEmptyCheckbox
            cellBackgroundView.backgroundColor = UIColor.white
            cellBackgroundView.layer.borderColor = Keywords.shared.blueBorderLighter.cgColor
            
        case .groupingSelected:
            checkboxImageView.image = (done) ? Keywords.shared.blueCheck : Keywords.shared.blueEmptyCheckbox
            cellBackgroundView.backgroundColor = Keywords.shared.lightBlueBackground
            cellBackgroundView.layer.borderColor = Keywords.shared.blueBorderDarker.cgColor
            
        case .movingUnselected:
            cellBackgroundView.backgroundColor = Keywords.shared.purpleBackground
            cellBackgroundView.layer.borderColor = Keywords.shared.purpleBorder.cgColor
            
        case .movingSelected:
            cellBackgroundView.backgroundColor = Keywords.shared.orangeBackground
            cellBackgroundView.layer.borderColor = Keywords.shared.orangeBorder.cgColor
            
        }
        
    }

}
