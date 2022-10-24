//
//  SignUpViewController.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 23/07/22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var largeView: UIView!
    
    
    @IBOutlet weak var crerateAccountLabel: UILabel!
    
    @IBOutlet weak var createNewLabel: UILabel!
    
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var passView: UIView!
    
    @IBOutlet weak var conifrmView: UIView!
    
    @IBOutlet weak var alreadyValidationLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var alreadyLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var passLabel: UILabel!
    
    @IBOutlet weak var confirmLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var confirmField: UITextField!
    
    //fieldValidation Labels
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var phoneValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    
    @IBOutlet weak var confirmValidationLabel: UILabel!
    
    
    @IBOutlet weak var CreateAccountTapped: UIButton!
    
    
    //Height Constraints.
    
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    
    @IBOutlet weak var passHeight: NSLayoutConstraint!
    
    @IBOutlet weak var confirmPassHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topToCreateDistance: NSLayoutConstraint!
    
    @IBOutlet weak var createToStackDistance: NSLayoutConstraint!
    
    @IBOutlet weak var stackToButtonDistance: NSLayoutConstraint!
    
    
    @IBOutlet weak var buttonToAlreadyDistance: NSLayoutConstraint!
    
    var activeTextField: UITextField!
    var previousMovedDistance: CGFloat = 0
    
    let signUpVM = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        //        self.loadUsers()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let buttonGesture = UILongPressGestureRecognizer(target: self, action:  #selector (self.labelAction (_:)))
        buttonGesture.minimumPressDuration = 0
        self.loginLabel.addGestureRecognizer(buttonGesture)
        
        
    }
    
    @objc func labelAction(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            self.loginLabel.alpha = 0.5
            
        }
        if sender.state == .ended {
            self.loginLabel.alpha = 1
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func willEnterBackground() {
        let height = self.view.frame.height
        disableAllShadow()
        disableAllFieldUserInterraction()
        if nameField.text!.isEmpty {
            nameHeight.constant = height/300
        }
        if emailField.text!.isEmpty {
            emailHeight.constant = height/300
        }
        if phoneField.text!.isEmpty {
            phoneHeight.constant = height/300
        }
        if passField.text!.isEmpty {
            passHeight.constant = height/300
        }
        if confirmField.text!.isEmpty {
            confirmPassHeight.constant = height/300
        }
    }
    
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        hideAllValidationLabels()
        
        if fieldVerification() && signUpVM.isNewUser(email: emailField.text!) {
            if passField.text == confirmField.text && passField.text!.count >= 6 {
                if !nameField.text!.isEmpty && !emailField.text!.isEmpty {
                    signUpVM.saveNewUser(name: nameField.text!, email: emailField.text!, pass: passField.text!)
                    self.performSegue(withIdentifier: "toHomeFromSignUp", sender: self)
                }
            }
        }
        else if fieldVerification() && !signUpVM.isNewUser(email: emailField.text!) {
            alreadyValidationLabel.isHidden = false
        }
        
        disableAllShadow()
        disableAllFieldUserInterraction()
    }
    
    private func fieldVerification() -> Bool {
        
        var errorCount = 0
        
        if nameField.text!.isEmpty {
            errorCount += 1
            nameValidationLabel.isHidden = false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: emailField.text) {
            errorCount += 1
            emailValidationLabel.isHidden = false
        }
        if passField.text!.count < 6 {
            errorCount += 1
            passwordValidationLabel.isHidden = false
        }
        
        if passField.text != confirmField.text {
            errorCount += 1
            confirmValidationLabel.isHidden = false
        }
        
        if errorCount == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    
    private func initialSetUp() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        crerateAccountLabel.font = UIFont.boldSystemFont(ofSize: width/12)
        createNewLabel.font = UIFont.systemFont(ofSize: width/24)
        createNewLabel.textColor = .gray
        nameLabel.font = UIFont.systemFont(ofSize: width/30)
        nameLabel.textColor = .gray
        emailLabel.font = UIFont.systemFont(ofSize: width/30)
        emailLabel.textColor = .gray
        phoneLabel.font = UIFont.systemFont(ofSize: width/30)
        phoneLabel.textColor = .gray
        passLabel.font = UIFont.systemFont(ofSize: width/30)
        passLabel.textColor = .gray
        confirmLabel.font = UIFont.systemFont(ofSize: width/30)
        confirmLabel.textColor = .gray
        alreadyValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        alreadyLabel.font = UIFont.systemFont(ofSize: width/25)
        loginLabel.font = UIFont.systemFont(ofSize: width/25)
        
        topToCreateDistance.constant = height/50
        createToStackDistance.constant = height/30
        stackToButtonDistance.constant = height/50
        buttonToAlreadyDistance.constant = height/40
        
        nameValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        emailValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        phoneValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        passwordValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        confirmValidationLabel.font = UIFont.systemFont(ofSize: width/30)
        
        nameView.layer.cornerRadius = 10
        emailView.layer.cornerRadius = 10
        phoneView.layer.cornerRadius = 10
        passView.layer.cornerRadius = 10
        conifrmView.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
        
        nameField.borderStyle = UITextField.BorderStyle.none
        emailField.borderStyle = UITextField.BorderStyle.none
        passField.borderStyle = UITextField.BorderStyle.none
        phoneField.borderStyle = UITextField.BorderStyle.none
        confirmField.borderStyle = UITextField.BorderStyle.none
        
        nameHeight.constant = height/300
        emailHeight.constant = height/300
        phoneHeight.constant = height/300
        passHeight.constant = height/300
        confirmPassHeight.constant = height/300
        disableAllFieldUserInterraction()
        
        
        nameField.delegate = self
        emailField.delegate = self
        phoneField.delegate = self
        passField.delegate = self
        confirmField.delegate = self
        
        let gestureOne = UITapGestureRecognizer(target: self, action:  #selector (self.nameAction (_:)))
        self.nameView.addGestureRecognizer(gestureOne)
        
        let gestureTwo = UITapGestureRecognizer(target: self, action:  #selector (self.emailAction (_:)))
        self.emailView.addGestureRecognizer(gestureTwo)
        
        let gestureThree = UITapGestureRecognizer(target: self, action:  #selector (self.phoneAction (_:)))
        self.phoneView.addGestureRecognizer(gestureThree)
        
        let gestureFour = UITapGestureRecognizer(target: self, action:  #selector (self.passAction (_:)))
        self.passView.addGestureRecognizer(gestureFour)
        
        let gestureFive = UITapGestureRecognizer(target: self, action:  #selector (self.confirmAction (_:)))
        self.conifrmView.addGestureRecognizer(gestureFive)
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideAllValidationLabels()
        
        
    }
    
    private func hideAllValidationLabels() {
        nameValidationLabel.isHidden = true
        emailValidationLabel.isHidden = true
        phoneValidationLabel.isHidden = true
        passwordValidationLabel.isHidden = true
        confirmValidationLabel.isHidden = true
        alreadyValidationLabel.isHidden = true
    }
    
    
    private func disableAllFieldUserInterraction() {
        nameField.isUserInteractionEnabled = false
        emailField.isUserInteractionEnabled = false
        phoneField.isUserInteractionEnabled = false
        passField.isUserInteractionEnabled = false
        confirmField.isUserInteractionEnabled = false
    }
    
    private func disableAllShadow() {
        self.nameView.layer.shadowOpacity = 0
        self.emailView.layer.shadowOpacity = 0
        self.passView.layer.shadowOpacity = 0
        self.conifrmView.layer.shadowOpacity = 0
        self.phoneView.layer.shadowOpacity = 0
    }
    
    @objc func nameAction(_ sender:UITapGestureRecognizer){
        nameFunction()
        
    }
    
    @objc func phoneAction(_ sender:UITapGestureRecognizer){
        phoneFunction()
    }
    private func phoneFunction() {
        UIView.animate(withDuration: 0.2) { [self] in
            
            if self.passField.text!.isEmpty {
                self.passHeight.constant = self.view.frame.height/300
            }
            if self.emailField.text!.isEmpty {
                self.emailHeight.constant = self.view.frame.height/300
            }
            if self.nameField.text!.isEmpty {
                self.nameHeight.constant = self.view.frame.height/300
            }
            if self.confirmField.text!.isEmpty {
                self.confirmPassHeight.constant = self.view.frame.height/300
            }
            self.phoneHeight.constant = self.phoneView.frame.height/2
            self.phoneView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.disableAllShadow()
            self.phoneView.layer.shadowOpacity = 1
            self.phoneView.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.phoneView.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        disableAllFieldUserInterraction()
        phoneField.isUserInteractionEnabled = true
        phoneField.becomeFirstResponder()
    }
    
    
    @objc func passAction(_ sender:UITapGestureRecognizer){
        passFunction()
    }
    private func passFunction() {
        UIView.animate(withDuration: 0.2) { [self] in
            
            if self.nameField.text!.isEmpty {
                self.nameHeight.constant = self.view.frame.height/300
            }
            if self.emailField.text!.isEmpty {
                self.emailHeight.constant = self.view.frame.height/300
            }
            if self.phoneField.text!.isEmpty {
                self.phoneHeight.constant = self.view.frame.height/300
            }
            if self.confirmField.text!.isEmpty {
                self.confirmPassHeight.constant = self.view.frame.height/300
            }
            self.passHeight.constant = self.passView.frame.height/2
            self.passView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.disableAllShadow()
            self.passView.layer.shadowOpacity = 1
            self.passView.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.passView.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        disableAllFieldUserInterraction()
        passField.isUserInteractionEnabled = true
        passField.becomeFirstResponder()
    }
    
    
    @objc func confirmAction(_ sender:UITapGestureRecognizer){
        confirmFunction()
    }
    private func confirmFunction() {
        UIView.animate(withDuration: 0.2) { [self] in
            
            if self.passField.text!.isEmpty {
                self.passHeight.constant = self.view.frame.height/300
            }
            if self.emailField.text!.isEmpty {
                self.emailHeight.constant = self.view.frame.height/300
            }
            if self.phoneField.text!.isEmpty {
                self.phoneHeight.constant = self.view.frame.height/300
            }
            if self.nameField.text!.isEmpty {
                self.nameHeight.constant = self.view.frame.height/300
            }
            self.confirmPassHeight.constant = self.conifrmView.frame.height/2
            self.conifrmView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.disableAllShadow()
            self.conifrmView.layer.shadowOpacity = 1
            self.conifrmView.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.conifrmView.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        disableAllFieldUserInterraction()
        confirmField.isUserInteractionEnabled = true
        confirmField.becomeFirstResponder()
    }
    
    
    private func nameFunction() {
        UIView.animate(withDuration: 0.2) { [self] in
            
            if self.passField.text!.isEmpty {
                self.passHeight.constant = self.view.frame.height/300
            }
            if self.emailField.text!.isEmpty {
                self.emailHeight.constant = self.view.frame.height/300
            }
            if self.phoneField.text!.isEmpty {
                self.phoneHeight.constant = self.view.frame.height/300
            }
            if self.confirmField.text!.isEmpty {
                self.confirmPassHeight.constant = self.view.frame.height/300
            }
            self.nameHeight.constant = self.nameView.frame.height/2
            self.nameView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.disableAllShadow()
            self.nameView.layer.shadowOpacity = 1
            self.nameView.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.nameView.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        disableAllFieldUserInterraction()
        nameField.isUserInteractionEnabled = true
        nameField.becomeFirstResponder()
    }
    
    @objc func emailAction(_ sender:UITapGestureRecognizer) {
        
        emailFunction()
        
    }
    
    private func emailFunction() {
        UIView.animate(withDuration: 0.2) {
            
            if self.passField.text!.isEmpty {
                self.passHeight.constant = self.view.frame.height/300
            }
            if self.nameField.text!.isEmpty {
                self.nameHeight.constant = self.view.frame.height/300
            }
            if self.phoneField.text!.isEmpty {
                self.phoneHeight.constant = self.view.frame.height/300
            }
            if self.confirmField.text!.isEmpty {
                self.confirmPassHeight.constant = self.view.frame.height/300
            }
            self.emailHeight.constant = self.emailView.frame.height/2
            self.emailView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.disableAllShadow()
            self.emailView.layer.shadowOpacity = 1
            self.emailView.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.emailView.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        disableAllFieldUserInterraction()
        emailField.isUserInteractionEnabled = true
        emailField.becomeFirstResponder()
    }
    
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        
        disableAllFieldUserInterraction()
        previousMovedDistance = 0
        UIView.animate(withDuration: 0.25, delay: 0.0) {
            self.view.bounds.origin.y = 0
            self.disableAllShadow()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let activeTextFieldY = activeTextField.convert(activeTextField.bounds, to: self.view).minY
            
            let viewHeight = self.view.frame.height
            print(keyboardHeight)
            print(activeTextFieldY)
            print(viewHeight)
            if activeTextFieldY > viewHeight - keyboardHeight - 60 {
                UIView.animate(withDuration: 0.25, delay: 0.0) {
                    self.view.bounds.origin.y += keyboardHeight - (viewHeight - activeTextFieldY) + 60 - self.previousMovedDistance
                }
                previousMovedDistance = keyboardHeight - (viewHeight - activeTextFieldY) + 60
            }
        }
        
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeFromSignUp" {
            let destinationVC = segue.destination as! HomeViewController
            signUpVM.assignCurrent(email: emailField.text!)
            destinationVC.currentUser = signUpVM.currentUser
        }
        
    }
    
    @IBAction func goBacktoLogin(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}




extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        self.view.bounds.origin.y = 0
        switch textField {
        case nameField:
            textField.resignFirstResponder()
            self.emailFunction()
        case emailField:
            textField.resignFirstResponder()
            self.phoneFunction()
        case phoneField:
            textField.resignFirstResponder()
            self.passFunction()
        case passField:
            textField.resignFirstResponder()
            self.confirmFunction()
        case confirmField:
            textField.resignFirstResponder()
            disableAllShadow()
            confirmField.isUserInteractionEnabled = false
            
            previousMovedDistance = 0
            UIView.animate(withDuration: 0.25, delay: 0.0) {
                if self.confirmField.text!.isEmpty {
                    self.confirmPassHeight.constant = self.view.frame.height/300
                }
                self.view.bounds.origin.y = 0
                self.view.layoutIfNeeded()
            }
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}
