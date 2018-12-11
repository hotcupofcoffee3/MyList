//
//  HapticsModel.swift
//  MyList
//
//  Created by Adam Moore on 12/11/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

class HapticsModel {
    
    static var shared = HapticsModel()
    private init() {}
    
    func hapticExecuted(as hapticType: UINotificationFeedbackGenerator.FeedbackType) {
        
        // Success notification haptic
        let successHaptic = UINotificationFeedbackGenerator()
        successHaptic.notificationOccurred(hapticType)
        
    }
    
}
