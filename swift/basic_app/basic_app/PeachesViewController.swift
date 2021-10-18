//
//  BananasViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 01/06/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class PeachesViewController: DLViewController {
    
    @IBOutlet weak var peachesDlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (deepLinkData != nil) {
            peachesDlTextView.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
            peachesDlTextView.textColor = .label
        }
    }
    
    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        let parameters : [AnyHashable: Any] = [
            "deep_link_value" : "peaches",
            "af_campaign" : "Shared link",
            "deep_link_sub2" : "This app was opened using a link shared from 'Peaches' activity",
            "deep_link_sub1" : "30"
        ]
        super.copyShareInviteLink(parameters: parameters)
    }
}

