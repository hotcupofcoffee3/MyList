//
//  EditViewController.swift
//  MyList
//
//  Created by Adam Moore on 9/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    var selectedView = SelectedView.home
    
    var nameToEdit = String()
    
    var item: Item?
    
    var editingCompleteDelegate: EditingCompleteDelegate?
    
    @IBOutlet weak var nameTextView: UITextView!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeName() {
        
        if nameTextView.text != "" {
            
            if let item = item {
                DataModel.shared.updateItem(forProperties: [.name], forItem: item, withNewParentID: nil, withNewName: nameTextView.text!, withNewOrderNumber: nil)
            }
            
            editingCompleteDelegate?.editingComplete()
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }

    @IBAction func submit(_ sender: UIButton) {
        
        changeName()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextView.text = nameToEdit
        nameTextView.delegate = self
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        changeName()
    }
    
}
