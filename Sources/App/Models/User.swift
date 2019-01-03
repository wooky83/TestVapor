//
//  User.swift
//  App
//
//  Created by wooky83 on 09/05/2018.
//

import Foundation
import FluentMySQL
import Vapor
import Authentication

final class User: Codable {
    var id: UUID?
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}

extension User: MySQLUUIDModel {}
extension User: Migration {}
extension User: Content {}
extension User: Parameter {}
extension User {
    var favorites: Children<User, Favorite> {
        return children(\.userId)
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.name
    static let passwordKey: PasswordKey = \User.password
}

extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}


