//
//  SignUpViewController.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then


final class SignUpViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let userNameLabel = UILabel().then { label in
        label.text = "사용자 이름"
    }
    
    private let userNameTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
    }
    
    private let emailLabel = UILabel().then { label in
        label.text = "이메일"
    }
    
    private let emailTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
    }
    
    private let passwordLabel = UILabel().then { label in
        label.text = "비밀번호"
    }
    
    private let passwordTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
    }
    
    private let passwordCheckLabel = UILabel().then { label in
        label.text = "비밀번호 확인"
    }
    
    private let passwordCheckTextField = UITextField().then { textField in
//        textField.borderStyle = .line
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
    }
    
    private let signUpButton = UIButton().then { button in
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureUI()
        bindUI()
    }
    
    private func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "회원가입"
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        [
            userNameLabel,
            emailLabel,
            passwordLabel,
            passwordCheckLabel,
            userNameTextField,
            emailTextField,
            passwordTextField,
            passwordCheckTextField,
            signUpButton
        ].forEach { view.addSubview($0) }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel)
            make.top.equalTo(userNameTextField.snp.bottom).offset(25)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel)
            make.top.equalTo(emailTextField.snp.bottom).offset(25)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel)
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(45)
        }
    }
}

extension SignUpViewController {
    
    private func bindUI() {
        
        signUpButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

#Preview {
    SignUpViewController()
}

