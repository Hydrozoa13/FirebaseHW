//
//  User.swift
//  FirebaseHW
//
//  Created by Евгений Лойко on 13.11.23.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        uid = user.uid
        email = user.email ?? ""
    }
}
