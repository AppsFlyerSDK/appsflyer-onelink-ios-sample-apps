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

        if (deepLinkData != nil) {
            applesDlLabel.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
        }
        
    }
    
    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        let parameters : [AnyHashable: Any] = [
            "deep_link_value" : "apples",
            "af_campaign" : "Shared link",
            "deep_link_sub1" : "This app was opened using a link shared from 'Apples' activity",
            "fruit_amount" : "20"
        ]
        super.copyShareInviteLink(parameters: parameters)
    }
    
}
