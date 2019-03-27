//
//  UserRepository.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 19/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserRepository {
    func signIn(with email: String,
                password: String,
                completion: @escaping (_ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(error)
                return
            }
        }
    }
    
    func createAndStoreUser(_ user: User, data: Data, completion: @escaping (() -> ())) {
        //Database.database().isPersistenceEnabled = true
        Auth.auth().createUser(withEmail: user.email, password: user.password, completion: { (createdUser, error) in
//            if error != nil {
//                self.workerDelegate?.sendError(error)
//                return
//            }
            
            guard let userID = Auth.auth().currentUser?.uid else  {
                return
            }
            
            let values = ["email": user.email,
                          "password": user.password]
            let ref = Database.database().reference(fromURL: "https://drumspracticeplayer.firebaseio.com/")
            
            let userReference = ref.child("users").child(userID)
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                //            if error != nil {
                //                self.workerDelegate?.sendError(error)
                //                return
                //            }
                completion()
            })
        })
    }
    
    private func registerUserIntoDatabase(userId: String, values: [String: Any], completion: @escaping (() -> ())) {
        
    }
}
