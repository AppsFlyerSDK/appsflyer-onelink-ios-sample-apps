//
//  MainViewController.swift
//  basic_app_AppClip
//
//  Created by Oded Rinsky on 09/11/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import UIKit
import StoreKit
import AppClip
import Network
import os.log

class MainViewController: DLViewController {
    var destination: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if (self.viewControllerFirstLaunch == nil){
            NSLog("[AFSDK] Displaying SKOverlay")
            self.displayOverlay()
            self.viewControllerFirstLaunch = false
        }
    }
    
    @objc func displayOverlay() {
        guard let scene = self.view.window?.windowScene else { return }
        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.delegate = self
        overlay.present(in: scene)
    }
    
    func showDeepLinkData() {
        NSLog("[AFSDK] setDeeplinkData called")
        if (deepLinkData != nil) {
            NSLog("[AFSDK] Deep link data in MainViewController: \(self.deepLinkData!)")
            
            let deepLinkValue = deepLinkData?.deeplinkValue
            NSLog("[AFSDK] deep_link_value is \(deepLinkValue ?? "nil")")
            self.setDestination(destination: deepLinkValue)
            
            if (destination != "main"){
                performSegue(withIdentifier: "ToFruitView", sender: self)
                }
        }
        else{
            NSLog("[AFSDK] Deep link data is nil in MainViewController")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ToFruitView") {
          let fruitViewController = segue.destination as! FruitViewController
           fruitViewController.destination = self.destination
           fruitViewController.deepLinkData = self.deepLinkData
       }
    }
    
    func isValidDestination(_ deepLinkValue: String?) -> Bool {
        if deepLinkValue == nil {
            return false
        }
        let validDestinations = ["bananas", "peaches", "apples", "main"]
        if validDestinations.contains(deepLinkValue!) {
            return true
        }
        NSLog("[AFSDK] \(deepLinkValue!) is not a valid destination")
        return false
    }
    
    func setDestination(destination :String?){
        if isValidDestination(destination){
            self.destination = destination
            NSLog("[AFSDK] destination is set to \(destination!)")
        } else {
            self.destination = "main"
            NSLog("[AFSDK] destination is set to main")
        }
    }
}


extension MainViewController : SKOverlayDelegate {
    
    func storeOverlayDidFailToLoad(_ overlay: SKOverlay, error: Error) {
     
    }
    
    func storeOverlayWillStartDismissal(_ overlay: SKOverlay, transitionContext: SKOverlay.TransitionContext) {
       
    }
    
    func storeOverlayWillStartPresentation(_ overlay: SKOverlay, transitionContext: SKOverlay.TransitionContext) {

    }
    
    func storeOverlayDidFinishDismissal(_ overlay: SKOverlay, transitionContext: SKOverlay.TransitionContext) {
        NSLog("[AFSDK] SKOverlay DidFinishDismissal")
    }
    
    func storeOverlayDidFinishPresentation(_ overlay: SKOverlay, transitionContext: SKOverlay.TransitionContext) {
        NSLog("[AFSDK] SKOverlay DidFinishPresentation")
    }

}
