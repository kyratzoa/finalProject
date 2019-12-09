//
//  MoviewDetailViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = movie.title
        overviewTextView.text = movie.overview
        ratingLabel.text = "\(movie.vote_average)"
        releaseDateLabel.text = movie.release_date

        
        //add border to overviewtextview
        backgroundImage.dowloadFromServer(url: URL(string: "\(movie.poster_path)")!)
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayTrailerSegue"{
            let destination = segue.destination as! PlayTrailerViewController
            destination.movie = movie.title
        }
    }

    @IBAction func detailTapped(_ sender: UITapGestureRecognizer) {
        if self.detailView.frame.origin.y == 725{
            UIView.animate(withDuration: 2.0) {
                self.detailView.frame.origin.y = self.detailView.frame.origin.y - 400
            }
        }else{
            UIView.animate(withDuration: 2.0) {
                self.detailView.frame.origin.y = self.detailView.frame.origin.y + 400
            }
        }

    }
}

