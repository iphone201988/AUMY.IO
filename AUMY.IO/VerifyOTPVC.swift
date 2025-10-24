//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class VerifyOTPVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var otp1TF: InterTextField!
    @IBOutlet weak var otp2TF: InterTextField!
    @IBOutlet weak var otp3TF: InterTextField!
    @IBOutlet weak var otp4TF: InterTextField!
    @IBOutlet weak var resendBtn: UIButton!
    
    // MARK: Variables
    private var countdownTimer: Timer?
    private var countdownSeconds = 60
    lazy var otpFields: [UITextField] = [otp1TF, otp2TF, otp3TF, otp4TF]
    var email = ""
    var event: Events = .forgotPassword
    
    // MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        otp1TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otp2TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otp3TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otp4TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otp1TF.becomeFirstResponder()
        
        //startCountdown()
    }
    
    // MARK: IB Actions
    @IBAction func verifyOTP(_ sender: UIButton) {
        let otp1 = otp1TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let otp2 = otp2TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let otp3 = otp3TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let otp4 = otp4TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if otp1.isEmpty || otp2.isEmpty || otp3.isEmpty || otp4.isEmpty {
            Toast.show(message: "All fields are required")
        } else {
            let otp = otp1 + otp2 + otp3 + otp4
            let _ = Int(otp) ?? 0
            let params = ["email": email, "otp": otp]
            Task { await accountVerify(params) }
        }
    }
    
    @IBAction func resendCode(_ sender: UIButton) {
        otp1TF.text = ""
        otp3TF.text = ""
        otp3TF.text = ""
        otp4TF.text = ""
        otp1TF.becomeFirstResponder()
        startCountdown()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Shared Methods
    func startCountdown() {
        // Set the initial countdown value
        countdownSeconds = 60
        // Create and start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateCountdown),
                                              userInfo: nil,
                                              repeats: true)
        // Update the label with the initial countdown value
        updateCountdownLabel()
        resendBtn.isUserInteractionEnabled = false
    }
    
    @objc func updateCountdown() {
        if countdownSeconds > 0 {
            countdownSeconds -= 1
            updateCountdownLabel()
        } else {
            // Invalidate the timer and enable the button
            countdownTimer?.invalidate()
            countdownTimer = nil
            resendBtn.isUserInteractionEnabled = true
            resendBtn.setTitle("Resend code", for: .normal)
        }
    }
    
    func updateCountdownLabel() {
        let timer = String(format: "00:%02d", countdownSeconds)
        resendBtn.setTitle("Resend code in \(timer)", for: .normal)
    }
    
    // MARK: Delegates and DataSources
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        if text.count >= 1 && text.count < 2 {
            switch textField {
            case otp1TF: otp2TF.becomeFirstResponder()
            case otp2TF: otp3TF.becomeFirstResponder()
            case otp3TF: otp4TF.becomeFirstResponder()
            case otp4TF: otp4TF.resignFirstResponder()
            default: break
            }
        } else if text.isEmpty {
            textField.text = " "
            switch textField {
            case otp1TF: otp1TF.becomeFirstResponder()
            case otp2TF: otp1TF.becomeFirstResponder()
            case otp3TF: otp2TF.becomeFirstResponder()
            case otp4TF: otp3TF.becomeFirstResponder()
            default: break
            }
        } else {
            if let lastCharacter = text.last {
                textField.text = String(lastCharacter)
                switch textField {
                case otp1TF: otp2TF.becomeFirstResponder()
                case otp2TF: otp3TF.becomeFirstResponder()
                case otp3TF: otp4TF.becomeFirstResponder()
                case otp4TF: otp4TF.resignFirstResponder()
                default: break
                }
            }
        }
    }
}

extension VerifyOTPVC {
    fileprivate func accountVerify(_ params: [String: Any]) async {
        let res = await RemoteRequestManager.shared.dataTask(endpoint: .accountVerify,
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
                
                switch Constants.role {
                case .serviceProvider:
                    SharedMethods.shared.pushToWithoutData(destVC: AboutYourServiceVC.self, isAnimated: true)
                    
                case .user:
                    SharedMethods.shared.pushToWithoutData(destVC: LocationPermissionVC.self, isAnimated: true)
                }
            }
        }
    }
}
