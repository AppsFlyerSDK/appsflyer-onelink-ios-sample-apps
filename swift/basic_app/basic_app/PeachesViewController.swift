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

        if (deepLinkData != nil) {
            peachesDlLabel.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
        }
    }
    
    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        let parameters : [AnyHashable: Any] = [
            "deep_link_value" : "peaches",
            "af_campaign" : "Shared link",
            "deep_link_sub1" : "This app was opened using a link shared from 'Peaches' activity",
            "fruit_amount" : "30"
        ]
        super.copyShareInviteLink(parameters: parameters)
    }
}

