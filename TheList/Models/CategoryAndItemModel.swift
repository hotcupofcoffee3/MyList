//
//  CategoryAndItemModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

enum TypeOfSegue {
    
    case home, errands, work, fun, ideas, items
    
}

class CategoryAndItemModel {
    
    var numberOfRows = 0
    
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
