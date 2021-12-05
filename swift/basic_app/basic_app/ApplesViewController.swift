//
//  ViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 11/05/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit

class ApplesViewController: DLViewController {
    
    @IBOutlet weak var applesDlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.     

        if (deepLinkData != nil) {
            applesDlTextView.attributedText = attributionDataToString(data: (deepLinkData?.clickEvent)!)
            applesDlTextView.textColor = .label
        }
    }
    
    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        super.copyShareInviteLink(fruitName: "apples")
    }
    
}
