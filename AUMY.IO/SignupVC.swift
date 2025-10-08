//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField

class SignupVC: UIViewController {
    
    @IBOutlet weak var nameTF: DTTextField!
    @IBOutlet weak var emailTF: DTTextField!
    @IBOutlet weak var phoneCodeTF: DTTextField!
    @IBOutlet weak var phoneNoTF: DTTextField!
    @IBOutlet weak var passwordTF: DTTextField!
    
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var appleSpaciousView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var googleSpaciousView: UIView!
    @IBOutlet weak var orView: UIImageView!
    @IBOutlet weak var orSpaciousView: UIView!
    @IBOutlet weak var termsConditionSpaciousView: UIView!
    @IBOutlet weak var termsConditionView: UIView!
    
    let firstNameMessage        = NSLocalizedString("First name is required.", comment: "")
    let lastNameMessage         = NSLocalizedString("Last name is required.", comment: "")
    let nameMessage         = NSLocalizedString("Name is required.", comment: "")
    let phoneMessage         = NSLocalizedString("Phone is required.", comment: "")
    let emailMessage            = NSLocalizedString("Email is required.", comment: "")
    let passwordMessage         = NSLocalizedString("Password is required.", comment: "")
    let confirmPasswordMessage  = NSLocalizedString("Confirm password is required.", comment: "")
    let mismatchPasswordMessage = NSLocalizedString("Password and Confirm password are not matching.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([nameTF, emailTF, phoneCodeTF, phoneNoTF, passwordTF])
        setEditableTextFieldFont([nameTF, emailTF, phoneCodeTF, phoneNoTF, passwordTF])
        customPlaceHolder([nameTF, emailTF, phoneCodeTF, phoneNoTF, passwordTF])
        
        switch Constants.role {
        case .serviceProvider:
            appleView.isHidden = true
            appleSpaciousView.isHidden = true
            googleView.isHidden = true
            googleSpaciousView.isHidden = true
            orView.isHidden = true
            orSpaciousView.isHidden = true
            termsConditionSpaciousView.isHidden = true
            termsConditionView.isHidden = true
            
        case .user:
            appleView.isHidden = false
            appleSpaciousView.isHidden = false
            googleView.isHidden = false
            googleSpaciousView.isHidden = false
            orView.isHidden = false
            orSpaciousView.isHidden = false
            termsConditionSpaciousView.isHidden = false
            termsConditionView.isHidden = false
        }
    }
    
    func validateData() -> Bool {
        
        guard !nameTF.text!.isEmptyStr else {
            nameTF.showError(message: nameMessage)
            return false
        }
        
        guard !emailTF.text!.isEmptyStr else {
            emailTF.showError(message: emailMessage)
            return false
        }
        
        guard !phoneNoTF.text!.isEmptyStr else {
            phoneNoTF.showError(message: phoneMessage)
            return false
        }
        
        guard !passwordTF.text!.isEmptyStr else {
            passwordTF.showError(message: passwordMessage)
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
    
    @IBAction func login(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

