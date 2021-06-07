//
//  AddNewFeedViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

protocol AddNewFeedViewControllerDelegate:AnyObject {
    func saveFeed(_ feedURL:String, feedName:String)
}

class AddNewFeedViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    
    
    weak var actionDelegate:AddNewFeedViewControllerDelegate?
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTextFields()
        configureTapGesture()
    }
    
    //MARK: Actions
    @IBAction private func addFeed(_ sender: Any) {
        view.endEditing(true)
        
        guard let feedUrl = urlTextField.text, let feedName = nameTextField.text else {
            return
        }
        
        actionDelegate?.saveFeed(feedUrl, feedName: feedName)
        dismiss(animated: true)
    }
    
    @IBAction private func dismissView(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Functions
extension AddNewFeedViewController {
    //Configuration for screen Tap Gesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewFeedViewController.handleTap))
        view.addGestureRecognizer(tapGesture )
    }
    //OBJC Function to end editing and hide keyboard
    @objc func handleTap() {
        view.endEditing(true)
    }
}

//MARK: Text Field
extension AddNewFeedViewController: UITextFieldDelegate {
    
    //Text Fields Configuration
    private func configureTextFields() {
        nameTextField.delegate = self
        urlTextField.delegate = self
        
        //Make button disabled while textfields are empty
        if (nameTextField.text != nil) && (urlTextField.text != nil) {
            addButton.isUserInteractionEnabled = false
            addButton.alpha = 0.6
        }
    }
    
    //Go to next TextField after pressing return
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.nameTextField:
            self.urlTextField.becomeFirstResponder()
        case self.urlTextField:
            self.urlTextField.resignFirstResponder()
        default:
            self.urlTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Make button disabled while Text Fields are empty and enable once user press return after filling both fields.
        if (nameTextField.text != nil) && (urlTextField.text != nil) {
            addButton.isUserInteractionEnabled = true
            addButton.alpha = 1.0
        } else {
            addButton.isUserInteractionEnabled = false
        }
    }
}
