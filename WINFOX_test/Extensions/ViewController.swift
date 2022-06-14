//
// ViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

//MARK: extension to alert
extension UIViewController {
    
    func showAlert(alertText : String?, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
         })
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actionStyle:[UIAlertAction.Style], actions:[((UIAlertAction) -> Void)?], vc: UIViewController) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           for (index, title) in actionTitles.enumerated() {
                let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
                alert.addAction(action)
           }
           vc.present(alert, animated: true, completion:{
               alert.view.superview?.isUserInteractionEnabled = true
               alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
      }
    
    func setupAlertController(with title: String, with vc: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.setValue(vc, forKey: "contentViewController")
        let selectAction = UIAlertAction(title: "OK", style: .default) { _ in
            
          }
        alertController.addAction(selectAction)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any,
                                                           attribute: NSLayoutConstraint.Attribute.height,
                                                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
                                                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                           multiplier: 1, constant: self.view.frame.height * 0.70)
        alertController.view.addConstraint(height)
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
         })
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}




