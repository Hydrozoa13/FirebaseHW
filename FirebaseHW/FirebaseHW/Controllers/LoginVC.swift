//
//  LoginVC.swift
//  FirebaseHW
//
//  Created by Евгений Лойко on 13.11.23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var ref: DatabaseReference!
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.alpha = 0
        ref = Database.database().reference(withPath: "users")
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            guard let _ = user else { return }
            self?.performSegue(withIdentifier: "goToTasksTVC", sender: nil)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
                                               name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
                                               name: UIWindow.keyboardWillHideNotification, object: nil)
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.text = nil
        passwordTF.text = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }
    
    
    @IBAction func login() {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty
        else {
            displayErrorLbl(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error {
                self?.displayErrorLbl(withText: "\(error)")
            } 
        }
    }
    
    @IBAction func registration() {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty 
        else {
            displayErrorLbl(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email,
                               password: password) { [weak self] user, error in
            if let error {
                self?.displayErrorLbl(withText: "\(error)")
            } else if let user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
        }
    }

    private func displayErrorLbl(withText text: String) {
        errorLbl.text = text
        UIView.animate(
            withDuration: 5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.errorLbl.alpha = 1
            }
        ) { [weak self] _ in
            self?.errorLbl.alpha = 0
            self?.errorLbl.isHidden = true
        }
    }
    
    @objc private func kbWillShow(notification: Notification) {
        view.frame.origin.y = 0
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= (kbSize.height / 2)
        }
    }
    
    @objc private func kbWillHide() {
        view.frame.origin.y = 0
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
