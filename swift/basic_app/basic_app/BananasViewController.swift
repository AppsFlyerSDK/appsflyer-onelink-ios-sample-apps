//
//  BananasViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 01/06/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class BananasViewController: DLViewController {
    
    @IBOutlet weak var bananasDlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow        

        if (deepLinkData != nil) {
            bananasDlLabel.attributedText = attributionDataToString()
        }
    }


}
