//
//  AddNewFeedViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

class AddNewFeedViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTextFields()
        configureTapGesture()
        
        if ((nameTextField.text?.isEmpty) != nil) {
            addButton.isUserInteractionEnabled = false
            addButton.alpha = 0.6
        }
    }
    
    @IBAction func addFeed(_ sender: Any) {
        view.endEditing(true)
        feedList.append(FeedListModel(url: urlTextField.text!, title: nameTextField.text!))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadList"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: Functions
extension AddNewFeedViewController {
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewFeedViewController.handleTap))
        view.addGestureRecognizer(tapGesture )
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

//MARK: Text Field
extension AddNewFeedViewController: UITextFieldDelegate {
    
    private func configureTextFields() {
        nameTextField.delegate = self
        urlTextField.delegate = self
    }
    
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
        if (nameTextField.text != nil) && (urlTextField.text != nil) {
            addButton.isUserInteractionEnabled = true
            addButton.alpha = 1.0
        } else {
            addButton.isUserInteractionEnabled = false
        }
    }
}
