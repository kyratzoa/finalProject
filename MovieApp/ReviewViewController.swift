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
    var reviewTitleArray = ["Bad", "Good", "Loved it"]
    var reviewArray = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Review"
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReview"{
            let distination = segue.destination as! EditingReviewViewController
            let index = tableView.indexPathForSelectedRow!.row
            distination.reviewTitle = reviewTitleArray[index]
            distination.review = reviewArray[index]
        }else{
            if let selectedPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }

    }
    
    @IBAction func unwindFromDetailController(segue: UIStoryboardSegue){
        let sourceViewController = segue.source as! EditingReviewViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            reviewTitleArray[indexPath.row] = sourceViewController.reviewTitle!
            reviewArray[indexPath.row] = sourceViewController.review!
            tableView.reloadRows(at: [indexPath], with:.automatic)
           } else{
            let newIndexPath = IndexPath(row: reviewTitleArray.count, section: 0)
            reviewTitleArray.append(sourceViewController.reviewTitle!)
            reviewArray.append(sourceViewController.review!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    

}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        cell.textLabel?.text = reviewTitleArray[indexPath.row]
        cell.detailTextLabel?.text = reviewArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
