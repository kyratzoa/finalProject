//
//  PlayTrailerViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import WebKit

class PlayTrailerViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
        var movie: String!
        
        var youtubeCodeDictionary: [String: String] =
            ["Frozen II":"bwzLiQZDw2I",
             "The Irishman":"RS3aHkkfuEI",
             "Jumanji: The Next Level":"F6QaLsw8EWY",
             "Ad Astra":"BsCNKuB93BA",
             "Rambo: Last Blood":"km_L0v3C0ms",
             "It Chapter Two":"xhJ5P7Up3jA",
             "Terminator: Dark Fate":"oxy8udgWRmo",
             "Hustlers":"46XaikZ0FSw",
             "Knives Out":"xi-1NchUqMA",
             "Abominable":"XrgVtuDRBjM",
             "One Piece: Stampede":"S8_YwFLCh4U",
             "Trauma Center":"Y2DrOhVpPZo",
             "A Christmas Prince: The Royal Baby":"RK0zCsxBG3U",
             "Ford v Ferrari":"I3h9Z89U9ZA",
             "Angel Has Fallen":"isVtXH7n9lI",
             "Parasite":"5xH0HfJHsaY",
             "Downton Abbey":"tu3mP0c51hE",
             "Ready or Not":"ZtYTwUxhAoI",
             "Ellipse":"ZtYTwUxhAoI",
             "Gemini Man":"AbyJignbSj0",
             "Klaus":"taE3PwurhYM",
             "Daniel Isn't Real":"k4zOUxHxhXM",
             "Marriage Story": "BHi-a1n8t7M"]
        
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            titleLabel.text = "\(movie!) Trailer"
            
            let keyExists = youtubeCodeDictionary["\(movie!)"] != nil
            
            if keyExists{
                let index = youtubeCodeDictionary.index(forKey: "\(movie!)")
                getVideo(videoCode: youtubeCodeDictionary[index!].value)
            } else {
                errorLabel.text = "Couldn't find video."
            }
        }
        
        func getVideo(videoCode: String){
            let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
            webView.load(URLRequest(url: url!))
        }

    }
