//
//  BaseOnboardViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class BaseOnboardViewController: UIViewController {

    var keyboardHeight: CGFloat = 0.0
    //                     UpperCase LowerCase  OneDigit     6-15 Length
    let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,15}$"
    //                1orMoreChars + @ sign + 1orMoreChars + . + 2or3 chars
    let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if keyboardHeight == 0.0 {
                    keyboardHeight = keyboardSize.height
                }
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    public func showErrorPopup(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alert.addAction(done)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showInfoPopup(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Info", comment: ""), message: message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alert.addAction(done)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func directMainPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
        self.present(vc, animated: true, completion: nil)
    }


}
