//
//  UsersClient.swift
//  Users
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public enum UsersClientError: Error {
    case invalidUserId
}

public typealias UserIdsList = DataStoreItemIdsListJSON<User.UserIdType>
public typealias UsersCount = DataStoreItemsCountJSON

public class UsersClient {
    public typealias ErrorBlock = (Error?) -> Void
    public typealias UInt64Block = (UInt64, Error?) -> Void
    public typealias UserBlock = (User, Error?) -> Void
    public typealias UsersBlock = ([User], Error?) -> Void
    public typealias UserIdsBlock = ([User.UserIdType], Error?) -> Void
    public typealias UsersTagsBlock = ([String], Error?) -> Void

    public var authToken: String? {
        get { return dataStore.authToken }
        set { dataStore.authToken = newValue }
    }

    private var dataStore: DataStoreClient

    private func query(from searchString: String, tags: [String]) -> [String:String] {
        var query = [String:String]()
        query["name"] = searchString
        if tags.count > 0 { query["tags"] = tags.reduce("", { ($0.isEmpty ? "" : $0+",") + $1 }) }
        return query
    }

    public init(transport: DataStoreClientTransport) {
        dataStore = DataStoreClient(transport: transport, basePath: "/users")
    }

    public func usersCount(completion: @escaping UInt64Block) {
        let usersCount = UsersCount()
        dataStore.getItemsCount(usersCount, { (error) in
            completion(usersCount.value, error)
        })
    }

    public func usersIds(range: Range<Int>?, completion: @escaping UserIdsBlock) {
        let userIdsList = UserIdsList()
        dataStore.getItemsIdentifiers(range, userIdsList, { (error) in
            completion(userIdsList.itemIds, error)
        })
    }

    public func usersTags(completion: @escaping UsersTagsBlock) {
        let usersMetadata = UsersMetadata()
        dataStore.getItemsMetadata(usersMetadata, { (error) in
            completion(usersMetadata.tags ?? [], error)
        })
    }

    public func search(for searchString: String, tags: [String], range: Range<Int>?, completion: @escaping UsersBlock) {
        let usersList = UsersList()
        dataStore.getItems(query(from: searchString, tags: tags), range, usersList, { (error) in
            completion(usersList.users, error)
        })
    }

    public func add(user: User, completion: @escaping UserBlock) {
        let newUser = User()
        dataStore.createItem(user, newUser, { (metadata, error) in
            completion(newUser, error)
        })
    }

    public func getUser(with userId: User.UserIdType, completion: @escaping UserBlock) {
        let user = User()
        guard let itemId = User.stringFromUserId(userId) else {
            completion(user, UsersClientError.invalidUserId)
            return
        }
        dataStore.getItem(id: itemId, user, { (metadata, error) in
            completion(user, error)
        })
    }

    public func update(user: User, completion: @escaping UserBlock) {
        let newUser = User()
        guard let userId = user.id, let itemId = User.stringFromUserId(userId) else {
            completion(newUser, UsersClientError.invalidUserId)
            return
        }
        dataStore.updateItem(id: itemId, user, newUser, { (error) in
            completion(newUser, error)
        })
    }

    public func remove(userId: User.UserIdType, completion: @escaping ErrorBlock) {
        guard let itemId = User.stringFromUserId(userId) else {
            completion(UsersClientError.invalidUserId)
            return
        }
        dataStore.removeItem(id: itemId, { (error) in
            completion(error)
        })
    }
}
