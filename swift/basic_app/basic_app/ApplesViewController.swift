//
//  ViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 11/05/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class ApplesViewController: DLViewController {
    
    @IBOutlet weak var applesDlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .green        
        
        if (attributionData["link"] as? String) != nil || (attributionData["scheme"] as? String) != nil {
            applesDlLabel.attributedText = attributionDataToString()
        }
    }

}

