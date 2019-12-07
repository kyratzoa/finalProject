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
    
    var reviewTitle: String?
    var review: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reviewTitle = reviewTitle{
            reviewTitleTextField.text = reviewTitle
        }
        if let review = review {
            reviewTextField.text = review
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromReview"{
            reviewTitle = reviewTitleTextField.text
            review = reviewTextField.text
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
}
