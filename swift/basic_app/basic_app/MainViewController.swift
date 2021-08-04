//
//  MainViewController.swift
//  basic_app
//
//  Created by Oded Rinsky on 04/08/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import Foundation
import UIKit
import AppTrackingTransparency

class MainViewController: DLViewController {
    
    override func viewDidLoad() {
        if #available(iOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization { (status) in
            switch status {
            case .denied:
                print("AuthorizationSatus is denied")
            case .notDetermined:
                print("AuthorizationSatus is notDetermined")
            case .restricted:
                print("AuthorizationSatus is restricted")
            case .authorized:
                print("AuthorizationSatus is authorized")
            @unknown default:
                fatalError("Invalid authorization status")
            }
          }
        }
    }
}
