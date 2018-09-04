//
//  CategoryModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

enum CategorySegue {
    
    case home, errands, work, fun, ideas
    
}

class CategoryModel {
    
    var numberOfRows = 1
    
    var cellIdentifier = "cell"
    
    var categoryDisplayed = CategorySegue.home
    
    var categorySegue: String {
        
        switch categoryDisplayed {
            
        case .home: return Keywords.shared.homeToItemsSegue
        case .errands: return Keywords.shared.errandsToItemsSegue
        case .work: return Keywords.shared.workToItemsSegue
        case .fun: return Keywords.shared.funToItemsSegue
        case .ideas: return Keywords.shared.ideasToItemsSegue
            
        }
        
    }
    
}
