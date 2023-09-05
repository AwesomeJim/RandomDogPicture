//
//  BreedsListResponse.swift
//  RandDog
//
//  Created by James Mbugua on 09/01/2021.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String: [String]]
}
