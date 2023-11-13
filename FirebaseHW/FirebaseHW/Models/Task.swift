//
//  Task.swift
//  FirebaseHW
//
//  Created by Евгений Лойко on 13.11.23.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    var completed: Bool = false
    let ref: DatabaseReference!
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    func convertToDictionary() -> [String: Any] {
        [Constants.titleKey: title,
         Constants.userIdKey: userId,
         Constants.completedKey: completed]
    }
    
    private enum Constants {
        static let titleKey = "title"
        static let userIdKey = "userId"
        static let completedKey = "completed"
    }
}
