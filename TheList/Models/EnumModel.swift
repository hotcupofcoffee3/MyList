//
//  EnumModel.swift
//  MyList
//
//  Created by Adam Moore on 12/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

// The Chosen VC that displays the TableView
enum SelectedView: String {
    case home, errands, work, other, subItems1, subItems2, move1, move2
}

enum ItemProperty {
    case parentID, id, name, done, orderNumber
}

enum ItemNameCheck: String {
    case success = "Great! It worked, but this was never supposed to be called from the Enum."
    case duplicate = "There is already an item with that name."
    case threeQuestionMarks = "You cannot use more than 3 '?' in a row."
    
    // Only used for grouping
    case blank = "You have to give the item a name"
}

enum EditingMode { // Add 'selecting' in place of sorting, grouping, and moving, as these will no be offered in an Action Sheet
    case none, adding, sorting, grouping, moving, specifics
}

enum CellColorAndImageDisplaySelector {
    case regular, groupingSelected, groupingUnselected, movingSelected, movingUnselected
}
