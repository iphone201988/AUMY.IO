import Foundation

actor InputFieldValidator {
    
    static let shared = InputFieldValidator()
    
    enum ValidationError: Error, CustomStringConvertible {
        case invalidEmail
        case weakPassword
        case passwordMismatch
        case emptyField(field: String)
        case invalidPhoneNumber
        
        var description: String {
            switch self {
            case .invalidEmail: return "Email is not valid."
            case .weakPassword: return "Password must be at least 6 characters."
            case .passwordMismatch: return "Passwords do not match."
            case .emptyField(let field): return "\(field) cannot be empty."
            case .invalidPhoneNumber: return "Phone number is invalid."
            }
        }
    }
    
    enum InputField {
        case email(String)
        case newPassword(String)
        case confirmPassword(String, original: String)
        case fullName(String)
        case firstName(String)
        case lastName(String)
        case phoneNumber(String)
        
        var fieldName: String {
            switch self {
            case .email: return "Email"
            case .newPassword: return "Password"
            case .confirmPassword: return "Confirm Password"
            case .fullName: return "Full Name"
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .phoneNumber: return "Phone Number"
            }
        }
        
        var value: String {
            switch self {
            case
                    .email(let v),
                    .newPassword(let v),
                    .fullName(let v),
                    .firstName(let v),
                    .lastName(let v),
                    .phoneNumber(let v):
                return v
            case .confirmPassword(let v, _):
                return v
            }
        }
        
        var isEmpty: Bool {
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    func validate(_ fields: [InputField]) async throws {
        for field in fields {
            if field.isEmpty {
                throw ValidationError.emptyField(field: field.fieldName)
            }
            
            switch field {
            case .email(let email):
                guard email.isEmail else { throw ValidationError.invalidEmail }
                
            case .newPassword(let password):
                guard password.count >= 6 else { throw ValidationError.weakPassword }
                
            case .confirmPassword(let confirm, let original):
                guard confirm == original else { throw ValidationError.passwordMismatch }
                
            case .phoneNumber(let number):
                guard number.isPhoneNumber else { throw ValidationError.invalidPhoneNumber }
                
            case .fullName, .firstName, .lastName: break
            }
        }
    }
}

extension String {
    
    var isEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return checkRegEx(for: self, regEx: regex)
    }
    
    var isPassword: Bool {
        return checkRegEx(for: self, regEx: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
    }
    
    var isPhoneNumber: Bool {
        let regex = "^[0-9]{10}$"
        return checkRegEx(for: self, regEx: regex)
    }
    
    private func checkRegEx(for string: String, regEx: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}


// MARK: - USUAGE -

//Task {
//    do {
//        try await InputFieldValidator.shared.validate([.email("mac@domain.com"), .newPassword("123")])
//        LogHandler.debugLog("All inputs are valid ✅")
//    } catch {
//        if let validationError = error as? InputFieldValidator.ValidationError {
//            LogHandler.debugLog("Validation error: \(validationError.description)")
//        } else {
//            LogHandler.debugLog("Validation error: \(error.localizedDescription)")
//        }
//    }
//}
