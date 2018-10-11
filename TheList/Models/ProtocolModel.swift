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
    func addNewItem(itemName: String, forParentID parentID: Int) -> Bool
}

protocol ReloadTableListDelegate {
    func reloadTableData()
}

protocol CheckForNameDuplicationDelegate {
    func presentDuplicateNameAlert()
}

protocol HapticDelegate {
    func hapticExecuted(as: UINotificationFeedbackGenerator.FeedbackType)
}

protocol ItemEditedDelegate {
    func itemHasBeenEdited()
}

protocol EditingCompleteDelegate {
    func editingComplete()
}
