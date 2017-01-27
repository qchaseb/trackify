//
//  SignUpViewController.swift
//  Trackify
//
//  Created by Scott Buttinger on 1/26/17.
//  Copyright © 2017 Fire Apps Only. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - View Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAway()
        self.setTextFieldDelegates()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        self.scrollView.isScrollEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unregisterFromKeyboardNotifications()
    }
    
    // MARK: - Variables
    
    var activeField: UITextField?
    
    // MARK: - UI Elements
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Other Functions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if (firstNameTextField.text == "") {
            displayAlert("Missing First Name", message: "Please enter your first name.")
        } else if (lastNameTextField.text == "") {
            displayAlert("Missing Last Name", message: "Please enter your last name.")
        } else if (emailTextField.text == "" || !isValidEmail(testStr: emailTextField.text!)) {
            displayAlert("Invalid Email Address", message: "Please enter a valid email address.")
        } else if (passwordTextField.text == "") {
            displayAlert("Missing Password", message: "Please enter a valid password.")
        } else if (confirmTextField.text == "") {
            displayAlert("Missing Password Confirmation", message: "Please confirm your password.")
        } else if (passwordTextField.text! != confirmTextField.text!) {
            displayAlert("Password Mismatch", message: "Please confirm your password.")
            confirmTextField.text = ""
        }
    
        // push data to AWS and sign in
    }
    
    
    // set this class as the delegate for all user input text fields
    func setTextFieldDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    
    func registerForKeyboardNotifications(){
        // Add notifications for keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications(){
        // Remove notifications for keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // called anytime the keyboard appears on screen
    func keyboardWasShown(notification: NSNotification){
        keyboardWasShownHelper(notification: notification, scrollView: scrollView, activeField: activeField)
    }
    
    // called when the keyboard is about to be removed from the screen
    func keyboardWillBeHidden(notification: NSNotification){
        keyboardWillBeHiddenHelper(notification: notification, scrollView: scrollView, activeField: activeField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    // this function moves the cursor to the next text field upon hitting
    // return in the current text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField){
            case firstNameTextField: lastNameTextField.becomeFirstResponder()
            case lastNameTextField: emailTextField.becomeFirstResponder()
            case emailTextField: passwordTextField.becomeFirstResponder()
            case passwordTextField: confirmTextField.becomeFirstResponder()
            default: textField.resignFirstResponder()
        }
        return true
    }
}