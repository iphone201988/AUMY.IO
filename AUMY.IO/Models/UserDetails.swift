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
    let countryCode, houseNumber, street, apartment: String?
    let floor: String?
    let isActive, onBoardingProfile: Bool?
    let profileImage: String?
    let role: Int?
    let isAccountVerified: Bool?
    let createdAt, updatedAt, isApproved: String?
    let document, backgroundCheckCertificate: String?
    let stripeStatus: StripeStatus?
    let providerData: ProviderData?
}

// MARK: - ProviderData
struct ProviderData: Codable {
    let statistics: Statistics?
}

// MARK: - Statistics
struct Statistics: Codable {
    let totalServices, totalBookings, completedBookings, pendingBookings: Int?
    let confirmedBookings, cancelledBookings, averageRating, totalEarnings: Int?
    let completionRate: Int?
}

// MARK: - StripeStatus
struct StripeStatus: Codable {
    let hasStripeAccount, isConnected: Bool?
    let stripeAccountId: String?
}
