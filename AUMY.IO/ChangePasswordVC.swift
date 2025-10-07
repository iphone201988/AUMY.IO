//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var oldPwdTF: DTTextField!
    @IBOutlet weak var newPwdTF: DTTextField!
    @IBOutlet weak var confirmPwdTF: DTTextField!
    
    let oldPasswordMessage        = NSLocalizedString("Old Password is required.", comment: "")
    let passwordMessage         = NSLocalizedString("Password is required.", comment: "")
    let confirmPasswordMessage  = NSLocalizedString("Confirm password is required.", comment: "")
    let mismatchPasswordMessage = NSLocalizedString("Password and Confirm password are not matching.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([oldPwdTF, newPwdTF, confirmPwdTF])
        setEditableTextFieldFont([oldPwdTF, newPwdTF, confirmPwdTF])
        customPlaceHolder([oldPwdTF, newPwdTF, confirmPwdTF])
    }
    
    func validateData() -> Bool {
        
        guard !oldPwdTF.text!.isEmptyStr else {
            oldPwdTF.showError(message: oldPasswordMessage)
            return false
        }
        
        guard !newPwdTF.text!.isEmptyStr else {
            newPwdTF.showError(message: passwordMessage)
            return false
        }
        
        guard !confirmPwdTF.text!.isEmptyStr else {
            confirmPwdTF.showError(message: confirmPasswordMessage)
            return false
        }
        
        guard confirmPwdTF.text! == newPwdTF.text! else {
            confirmPwdTF.showError(message: mismatchPasswordMessage)
            return false
        }
        
        return true
    }
    
    @IBAction func signup(_ sender: InterButton) {
        guard validateData() else { return }
        
        SharedMethods.shared.pushToWithoutData(destVC: VerifyOTPVC.self, isAnimated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

