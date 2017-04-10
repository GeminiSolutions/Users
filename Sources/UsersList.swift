//
//  UsersList.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class UsersList: DataStoreContentJSONArray<User.JSONObjectType> {
    public var users: [User] {
        var users: [User] = []
        content.forEach {
            guard let user = User(content: $0) else { return }
            users.append(user)
        }
        return users
    }

    public override init() {
        super.init()
    }

    public init(users: [User.JSONObjectType]) {
        super.init(json: users)
    }

    public func user(for id: User.UserIdType) -> User? {
        for userContent in content {
            guard let user = User(content: userContent) else { continue }
            guard user.id != id else { return user }
        }
        return nil
    }

    public func append(user: User) {
        append(user.content)
    }

    public func remove(user: User) {
        guard let id = user.id else { return }
        remove(userWithId: id)
    }

    public func remove(userWithId id: User.UserIdType) {
        if let index = content.index(where: {
            guard let user = User(content: $0) else { return false }
            return user.id == id
        }) { remove(at: index) }
    }
}
