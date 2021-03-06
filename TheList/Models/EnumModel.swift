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
    case newParentMatchesAnItemBeingMoved = "The new Parent chosen is an item that is being moved."
    case threeQuestionMarks = "You cannot use more than 3 '?' in a row."
    
    // Only used for grouping
    case blank = "You have to give the item a name"
}

enum EditingMode {
    case none, adding, selecting, moving, specifics
}

enum CellColorAndImageDisplaySelector {
    case regular, groupingSelected, groupingUnselected, movingSelected, movingUnselected
}

enum ActionOptions {
    case rename, move, group, delete, deleteSubItems
}
