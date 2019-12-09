//
//  Movies.swift
//  MovieApp
//
//  Created by Anastasia on 12/4/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage
import Firebase

class Movies{
    
    var nowPlayingMovieArray:[Movie] = []
    var totalMovies = 0
    var apiURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=8264fee68c32adbfc86a3b6f3c558e21"
    var posterBaseURL = "https://image.tmdb.org/t/p/w500"
    
    var topRatedMovieArray:[Movie] = []
    var topRatedAPI = "https://api.themoviedb.org/3/movie/top_rated?api_key=8264fee68c32adbfc86a3b6f3c558e21&page=1"
    var pageNumber = 1
    
     var db: Firestore!
    
    func getNowPlayingMovies(completed: @escaping () -> ()){
            Alamofire.request(apiURL).responseJSON {(response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let numberOfMovies = json["results"].count
                    
                    for index in 0...numberOfMovies-1{
                        let title = json["results"][index]["title"].stringValue
                        let vote_average = json["results"][index]["vote_average"].doubleValue
                        let overview = json["results"][index]["overview"].stringValue
                        let release_date = json["results"][index]["release_date"].stringValue
                        let poster_path = "\(self.posterBaseURL)\(json["results"][index]["poster_path"].stringValue)"
                        //let movieID = json["results"][index]["id"].stringValue
                        self.nowPlayingMovieArray.append(Movie(title: title, vote_average: vote_average, overview: overview, release_date: release_date, poster_path: poster_path, documentID: "", page: 0, total_pages: 0))
    
                    }
                case .failure(let error):
                    print("🙃🙃🙃 ERROR: failed to get data from url \(self.apiURL) error: \(error.localizedDescription)")
                }
                completed()
        }
    }
    
    func getTopRated(completed: @escaping () -> ()){
        Alamofire.request(topRatedAPI).responseJSON{(response) in
            switch response.result{
                case .success(let value):
                    self.pageNumber += 1
                    let json = JSON(value)
                    let numberOfMovies = json["results"].count
                    
                    if numberOfMovies > 0{
                        self.topRatedAPI = "https://api.themoviedb.org/3/movie/top_rated?api_key=8264fee68c32adbfc86a3b6f3c558e21&page=\(self.pageNumber)"
                    }else{
                        self.apiURL = ""
                    }
                    
                    for index in 0...numberOfMovies-1{
                        let title = json["results"][index]["title"].stringValue
                        let vote_average = json["results"][index]["vote_average"].doubleValue
                        let overview = json["results"][index]["overview"].stringValue
                        let release_date = json["results"][index]["release_date"].stringValue
                        let poster_path = "\(self.posterBaseURL)\(json["results"][index]["poster_path"].stringValue)"
                        let page = json["page"].intValue
                        let total_pages = json["total_pages"].intValue
                        //let movieID = json["results"][index]["id"].stringValue
                        self.topRatedMovieArray.append(Movie(title: title, vote_average: vote_average, overview: overview, release_date: release_date, poster_path: poster_path, documentID: "", page: page, total_pages: total_pages))
                    }
            case .failure(let error):
                print("🙃🙃🙃 ERROR: failed to get data from url \(self.apiURL) error: \(error.localizedDescription)")
            }
            completed()
        }
    }
}
