//
//  Review.swift
//  MovieApp
//
//  Created by Anastasia on 12/7/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase

class Review{
    var title: String
    var review: String
    var reviewerUserID: String
    var date: String
    var documentID: String
    
    var dictionary: [String: Any]{
        return ["title": title, "review": review, "reviewerUserID": reviewerUserID, "date": date]
    }
    
    init(title: String, review: String, rating: Int, reviewerUserID: String, date: String, documentID: String ){
        self.title = title
        self.review = review
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init(){
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", review: "", reviewerUserID: "",  date: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let review = dictionary["review"] as! String? ?? ""
        let reviewerUserID = dictionary["reviewerUserID"] as! String? ?? ""
        let date = dictionary["date"] as! String? ?? ""
        self.init(title: title, review: review, reviewerUserID: reviewerUserID, date: date, documentID: "")
    }
    

    
    func saveData(movie: Movie, completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        // Create dictionary representing the data that we want to save
        let dataToSave = self.dictionary
        // if we have saved a record we will have a doumentID
        if self.documentID != "" {
            let ref = db.collection("movies").document(movie.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR updating document \(self.documentID) in spot \(movie.documentID) \(error.localizedDescription)")
                    completed(false)
                } else{
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                }
            }
        }else{
            var ref: DocumentReference? = nil
            ref = db.collection("movies").document(movie.documentID).collection("reviews").addDocument(data: dataToSave){ error in
                if let error = error {
                    print("*** ERROR creating new document \(self.documentID) in movie \(movie.documentID) \(error.localizedDescription)")
                    completed(false)
                } else{
                    print("^^^ Document new doc created with ref ID \(ref?.documentID ?? "Unknown")")
                }
            }
        }
    }
    
    func deleteData(movie: Movie, completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        db.collection("movies").document(movie.documentID).collection("reviews").document(documentID).delete(){ error in
            if let error = error {
                print("😡😡😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
            }
        }
        
    }
    
}
