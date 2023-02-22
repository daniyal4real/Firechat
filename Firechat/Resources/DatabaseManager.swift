//
//  DatabaseManager.swift
//  Firechat
//
//  Created by Daniyal Ganiuly on 22.02.2023.
//

import Foundation
import FirebaseDatabase



final class DatabaseManager {
    static let shared = DatabaseManager()
    
    
    private let database = Database.database().reference()

    public func test() {
        database.child("test").setValue(
            ["something": true])
    }
    
    
    

}



struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
//    let profilePictureUrl: String
}



extension DatabaseManager {
    
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "Имя": user.firstName,
            "Фамилия": user.lastName
        ])
    }
    
    
    public func userExists(
        with email: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        database.child(email).observeSingleEvent(
            of: .value, with: { snapshot in
                guard snapshot.value as? String != nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            })
    }
    
}
