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
    
    
    static func  safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(
            of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(
            of: "@", with: "-")
        return safeEmail
    }

}



struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(
            of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(
            of: "@", with: "-")
        return safeEmail
    }
    
    // added images
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
//    let profilePictureUrl: String
}



extension DatabaseManager {
    
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        print(user.safeEmail)
        database.child(user.safeEmail).setValue([
            "Имя": user.firstName,
            "Фамилия": user.lastName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Ошибка записи в базу данных")
                completion(false)
                return
            }
            
            
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // добавить
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection , withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                    
                } else {
                    // создать массив
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    public func userExists(
        with email: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        
        var safeEmail = email.replacingOccurrences(
            of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(
            of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(
            of: .value, with: { snapshot in
                guard snapshot.value as? String != nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            })
    }
    
}
