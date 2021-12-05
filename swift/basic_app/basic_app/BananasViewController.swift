//
//  BananasViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 01/06/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class BananasViewController: DLViewController {
    
    @IBOutlet weak var bananasDlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (deepLinkData != nil) {
            bananasDlTextView.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
            bananasDlTextView.textColor = .label
        }
    }

    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        super.copyShareInviteLink(fruitName: "bananas")
    }
    
}
