//
//  UserDetails.swift
//  AUMY.IO
//
//  Created by iOS Developer on 15/10/25.
//

struct UserDetails: Codable {
    let success: Bool?
    let message, userId, email: String?
    let role: Int?
}
