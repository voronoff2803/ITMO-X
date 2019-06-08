//
//  LoginViewController.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let loginTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 37, weight: .medium)
        lbl.textAlignment = .center
        lbl.text = "Вход"
        return lbl
    }()
    
    private let loginLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lbl.textAlignment = .right
        lbl.text = "Логин"
        return lbl
    }()
    
    private let passwordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lbl.textAlignment = .right
        lbl.text = "Пароль"
        return lbl
    }()
    
    private let devider1: UIView = {
        let v = UIView()
        v.backgroundColor = Config.Colors.gray
        return v
    }()
    
    private let devider2: UIView = {
        let v = UIView()
        v.backgroundColor = Config.Colors.gray
        return v
    }()
    
    private let devider3: UIView = {
        let v = UIView()
        v.backgroundColor = Config.Colors.gray
        return v
    }()
    
    private let loginField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите логин"
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.textColor = Config.Colors.black
        if #available(iOS 11.0, *) {
            tf.textContentType = .username
        }
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.isSecureTextEntry = true
        tf.textColor = Config.Colors.black
        if #available(iOS 11.0, *) {
            tf.textContentType = .password
        }
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.backgroundColor = Config.Colors.blue
        btn.setTitle("Войти", for: .normal)
        btn.setTitleColor(Config.Colors.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorate()
    }
    
    @objc func loginAction() {
        self.loginButton.loadingIndicator(show: true)
        UserDefaults.standard.set(loginField.text, forKey: "login")
        UserDefaults.standard.set(passwordField.text, forKey: "password")
        ApiWorker.shared.getJournal(onSuccess: {
            self.showBlackThemeAlert()
        }, onFailure: { (error) in
            self.alert(title: "Ошибка", message: "Проверьте логин и пароль")
            self.loginButton.loadingIndicator(show: false)
        })
    }
    
    func showBlackThemeAlert() {
        let alert = UIAlertController(title: "Включить темную тему?", message: "Выключить темную тему можно в настройках", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Да, включить", style: .cancel) { (alert) in
            UserDefaults.standard.set(true, forKey: "enabled_black")
            self.goToMainScreen()
        }
        let alertAction2 = UIAlertAction(title: "Нет, не включить", style: .default) { (alert) in
            UserDefaults.standard.set(false, forKey: "enabled_black")
            self.goToMainScreen()
        }
        alert.addAction(alertAction2)
        alert.addAction(alertAction1)
        self.present(alert, animated: true)
    }
    
    func goToMainScreen() {
        DispatchQueue.main.async {
            AppDelegate.checkBlackTheme()
            let mainScreenController = Helper.app.getMainScreenController()
            self.present(mainScreenController, animated: true, completion: nil)
        }
    }
    
    func decorate() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = Config.Colors.white
        view.addSubview(loginTitleLabel)
        view.addSubview(devider1)
        view.addSubview(devider2)
        view.addSubview(devider3)
        view.addSubview(loginLabel)
        view.addSubview(passwordLabel)
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        loginTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90, enableInsets: false)
        devider1.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 180, paddingLeft: 22, paddingBottom: 0, paddingRight: 22, width: 0, height: 1, enableInsets: false)
        loginLabel.anchor(top: devider1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 17, paddingLeft: 72, paddingBottom: 0, paddingRight: 0, width: 70, height: 25, enableInsets: false)
        loginField.anchor(top: devider1.bottomAnchor, left: loginLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 21, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 120, height: 20, enableInsets: false)
        devider2.anchor(top: loginLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 19, paddingLeft: 22, paddingBottom: 0, paddingRight: 22, width: 0, height: 1, enableInsets: false)
        passwordLabel.anchor(top: devider2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 17, paddingLeft: 72, paddingBottom: 0, paddingRight: 0, width: 70, height: 25, enableInsets: false)
        passwordField.anchor(top: devider2.bottomAnchor, left: passwordLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 21, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 120, height: 20, enableInsets: false)
        devider3.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 19, paddingLeft: 22, paddingBottom: 0, paddingRight: 22, width: 0, height: 1, enableInsets: false)
        loginButton.anchor(top: devider3.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 42, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 44, enableInsets: false)
        
    }
}
