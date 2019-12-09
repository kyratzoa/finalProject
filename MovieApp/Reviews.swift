//
//  Reviews.swift
//  MovieApp
//
//  Created by Anastasia on 12/7/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase

class Reviews{
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    func loadData(movie: Movie, completed: @escaping () -> ()){
        guard movie.documentID != "" else {
            return
        }
        db.collection("movies").document(movie.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = []
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
