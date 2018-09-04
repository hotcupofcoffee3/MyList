//
//  ItemsViewController.swift
//  TheList
//
//  Created by Adam Moore on 8/31/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

}



extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
        
        return cell
        
    }
    
}
