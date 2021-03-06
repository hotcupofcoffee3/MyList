//
//  ProtocolModel.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit



// Item information check
protocol IsValidNameDelegate {
    func isValidName(forItemName itemName: String) -> ItemNameCheck
}
protocol PresentInvalidNameAlertDelegate {
    func presentInvalidNameAlert()
}


// TextField Delegates

protocol TouchedAwayFromTextFieldDelegate {
    func touchedAwayFromTextField()
}
protocol SetEditingModeFromHeaderDelegate {
    func setEditingModeFromHeader(forEditingMode editingMode: EditingMode)
}
protocol DismissKeyboardFromMainViewControllerDelegate {
    func dismissKeyboardFromMainViewController()
}



protocol AddNewItemDelegate {
    func addNewItem(itemName: String)
}
protocol ReloadTableListDelegate {
    func reloadTableData()
}
protocol ItemEditedDelegate {
    func itemHasBeenEdited()
}
protocol EditingCompleteDelegate {
    func editingComplete()
}
protocol DifferentTabClickedDelegate {
    func differentTabClicked()
}
