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
        // TODO: Pass ConversionData from Login VC here
        let conversionData : [String:Any]? = nil
        if conversionData != nil{
            if let conversionData = conversionData {
                ConversionDataParams.attributedText = attributionDataToString(data: conversionData)
                ConversionDataParams.textColor = .label
            }
        }
    }
}

      
