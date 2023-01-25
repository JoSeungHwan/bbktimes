//
//  Login.swift
//  bbktimes
//
//  Created by 조승환 on 2023/01/03.
//

import Foundation
import Alamofire

struct Login: Encodable {
    let ID: String
    let password: String
}
