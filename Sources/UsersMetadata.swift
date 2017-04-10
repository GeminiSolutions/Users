//
//  UsersMetadata.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class UsersMetadata: DataStoreContentJSONDictionary<String,Any> {
    public typealias JSONObjectType = [String:Any]

    public override init() {
        super.init()
    }

    public init?(content: JSONObjectType) {
        guard UsersMetadata.validate(content) else { return nil }
        super.init(json: content)
    }

    public var tags: [String]? {
        get {
            return content["tags"] as? [String]
        }
        set {
            set(newValue, for: "tags")
        }
    }

    class public func validate(_ json: JSONObjectType) -> Bool {
        return true
    }
}
