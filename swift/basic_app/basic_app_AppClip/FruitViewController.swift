//
//  FruitViewController.swift
//  basic_app_AppClip
//
//  Created by Oded Rinsky on 09/11/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import Foundation
import UIKit
import os.log
import AppsFlyerLib

class FruitViewController: DLViewController {
    @IBOutlet weak var fruitCover: UIButton!
    @IBOutlet weak var dlParameters: UITextView!
    var destination: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(resetViewController), name: UIScene.didEnterBackgroundNotification, object: nil)
        prepareFruitView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func prepareFruitView(){
        NSLog("[AFSDK] prepareFruitSubView called")
        if (deepLinkData == nil){
            NSLog("Deep link data is nil")
        }
        //set the cover image according to the destination
        if (self.destination == nil){
            NSLog("[AFSDK] No destination in fruitSubView, setting placeholder")
            self.destination = "apples"
        }
        let coverImage = UIImage(named: self.destination! + "_cover")?.withRenderingMode(.alwaysOriginal)
        self.fruitCover.setImage(coverImage, for: .normal)
//        Present the deep link parameters
        NSLog("[AFSDK] Setting deep link parameters")
        if (deepLinkData == nil){
            NSLog("Deep link data is nil")
            return
        }
        let attributedString = attributionDataToString(data: (deepLinkData?.clickEvent)!)
        if (attributedString == NSAttributedString(string: "")){
           attributedString.append(NSAttributedString(string: "Link returned no parameters", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 18.0)!
         ]))
        }
        dlParameters.attributedText = attributedString
        dlParameters.textColor = .label
    }
    
    @objc func resetViewController(){
        self.dismiss(animated: false)
    }
    
}
