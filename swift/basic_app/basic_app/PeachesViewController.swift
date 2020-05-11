//
//  BananasViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 01/06/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class PeachesViewController: DLViewController {
    
    @IBOutlet weak var peachesDlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        
        if (attributionData["link"] as? String) != nil {
            peachesDlLabel.attributedText = attributionDataToString()
        }
    }


}
