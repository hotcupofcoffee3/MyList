//
//  NavigationViewController.swift
//  MyList
//
//  Created by Adam Moore on 11/8/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    @IBOutlet weak var home: UITabBarItem!
    @IBOutlet weak var errands: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        home.badgeValue = ""
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
