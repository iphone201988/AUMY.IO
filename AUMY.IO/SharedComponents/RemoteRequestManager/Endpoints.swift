//
//  Endpoints.swift
//  AUMY.IO
//
//  Created by iOS Developer on 15/10/25.
//

enum Endpoints: String {
    case signup = "common/signup"
    case login  = "common/login"
    case accountVerify = "common/account-verify"
    case completeOnboarding = "common/complete-onboarding"
    case getUser = "common/get-user"
}

enum HttpMehtods: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum HttpBodyType: String {
    case formData
    case urlEncoded
    case rawJSON
    case binary
    case graphQL
}
