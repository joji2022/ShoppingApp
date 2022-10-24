
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signToContinueLabel: UILabel!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    @IBOutlet weak var forgotLabel: UILabel!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var signToViewOneHeight: NSLayoutConstraint!
    @IBOutlet weak var userFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var passFieldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var dontHaveLabel: UILabel!
    
    var activeTextField:UITextField!
    
    let loginVM = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    private func disableAllUserInteraction() {
        emailField.isUserInteractionEnabled = false
        passField.isUserInteractionEnabled = false
    }
    
    private func reduceShadowOpacity() {
        self.viewOne.layer.shadowOpacity = 0
        self.viewTwo.layer.shadowOpacity = 0
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        disableAllUserInteraction()
        UIView.animate(withDuration: 0.25, delay: 0.0) {
            self.view.bounds.origin.y = 0
            self.reduceShadowOpacity()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    @objc func willEnterBackground() {
        reduceShadowOpacity()
        disableAllUserInteraction()
        if emailField.text!.isEmpty {
            self.userFieldHeight.constant = self.view.frame.height/200
        }
        if passField.text!.isEmpty {
            self.passFieldHeight.constant = self.view.frame.height/200
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginVM.loadUsers()
        invalidLabel.text = "invalid email address"
        if loginVM.validEmail(email: emailField.text!) {
            invalidLabel.isHidden = true
            incorrectLabel.isHidden = true
            if let verified = loginVM.verifiedUser(email: emailField.text!, password: passField.text!) {
                if verified {
                    self.performSegue(withIdentifier: "toHomeCollection", sender: self)
                }
                else {
                    incorrectLabel.isHidden = false
                }
            }
            else {
                invalidLabel.text = "create an account first"
                invalidLabel.isHidden = false
            }
        }
        else {
            invalidLabel.isHidden = false
        }
        disableAllUserInteraction()
        reduceShadowOpacity()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeCollection" {
            let destinationVC = segue.destination as! HomeViewController
            destinationVC.currentUser = loginVM.currentUser
        }
    }
    private func initialSetUp() {
        
        activeTextField = emailField
        let width = self.view.frame.width
        let height = self.view.frame.height
        invalidLabel.isHidden = true
        incorrectLabel.isHidden = true
        
        
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: width/12)
        signToContinueLabel.font = UIFont.systemFont(ofSize: width/24)
        signToContinueLabel.textColor = .lightGray
        emailLabel.font = UIFont.systemFont(ofSize: width/30)
        emailLabel.textColor = .gray
        passLabel.font = UIFont.systemFont(ofSize: width/30)
        passLabel.textColor = .gray
        invalidLabel.font = UIFont.systemFont(ofSize: width/30)
        incorrectLabel.font = UIFont.systemFont(ofSize: width/30)
        forgotLabel.font = UIFont.systemFont(ofSize: width/25)
        dontHaveLabel.font = UIFont.systemFont(ofSize: width/25)
        createAccountLabel.font = UIFont.systemFont(ofSize: width/25)
        signToViewOneHeight.constant = height/25
        
        
        emailField.borderStyle = UITextField.BorderStyle.none
        passField.borderStyle = UITextField.BorderStyle.none
        viewOne.layer.cornerRadius = 10
        viewTwo.layer.cornerRadius = 10
        buttonOutlet.layer.cornerRadius = 10
        
        let buttonGesture = UILongPressGestureRecognizer(target: self, action:  #selector (self.labelAction (_:)))
        buttonGesture.minimumPressDuration = 0
        self.createAccountLabel.addGestureRecognizer(buttonGesture)
        
        
        userFieldHeight.constant = height/200
        passFieldHeight.constant = height/200
        disableAllUserInteraction()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.viewOne.addGestureRecognizer(gesture)
        
        let gestureTwo = UITapGestureRecognizer(target: self, action:  #selector (self.someActionTwo (_:)))
        self.viewTwo.addGestureRecognizer(gestureTwo)
        
        
        profileImageView.image = profileImageView.image?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = UIColor.lightGray
        
        
        self.emailField.delegate = self
        self.passField.delegate = self
        emailField.tag = 0
        
        
        let centre:NotificationCenter = NotificationCenter.default
        centre.addObserver(self,
                           selector: #selector(keyboardShown(notification: )),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        
        centre.addObserver(self,
                           selector: #selector( LoginViewController.keyboardHidden(notification: )),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    @objc func labelAction(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            self.createAccountLabel.alpha = 0.5
            
        }
        if sender.state == .ended {
            self.createAccountLabel.alpha = 1
            self.performSegue(withIdentifier: "toSignUp", sender: self)
        }
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2) {
            
            if self.passField.text!.isEmpty {
                self.passFieldHeight.constant = self.view.frame.height/200
            }
            self.userFieldHeight.constant = self.viewOne.frame.height/2
            self.viewOne.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.viewTwo.layer.shadowOpacity = 0
            self.viewOne.layer.shadowOpacity = 1
            self.viewOne.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.viewOne.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        passField.isUserInteractionEnabled = false
        emailField.isUserInteractionEnabled = true
        emailField.becomeFirstResponder()
    }
    @objc func someActionTwo(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2) {
            if self.emailField.text!.isEmpty {
                self.userFieldHeight.constant = self.view.frame.height/200
            }
            self.passFieldHeight.constant = self.viewTwo.frame.height/2
            self.viewOne.layer.shadowOpacity = 0
            self.viewTwo.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            self.viewTwo.layer.shadowOpacity = 1
            self.viewTwo.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.viewTwo.layer.shadowRadius = 5
            self.view.layoutIfNeeded()
        }
        emailField.isUserInteractionEnabled = false
        passField.isUserInteractionEnabled = true
        passField.becomeFirstResponder()
    }
    
    
    @objc func keyboardShown(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyBoardY = self.view.frame.height -  keyboardSize.height
            let editingTextFieldY = activeTextField?.convert(activeTextField.bounds, to: self.view).minY
            if self.view.frame.minY >= 0 {
                if editingTextFieldY! > keyBoardY-60 {
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: { self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y-(editingTextFieldY!-(keyBoardY-60)), width: self.view.bounds.width, height: self.view.bounds.height)}, completion: nil)
                }
                
            }
        }
    }
    
    @objc func keyboardHidden(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: { self.view.frame = CGRect(x: 0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)}, completion: nil)
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField =  textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.2) {
                if self.emailField.text!.isEmpty {
                    self.userFieldHeight.constant = self.view.frame.height/200
                }
                
                self.viewOne.layer.shadowOpacity = 0
                self.viewTwo.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
                self.viewTwo.layer.shadowOpacity = 1
                self.viewTwo.layer.shadowOffset = CGSize(width: 5, height: 5)
                self.viewTwo.layer.shadowRadius = 5
                self.passFieldHeight.constant = self.viewTwo.frame.height/2
                self.view.layoutIfNeeded()
            }
            
            
            self.emailField.isUserInteractionEnabled = false
            passField.isUserInteractionEnabled = true
            passField.becomeFirstResponder()
        } else {
            UIView.animate(withDuration: 0.2) {
                if self.passField.text!.isEmpty {
                    self.passFieldHeight.constant = self.view.frame.height/200
                }
                
                self.reduceShadowOpacity()
                self.view.layoutIfNeeded()
            }
            passField.isUserInteractionEnabled = false
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


