//
//  Users.swift
//  MovieApp
//
//  Created by Anastasia on 12/7/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase

class MovieUsers{
    var movieUserArray = [MovieUser]()
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("users").addSnapshotListener{ (querySnapshot, error) in
            guard error == nil else{
                print("ERROR: adding snapshotListener \(error!.localizedDescription)")
                return completed()
            }
            self.movieUserArray = []
            for document in querySnapshot!.documents{
                let movieUser = MovieUser(dictionary: document.data())
                movieUser.documentID = document.documentID
                self.movieUserArray.append(movieUser)
            }
            completed()
        }
    }
}
