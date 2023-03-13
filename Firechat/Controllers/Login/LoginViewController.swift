//
//  LoginViewController.swift
//  Firechat
//
//  Created by Daniyal Ganiuly on 21.02.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD


class LoginViewController: UIViewController {

    
    // added
    private let spinner = JGProgressHUD(style: .dark)
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email"
        
        
        
        field.leftView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 5,
                                              height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Пароль"
        field.isSecureTextEntry = true
        
        
        field.leftView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 5,
                                              height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Логин"
        view.backgroundColor = .white
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Регистрация", style: .done,
            target: self, action: #selector(didTapRegister))
        
        
        
        view.addSubview(imageView)
        
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Создание аккаунта"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let size = view.frame.size.width / 3
//        imageView.frame = CGRect(
//            x: (view.frame.size.width - size) / 2,
//            y: 20,
//            width: size,
//            height: size)
        
        let size = view.width / 3
        imageView.frame = CGRect(
            x: (view.width - size) / 2,
            y: 20,
            width: size,
            height: size)
        
        
        scrollView.frame = view.bounds
        
        
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 50)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 50)
        
        loginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 50)
        
    }
    
    
    @objc private func loginButtonTapped() {
        
        
        // dismiss keyboard
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let email = emailField.text, let password = passwordField.text,
        !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        
        
        
        // added
        
        spinner.show(in: view)
        
        
        // Firebase login
        
        FirebaseAuth.Auth.auth().signIn(
            withEmail: email,
            password: password,
            completion: { [weak self] authResult, error in
                
                
                guard let strongSelf = self else {
                    return
                }
                
                
                // added
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }
                
                
                guard let result = authResult, error == nil else{
                    print("Ошибка логин \(email)")
                    return 
                }
                let user = result.user
                
                UserDefaults.standard.set(email, forKey: "email")
                
                print("Успешно вошли в аккаунт \(user)")
                strongSelf.navigationController?.dismiss(
                    animated: true,
                    completion: nil)
            })
        
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Пожалуйста, введите все данные",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    

}






extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
}
