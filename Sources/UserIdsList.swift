//
//  UserIdsList.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class UserIdsList: DataStoreContentJSONArray<User.UserIdType> {
    public var userIds: [User.UserIdType] {
        return content
    }

    public override init() {
        super.init()
    }

    public init(ids: [User.UserIdType]) {
        super.init(json: ids)
    }
}
