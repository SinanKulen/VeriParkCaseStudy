//
//  AuthModel.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 8.11.2021.
//

import Foundation

struct AuthModel: Codable {
    let aesKey: String
    let aesIV: String
    let authorization: String
    let lifeTime: String
}
