//
//  CodeViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

class CodeViewController: KeyboardHandlingBaseVC {
    
    //MARK: propirties
    var timer: Timer?
    var timerCount = 120
    
    //MARK: outlets
    @IBOutlet weak var smsLbl: UILabel!
    @IBOutlet weak var smsCodeTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var repeatCodeLbl: UILabel!
    @IBOutlet weak var repeatCodeButton: UIButton!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startTimer()
    }
    
    //MARK: private func
    private func setupUI() {
        
        // textField
        smsCodeTF.keyboardType = .numberPad
        smsCodeTF.delegate = self
        
        // button
        nextButton.layer.cornerRadius = 5
        repeatCodeButton.layer.cornerRadius = 5
        repeatCodeButton.isHidden = true
    }
    
    private func startTimer() {
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] _ in
            self?.timer1()
        }
    }
    
    private func timer1() {
        
        if timerCount > 0 {
            repeatCodeLbl.text = "Запросить код повторно возможно через \(timerCount)"
            timerCount = timerCount - 1
        } else {
            repeatCodeLbl.isHidden = true
            repeatCodeButton.isHidden = false
        }
    }
    
    //MARK: IBAction
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        if let smscode = smsCodeTF.text, smscode.count == 6  {
            AuthManager.shared.verifyCode(smsCode: smscode) { [weak self] success, uid in
                DispatchQueue.main.async {
                    guard success else {
                        self?.showAlert(alertText: "Ошибка", alertMessage: "Код не принят.")
                        return
                    }
                    
                    guard let number = UserConstants.shared.phoneNumber else { return }
                    NetworkServices.shared.checkUser(phoneNumber: number, uid: uid) { [weak self] success in
                        DispatchQueue.main.async {
                            guard success else {
                                self?.showAlert(alertText: "Ошибка сети", alertMessage: "Проверьте подключение к Интернету.")
                                return
                            }

                            let placesVC = PlacesViewController()
                            let mapVC = PlacesMapViewController()
                            placesVC.title = "Места"
                            mapVC.title = "Карта"
                            let tabBarVC = UITabBarController()
                            tabBarVC.setViewControllers([placesVC,mapVC], animated: false)
                            
                            guard let items = tabBarVC.tabBar.items else { return }
                            let images = ["photo", "map"]
                            
                            for i in 0..<items.count {
                                items[i].image = UIImage(systemName: images[i])
                            }
                            
                            tabBarVC.modalPresentationStyle = .fullScreen
                            self?.present(tabBarVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func repeatCodeButtonAction(_ sender: UIButton) {
        
        guard let number = UserConstants.shared.phoneNumber else { return }
        AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
            guard success else {
                self?.showAlert(alertText: "Ошибка Firebase", alertMessage: "Попробуйте позже.")
                return
            }
            self?.repeatCodeLbl.isHidden = false
            self?.repeatCodeButton.isHidden = true
            self?.timerCount = 120
            self?.startTimer()
        }
    }
}

//MARK: extensions
extension CodeViewController: UITextFieldDelegate {
    
    //Only delegate for smsCodeTF
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
