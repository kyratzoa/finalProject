//
//  ReviewViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/6/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Review"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        //cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
