//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField
import CountryPickerView

class SignupVC: UIViewController {
    
    @IBOutlet weak var nameTF: DTTextField!
    @IBOutlet weak var emailTF: DTTextField!
    @IBOutlet weak var phoneCodeTF: DTTextField!
    @IBOutlet weak var phoneNoTF: DTTextField!
    @IBOutlet weak var passwordTF: DTTextField!
    @IBOutlet weak var countryPickerView: CountryPickerView!
    
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
    
    fileprivate var selectedPhoneCode = ""
    
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
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        // Hide any visible text (name/code/phone) in the picker view
        countryPickerView.showCountryCodeInView = false
        countryPickerView.showPhoneCodeInView = false
        countryPickerView.showCountryNameInView = false
        countryPickerView.flagImageView.isHidden = true
        
        // Set current locale's country as default
        let currentCountry = countryPickerView.getCountryByCode(Locale.current.region?.identifier ?? "US")
        if let country = currentCountry {
            selectedPhoneCode = country.phoneCode
        }
    }

    func validateData() -> Bool {
        // MARK: - 1️⃣ Name
        guard !nameTF.text!.isEmptyStr else {
            nameTF.showError(message: nameMessage)
            return false
        }
        
        guard nameTF.text?.count ?? 0 >= 2 else {
            nameTF.showError(message: "Name should be at least 2 characters.")
            return false
        }
        
        // MARK: - 2️⃣ Email
        guard !emailTF.text!.isEmptyStr else {
            emailTF.showError(message: emailMessage)
            return false
        }
        
        guard SharedMethods.shared.isValidEmail(emailTF.text ?? "") else {
            emailTF.showError(message: "Please enter a valid email address.")
            return false
        }
        
        // MARK: - 3️⃣ Phone
        guard !phoneNoTF.text!.isEmptyStr else {
            phoneNoTF.showError(message: phoneMessage)
            return false
        }
        
        guard SharedMethods.shared.isValidPhone(phoneNoTF.text ?? "") else {
            phoneNoTF.showError(message: "Please enter a valid phone number.")
            return false
        }
        
        // MARK: - 4️⃣ Password
        guard !passwordTF.text!.isEmptyStr else {
            passwordTF.showError(message: passwordMessage)
            return false
        }
        
        guard passwordTF.text?.count ?? 0 >= 6 else {
            passwordTF.showError(message: "Password must be at least 6 characters long.")
            return false
        }
        
        return true
    }
    
    @IBAction func signup(_ sender: InterButton) {
        guard validateData() else { return }
        let params = [
            "email": emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "password": passwordTF.text ?? "",
            "name": nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "phoneNumber": phoneNoTF.text ?? "",
            "countryCode": phoneCodeTF.text ?? "",
            "deviceType": Constants.deviceType,
            "deviceToken": UserDefaults.standard[.deviceToken] ?? "123",
            "role": Constants.role.type
        ] as [String : Any]
        Task { await signup(params) }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: Delegates and DataSources
extension SignupVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let phoneCode = country.phoneCode
        selectedPhoneCode = phoneCode
        phoneCodeTF.text = phoneCode
    }
}

extension SignupVC {
    fileprivate func signup(_ params: [String: Any]) async {
        let res = await RemoteRequestManager.shared.dataTask(endpoint: .signup,
                                                             model: UserDetails.self,
                                                             params: params,
                                                             method: .post,
                                                             body: .rawJSON)
        await MainActor.run {
            switch res {
            case .failure(let err):
                Toast.show(message: err.localizedDescription)
                
            case .success:
                let sb = AppStoryboards.main.storyboardInstance
                let vc = sb.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                vc.email = emailTF.text ?? ""
                SharedMethods.shared.pushTo(destVC: vc, isAnimated: true)
            }
        }
    }
}
