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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideo(videoCode: "bwzLiQZDw2I")
    }
    
    func getVideo(videoCode: String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        webView.load(URLRequest(url: url!))
    }

}
