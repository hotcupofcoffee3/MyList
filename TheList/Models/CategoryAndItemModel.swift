//
//  CategoryAndItemModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

enum TypeOfSegue {
    
    case home, errands, work, fun, ideas, items
    
}

class CategoryAndItemModel: AddNewItemDelegate, ReloadTableListDelegate {
    
    func addNewItem(item: String) {
        items.append(item)
    }
    
    func reloadTableData() {
        if let table = table {
            table.reloadData()
        } else {
            print("There was no table defined in the protocol conformance to ReloadTableListDelegate in the CategoryAndItemModel")
        }
    }
    
    var table: UITableView?
    
    var items = [String]()
    
    var viewDisplayed = TypeOfSegue.home
    
    var typeOfSegue: String {
        
        switch viewDisplayed {
            
        case .home: return Keywords.shared.homeToItemsSegue
        case .errands: return Keywords.shared.errandsToItemsSegue
        case .work: return Keywords.shared.workToItemsSegue
        case .fun: return Keywords.shared.funToItemsSegue
        case .ideas: return Keywords.shared.ideasToItemsSegue
        case .items: return "Nothing"
            
        }
        
    }
    
}
