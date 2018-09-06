//
//  ProtocolModel.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

protocol AddNewItemDelegate {
    
    func addNewItem(item: String)
    
}

protocol ReloadTableListDelegate {
    
    func reloadTableData()
    
}
