//
//  User.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

open class User: DataStoreContentJSONDictionary<String,Any> {
    public typealias UserIdType = Int
    public typealias JSONObjectType = [String:Any]

    public var id: UserIdType?
    public var lastUpdate: Date?

    public var username: String? {
        get {
            return content["username"] as? String
        }
        set {
            set(newValue, for: "username")
        }
    }

    public var password: String? {
        get {
            return content["password"] as? String
        }
        set {
            set(newValue, for: "password")
        }
    }

    public var tags: [String]? {
        get {
            return content["tags"] as? [String]
        }
        set {
            set(newValue, for: "tags")
        }
    }

    override public required init() {
        super.init()
    }

    public required init?(content: JSONObjectType) {
        guard User.validate(content) else { return nil }
        super.init(json: content)
    }

    class public func userIdFromString(_ string: String) -> UserIdType? {
        return UserIdType(string)
    }

    class public func stringFromUserId(_ userId: UserIdType) -> String {
        return String(userId)
    }
    
    class open func validate(_ json: JSONObjectType) -> Bool {
        guard json.keys.contains("username") else { return false }
        guard json.keys.contains("password") else { return false }
        return true
    }

    class open var Fields: [[String:Any]] {
        return [["name":"username", "label": "Username", "type":"String", "required":"true"],
                ["name":"password", "label": "Password", "type":"String", "required":"true"],
                ["name":"tags", "label": "Tags", "type":"Array<String>", "required":"false"]]
    }
}
