//
//  ConversionDataViewController.swift
//  basic_app
//
//  Created by Oded Rinsky on 03/06/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import UIKit

class ConversionDataViewController: DLViewController {
    
    @IBOutlet weak var ConversionDataParams: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conversionData = appDelegate.ConversionData
        if conversionData != nil{
            if let conversionData = conversionData as! [String:Any]? {
                
                ConversionDataParams.attributedText = attributionDataToString(data: conversionData)
            }
        }
    }
}

