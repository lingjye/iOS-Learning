//
//  ViewController.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/8.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class ViewController: UIViewController {

    var userNameTF: UITextField!
    var passwordTF: UITextField!
    var userNameLabel: UILabel!, passwordLabel: UILabel!
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configSubViews()
        bindViewModel()
    }

    func configSubViews() {
        userNameTF = UITextField.init()
        userNameTF!.placeholder = "请输入用户名"
        userNameTF!.layer.borderColor = RGBCOLOR(r: 240, g: 240, b: 240).cgColor
        userNameTF!.layer.borderWidth = 1
        userNameTF!.layer.cornerRadius = 5
        view.addSubview(userNameTF!)
        
        passwordTF = UITextField()
        passwordTF!.placeholder = "请输入密码"
        passwordTF!.layer.borderColor = RGBCOLOR(r: 240, g: 240, b: 240).cgColor
        passwordTF!.layer.borderWidth = 1
        passwordTF!.layer.cornerRadius = 5
        view.addSubview(passwordTF!)
        
        userNameLabel = UILabel()
        userNameLabel.textColor = UIColor.red
        userNameLabel.text = "请输入正确的手机号"
        view.addSubview(userNameLabel)
        
        passwordLabel = UILabel()
        passwordLabel.textColor = UIColor.red
        passwordLabel.text = "密码为字母加数字8~16位"
        view.addSubview(passwordLabel)
        
        let button = UIButton()
        button.setTitle("登录", for: UIControl.State.normal)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5
        view.addSubview(button)

        loginButton = button
        
        userNameTF!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(100)
        }
        passwordTF!.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userNameTF!)
            make.top.equalTo(userNameTF!.snp.bottom).offset(40)
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(userNameTF)
            make.top.equalTo(userNameTF.snp.bottom)
        }
        passwordLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(userNameLabel)
            make.top.equalTo(passwordTF.snp.bottom)
        }
        button.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(passwordTF!)
            make.top.equalTo(passwordTF!.snp.bottom).offset(50)
        }
    }
    
    func bindViewModel() -> Void {
        userNameTF!.reactive.continuousTextValues.map({ text in
            return text?.count
        }).filter { (characterCount) -> Bool in
            return (characterCount == 11 && isTelNumber(num: self.userNameTF!.text!))
            }.observeValues { (characterCount) in
                print(characterCount ?? "")
        }
        
        let userNameValidSignal = self.userNameTF!.reactive.continuousTextValues.map({
            text in
            return self.userNameIsValid
        })
        userNameValidSignal.map({
            userNameIsValid in
            return userNameIsValid ? UIColor.black : UIColor.red
        }).observeValues { (textColor) in
            self.userNameTF?.textColor = textColor
            self.passwordTF?.isUserInteractionEnabled = self.userNameIsValid
            self.userNameLabel.isHidden = self.userNameIsValid
        }
        
        let passwordValidSignal = self.passwordTF!.reactive.continuousTextValues.map({text in
            return self.passwordIsValid
        })
        passwordValidSignal.map({ passwordIsValid in
            return passwordIsValid ? UIColor.black : UIColor.red
        }).observeValues({ (textColor) in
            self.passwordTF?.textColor = textColor
            self.passwordLabel.isHidden = self.passwordIsValid
        })
        
        let loginBtnValidSignal = Signal.combineLatest(userNameValidSignal, passwordValidSignal).map { (userNameIsValid, passwordIsValid) in
            return userNameIsValid && passwordIsValid
        }
        loginBtnValidSignal.map { loginBtnValidSignal in
            return loginBtnValidSignal ? UIColor.red : UIColor.lightGray
            }.observeValues { backgroundColor in
                self.loginButton.backgroundColor = backgroundColor
        }
        
        let loginBtnEnabledProperty = Property(initial: false, then: loginBtnValidSignal)
        
        let action = Action <(String, String), Bool, NoError>(enabledIf: loginBtnEnabledProperty) { (arg0) -> SignalProducer<Bool, NoError> in
            
            let (userNameStr, passwordStr) = arg0
            return self.creatLoginSignalProducer(withUserName: userNameStr, andPassWord: passwordStr)
        }

        action.values.observeValues { (success) in
            if success {
                self.showAlert()
            }
        }
        
        self.loginButton.reactive.pressed = CocoaAction<UIButton>(action) {
            _ in
            (self.userNameTF.text!, self.passwordTF.text!)
        }
    }
    
    private var userNameIsValid: Bool {
        return userNameTF!.text!.count == 11 && isTelNumber(num: userNameTF!.text!)
    }
    
    private var passwordIsValid: Bool {
        return passwordTF!.text!.count >= 8 && isTruePassword(string: passwordTF!.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func creatLoginSignalProducer(withUserName username: String, andPassWord passWord: String) -> SignalProducer<Bool, NoError>{
        
        let (loginSignal, observer) = Signal<Bool, NoError>.pipe()
        
        let loginSiganlProducer = SignalProducer<Bool, NoError>(_ :loginSignal)
        self.login(withUserName: self.userNameTF.text!, andPassWord: self.passwordTF.text!){
            
            success in
            observer.send(value: success)
            observer.sendCompleted()
        }
        return loginSiganlProducer
    }
    
    func  login(withUserName userName: String, andPassWord passWord: String,completion: @escaping (Bool) -> Void) {
        let delay = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
            
            let success = true
            completion(success)
        }
    }

    func showAlert() {
        let alert = UIAlertController.init(
            title: "恭喜",
            message: "登录成功",
            preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { (action) in
            
        }
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

