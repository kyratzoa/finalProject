//
//  ViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/4/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var movies = Movies()
    var activityIndicator = UIActivityIndicatorView()
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authUI = FUIAuth.defaultAuthUI()
        auth?.delegate = self
        
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

extension TeamListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            tableView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
