//
//  LoginVC.swift
//  FirebaseHW
//
//  Created by Евгений Лойко on 13.11.23.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.alpha = 0
        ref = Database.database().reference(withPath: "users")
    }
    
    @IBAction func registration() {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email,
                               password: password) { [weak self] user, error in
            if let error {
                print(error)
            } else if let user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
