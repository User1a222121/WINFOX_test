//
//  KeyboardHandlingBaseVC.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

class KeyboardHandlingBaseVC: UIViewController {
    
    @IBOutlet weak var backgroundSV: UIScrollView!
    var tap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
    }
}

// MARK: Keyboard Dismissal Handling on Tap
private extension KeyboardHandlingBaseVC{
    
    func initializeHideKeyboard(){
        tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
