//
//  ViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/4/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit


class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var movies = Movies()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        segmentedControlChanged()
        
        movies.getNowPlayingMovies{
            self.tableView.reloadData()
        }
        movies.getTopRated {
            self.tableView.reloadData()
        }
    }
    
    func loadData(loadAll: Bool){
        if movies.apiURL.hasPrefix("http"){
            UIApplication.shared.beginIgnoringInteractionEvents()
            movies.getNowPlayingMovies {
                self.tableView.reloadData()
                //self.navigationItem.title = "\(self.pokemon.pokeArray.count) of  \(self.pokemon.totalPokemon) Pokemon loaded"
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if loadAll{
                    self.loadData(loadAll: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! MovieDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            if segmentedControl.selectedSegmentIndex == 0 {
                destination.movie = movies.nowPlayingMovieArray[selectedIndexPath.row]
            }else{
                destination.movie = movies.topRatedMovieArray[selectedIndexPath.row]
            }
            
        }else{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    

    func segmentedControlChanged(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.navigationItem.title = "Now Playing"
        case 1:
            self.navigationItem.title = "Top rated"
        default:
            print("ERROR: This is for the default value of the segemented control")
        }
        tableView.reloadData()
    }
        
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        segmentedControlChanged()
    }
    
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return movies.nowPlayingMovieArray.count
        }else{
            return movies.topRatedMovieArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        if segmentedControl.selectedSegmentIndex == 0{
            cell.titleLabel.text = movies.nowPlayingMovieArray[indexPath.row].title
            cell.overviewLabel.text = movies.nowPlayingMovieArray[indexPath.row].overview
            cell.posterView.dowloadFromServer(url: URL(string: "\(movies.nowPlayingMovieArray[indexPath.row].poster_path)")!)
        }else{
            cell.titleLabel.text = movies.topRatedMovieArray[indexPath.row].title
            cell.overviewLabel.text = movies.topRatedMovieArray[indexPath.row].overview
            cell.posterView.dowloadFromServer(url: URL(string: "\(movies.topRatedMovieArray[indexPath.row].poster_path)")!)
            if indexPath.row == movies.topRatedMovieArray.count - 1 && movies.topRatedMovieArray[indexPath.row].page != movies.topRatedMovieArray[indexPath.row].total_pages{
                movies.getTopRated {
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
