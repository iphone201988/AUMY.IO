//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: DTTextField!
    @IBOutlet weak var passwordTF: DTTextField!
    
    let firstNameMessage        = NSLocalizedString("First name is required.", comment: "")
    let lastNameMessage         = NSLocalizedString("Last name is required.", comment: "")
    let emailMessage            = NSLocalizedString("Email is required.", comment: "")
    let passwordMessage         = NSLocalizedString("Password is required.", comment: "")
    let confirmPasswordMessage  = NSLocalizedString("Confirm password is required.", comment: "")
    let mismatchPasswordMessage = NSLocalizedString("Password and Confirm password are not matching.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([emailTF, passwordTF])
        setEditableTextFieldFont([emailTF, passwordTF])
        customPlaceHolder([emailTF, passwordTF])
    }
    
    func validateData() -> Bool {
        
        guard !emailTF.text!.isEmptyStr else {
            emailTF.showError(message: emailMessage)
            return false
        }
        
        guard !passwordTF.text!.isEmptyStr else {
            passwordTF.showError(message: passwordMessage)
            return false
        }
        
        return true
    }
    
    @IBAction func login(_ sender: InterButton) {
        guard validateData() else { return }
        
        let storyboard = AppStoryboards.main.storyboardInstance
        let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarsVC") as! TabbarsVC
        SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
    }
    
    @IBAction func signup(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: SignupVC.self, isAnimated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

