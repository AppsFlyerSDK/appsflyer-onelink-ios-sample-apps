//
//  ViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 11/05/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib

class ApplesViewController: DLViewController {
    
    @IBOutlet weak var fruitAmount: UILabel!
    @IBOutlet weak var applesDlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.     

        if (deepLinkData != nil) {
            applesDlTextView.attributedText = attributionDataToString(data: deepLinkData!)
            applesDlTextView.textColor = .label
            fruitAmount.text = getFruitAmount(data: deepLinkData!)
        }
        sendEvent()
    }
    
    @IBAction func copyShareInviteLink(_ sender: UIButton) {
        super.copyShareInviteLink(fruitName: "apples")
    }
    
    private func sendEvent(){
        //Add Event
    }
    
}
