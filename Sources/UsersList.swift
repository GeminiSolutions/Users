//
//  UsersList.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class UsersList: DataStoreContentJSONArray<User.JSONObjectType> {
    public override init() {
        super.init()
    }

    public init(usersData: [(user: User.JSONObjectType, id: User.UserIdType, lastUpdate: Date)]) {
        let users = usersData.map({ return ["user":$0.user, "id":User.stringFromUserId($0.id), "lastUpdate":UsersList.dateString(from: $0.lastUpdate)] })
        super.init(json: users)
    }

    public func users<UserType: User>() -> [UserType] {
        var users: [UserType] = []
        content.forEach {
            if let user: UserType = user(from: $0) { users.append(user) }
        }
        return users
    }
    
    public func user<UserType: User>(for id: User.UserIdType) -> UserType? {
        for data in content {
            if let idStr = data["id"] as? String, let userId = User.userIdFromString(idStr), userId == id {
                return user(from: data)
            }
        }
        return nil
    }

    public func append(user: User) {
        guard let id = user.id, let lastUpdate = user.lastUpdate else { return }
        append(["user":user.content, "id":User.stringFromUserId(id), "lastUpdate":UsersList.dateString(from: lastUpdate)])
    }

    private func user<UserType: User>(from data: [String:Any]) -> UserType? {
        guard let content = data["user"] as? User.JSONObjectType, let id = data["id"] as? String, let lastUpdate = data["lastUpdate"] as? String else { return nil }
        guard let userId = User.userIdFromString(id), let userLastUpdate = UsersList.date(from: lastUpdate) else { return nil }
        guard let user = UserType(content: content) else { return nil }
        user.id = userId
        user.lastUpdate = userLastUpdate
        return user
    }
}
