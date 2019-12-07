//
//  EditingReviewViewController.swift
//  MovieApp
//
//  Created by Anastasia on 12/7/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class EditingReviewViewController: UIViewController {
    @IBOutlet weak var reviewTitleTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var reviewTitle: String?
    var review: Review!
    var movie: Movie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if review == nil{
            review = Review()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromReview"{
            review.title = reviewTitleTextField.text!
            review.review = reviewTextField.text!
        }
    }
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveThenSegue(){
        review.title = reviewTitleTextField.text!
        review.review = reviewTextField.text!
        review.saveData(movie: movie){(success) in
            if success {
                self.leaveViewController()
            }else{
                print ("*** ERROR Counldn't leave this  View Controller because data wasn't saved")
            }
        }
    }

    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveThenSegue()
    }
    
}
