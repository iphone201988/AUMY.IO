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
    
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var appleSpaciousView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var googleSpaciousView: UIView!
    @IBOutlet weak var orView: UIImageView!
    @IBOutlet weak var orSpaciousView: UIView!
    
    let firstNameMessage        = NSLocalizedString("First name is required.", comment: "")
    let lastNameMessage         = NSLocalizedString("Last name is required.", comment: "")
    let emailMessage            = NSLocalizedString("Email is required.", comment: "")
    let passwordMessage         = NSLocalizedString("Password is required.", comment: "")
    let confirmPasswordMessage  = NSLocalizedString("Confirm password is required.", comment: "")
    let mismatchPasswordMessage = NSLocalizedString("Password and Confirm password are not matching.", comment: "")

    var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([emailTF, passwordTF])
        setEditableTextFieldFont([emailTF, passwordTF])
        customPlaceHolder([emailTF, passwordTF])
        
        switch Constants.role {
        case .serviceProvider:
            appleView.isHidden = true
            appleSpaciousView.isHidden = true
            googleView.isHidden = true
            googleSpaciousView.isHidden = true
            orView.isHidden = true
            orSpaciousView.isHidden = true
            
        case .user:
            appleView.isHidden = false
            appleSpaciousView.isHidden = false
            googleView.isHidden = false
            googleSpaciousView.isHidden = false
            orView.isHidden = false
            orSpaciousView.isHidden = false
        }
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
        let params = [
            "email": emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "password": passwordTF.text ?? "",
            "deviceType": Constants.deviceType,
            "deviceToken": UserDefaults.standard[.deviceToken] ?? "123",
            //"role": Constants.role.type
        ] as [String : Any]
        Task { await login(params) }
    }
    
    @IBAction func signup(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: SignupVC.self, isAnimated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginVC {
    fileprivate func login(_ params: [String: Any]) async {
        let res = await RemoteRequestManager.shared.dataTask(endpoint: .login,
                                                             model: UserDetails.self,
                                                             params: params,
                                                             method: .post,
                                                             body: .rawJSON)
        await MainActor.run {
            switch res {
            case .failure(let err):
                Toast.show(message: err.localizedDescription)
                
            case .success(let details):
                if let user = details.user {
                    UserDefaults.standard[.loggedUserDetails] = user
                }
                
                if let token = details.token {
                    UserDefaults.standard[.accessToken] = token
                }
                
                let storyboard = AppStoryboards.main.storyboardInstance
                let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarsVC") as! TabbarsVC
                SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
            }
        }
    }
}
