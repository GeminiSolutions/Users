//
//  User.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class User: DataStoreContentJSONDictionary<String,Any> {
    public typealias UserIdType = Int
    public typealias JSONObjectType = [String:Any]

    public var lastModified: Date?

    public var id: UserIdType?

    public var name: String? {
        get {
            return content["name"] as? String
        }
        set {
            set(newValue, for: "name")
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

    public override init() {
        super.init()
    }

    public init?(content: JSONObjectType) {
        guard User.validate(content) else { return nil }
        super.init(json: content)
    }

    class public func userIdFromString(_ string: String) -> UserIdType? {
        return UserIdType(string)
    }

    class public func stringFromUserId(_ userId: UserIdType) -> String? {
        return String(userId)
    }
    
    class public func validate(_ json: JSONObjectType) -> Bool {
        guard json.keys.contains("name") else { return false }
        guard json.keys.contains("password") else { return false }
        return true
    }
}
