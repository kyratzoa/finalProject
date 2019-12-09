//
//  Movie.swift
//  MovieApp
//
//  Created by Anastasia on 12/4/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase

class Movie {
    var title: String
    var vote_average: Double
    var overview: String
    var release_date: String
    var poster_path: String
    var page: Int
    var total_pages: Int
    var documentID: String
    
    
    var dictionary: [String: Any]{
        return ["title": title, "vote_average" : vote_average, "overview":overview, "release_date":release_date, "poster_path":poster_path, "documentID": documentID , "total_pages": total_pages, "page": page  ]
    }
    
    init(title: String, vote_average: Double, overview: String, release_date: String, poster_path: String, documentID: String, page: Int, total_pages: Int ){
        self.title = title
        self.vote_average = vote_average
        self.overview = overview
        self.release_date = release_date
        self.poster_path = poster_path
        self.documentID = documentID
        self.page = page
        self.total_pages = total_pages
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let vote_average = dictionary["vote_average"] as! Double? ?? 0.0
        let overview = dictionary["overview"] as! String? ?? ""
        let release_date = dictionary["release_date"] as! String? ?? ""
        let poster_path = dictionary["poster_path"] as! String? ?? ""
        let page = dictionary["page"] as! Int? ?? 0
        let total_pages = dictionary["total_pages"] as! Int? ?? 0
        let documentID = dictionary["documentID"] as! String? ?? ""

        self.init(title: title, vote_average: vote_average, overview: overview, release_date: release_date, poster_path: poster_path, documentID: documentID, page: page, total_pages:total_pages  )
    }
}
