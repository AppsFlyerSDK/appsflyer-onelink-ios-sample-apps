//
//  LoginViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 19/03/2023.
//  Copyright © 2023 OneLink. All rights reserved.
//

import UIKit


protocol LoginDoneDelegate {
    func loginDone()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginDoneDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        delegate?.loginDone()
    }    
}
