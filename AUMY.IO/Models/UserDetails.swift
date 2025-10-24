//
//  UserDetails.swift
//  AUMY.IO
//
//  Created by iOS Developer on 15/10/25.
//



import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    let success: Bool?
    let message, token: String?
    let user: UserData?
}

// MARK: - UserData
struct UserData: Codable {
    let _id, name, email, phoneNumber: String?
    let countryCode: String?
    let role: Int?
    let onBoardingProfile: Bool?
}
