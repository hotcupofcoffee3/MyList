//
//  EnumModel.swift
//  MyList
//
//  Created by Adam Moore on 12/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

// The Chosen VC that displays the TableView
enum SelectedCategory: String {
    case home, errands, work, other, subItems1, subItems2
}

enum ItemProperty {
    case category, level, parentID, id, name, done
}

enum ItemNameCheck: String {
    case success
    case duplicate = "There is already an item with that name."
    case threeQuestionMarks = "You cannot use more than 3 '?' in a row."
//    case threeQuestionMarks = "You cannot use the following characters: \" \' ( ) * ! \\"
    
    // Only used for grouping
    case blank = "You have to give the item a name"
}

enum EditingMode {
    case none, sorting, grouping, specifics
}