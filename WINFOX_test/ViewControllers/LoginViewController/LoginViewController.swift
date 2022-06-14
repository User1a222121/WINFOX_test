//
//  LoginViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

class LoginViewController: KeyboardHandlingBaseVC {
    
    //MARK: outlets
    @IBOutlet weak var regLbl: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadUserInfo()
    }
    
    // private func
    private func setupUI() {
        
        // textField
        phoneNumberTF.delegate = self
        phoneNumberTF.keyboardType = .numberPad
        // button
        getCodeButton.layer.cornerRadius = 5
        
    }
    
    private func loadUserInfo() {
        
        if let phone = UserConstants.shared.phoneNumber {
            phoneNumberTF.text = HelperPhoneMask.format(with: "+Y (XXX) XXX-XX-XX", phone: phone)
        } else {
            phoneNumberTF.text = "+7"
        }
    }
    
    //MARK: IBAction
    @IBAction func getCodeButtonAction(_ sender: UIButton) {
        
        guard let number = phoneNumberTF.text else { return }
        UserConstants.shared.phoneNumber = number
        
        AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
            guard success else {
                self?.showAlert(alertText: "Ошибка Firebase", alertMessage: "Попробуйте позже.")
                return
            }
            DispatchQueue.main.async {
                let vc = CodeViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//MARK: extensions
extension LoginViewController: UITextFieldDelegate {
    
    //Only delegate for phoneNumberTF
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = HelperPhoneMask.format(with: "+Y (XXX) XXX-XX-XX", phone: newString)
        return false
    }
}

