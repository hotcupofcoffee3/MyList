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
    func presentInvalidNameAlert(withErrorMessage errorMessage: ItemNameCheck)
}



// TextField Delegates
protocol TextFieldIsActiveDelegate {
    func textFieldIsActive()
}
protocol TextFieldIsSubmittedDelegate {
    func textFieldIsSubmitted()
}
protocol TouchedAwayFromTextFieldDelegate {
    func touchedAwayFromTextField()
}
protocol SetEditingModeForDismissingKeyboardDelegate {
    func setEditingModeForDismissingKeyboard()
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
