//
//  ProtocolModel.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

protocol IsValidNameDelegate {
    func isValidName(forItemName itemName: String) -> ItemNameCheck
}

protocol AddNewItemDelegate {
    func addNewItem(itemName: String)
}

protocol ReloadTableListDelegate {
    func reloadTableData()
}

protocol PresentInvalidNameAlertDelegate {
    func presentInvalidNameAlert(withErrorMessage errorMessage: ItemNameCheck)
}

protocol AddAnItemTextFieldIsActiveDelegate {
    func addAnItemTextFieldIsActive()
}

protocol AddAnItemTextFieldIsSubmittedDelegate {
    func addAnItemTextFieldIsSubmitted()
}

protocol TouchedAwayFromHeaderTextFieldDelegate {
    func touchedAwayFromHeaderTextField()
}

protocol SetEditingModeForDismissingKeyboardDelegate {
    func setEditingModeForDismissingKeyboard()
}

protocol DismissKeyboardFromMainViewControllerDelegate {
    func dismissKeyboardFromMainViewController()
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

protocol DifferentTabClickedDelegate {
    func differentTabClicked()
}
