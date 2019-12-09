import Foundation
import Firebase

class Review{
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any]{
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date]
    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String ){
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewerUserID = dictionary["reviewerUserID"] as! String
        let time = dictionary["date"] as! Timestamp?
        let date = time?.dateValue() ?? Date()
        self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserID, date: date, documentID: "")
    }
    
    convenience init(){
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
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
                    print("*** ERROR updating document \(self.documentID) in movie \(movie.documentID) \(error.localizedDescription)")
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

