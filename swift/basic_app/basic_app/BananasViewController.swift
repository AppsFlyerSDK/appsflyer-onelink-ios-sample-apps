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

        if (deepLinkData != nil) {
            bananasDlLabel.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
        }
    }

    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        let parameters : [AnyHashable: Any] = [
            "af_og_image" : "https://img.wallpapersafari.com/desktop/1024/576/88/63/1tsk2v.jpg",
            "af_campaign" : "Shared link",
            "deep_link_sub1" : "This app was opened using a link shared from 'Bananas' activity",
            "fruit_amount" : "15"
        ]
        super.copyShareInviteLink(parameters: parameters)
    }
    
}
