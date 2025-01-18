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
    private let viewModel = SignUpViewModel()
    
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
    
    private let emailDescriptionLabel = UILabel().then { label in
        label.text = ""
        label.textColor = .red
    }
    
    private let emailTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
        textField.placeholder = "email@example.com"
    }
    
    private let passwordLabel = UILabel().then { label in
        label.text = "비밀번호"
    }
    
    private let passwordTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
    }
    
    private let passwordDescription = UILabel().then { label in
        label.text = ""
        label.textColor = .red
    }
    
    private let passwordCheckLabel = UILabel().then { label in
        label.text = "비밀번호 확인"
    }
    
    private let passwordCheckTextField = UITextField().then { textField in
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
    }
    
    private let passwordCheckDescription = UILabel().then { label in
        label.text = ""
        label.textColor = .red
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
        addTapGesture()
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
            emailDescriptionLabel,
            passwordTextField,
            passwordDescription,
            passwordCheckTextField,
            signUpButton,
            passwordCheckDescription
        ].forEach { view.addSubview($0) }
        
        // 각 UI 요소의 제약 조건
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
        
        emailDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailLabel)
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
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
        
        passwordDescription.snp.makeConstraints { make in
            make.leading.equalTo(passwordLabel)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
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
        
        passwordCheckDescription.snp.makeConstraints { make in
            make.leading.equalTo(passwordCheckLabel)
            make.top.equalTo(passwordCheckTextField.snp.bottom).offset(5)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(45)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

extension SignUpViewController {
    
    private func bindUI() {
        
        let input = SignUpViewModel.Input(
            userName: emailTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(emailTextField.rx.text.orEmpty),
            emailText: emailTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(emailTextField.rx.text.orEmpty),
            passwordText: passwordTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(passwordTextField.rx.text.orEmpty),
            passwordCheckText: passwordCheckTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(passwordCheckTextField.rx.text.orEmpty),
            signUpButtonTapped: signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.registerUser
            .drive(onNext: { [weak self] result in
                guard let self else { return }
                if result {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    //TODO: 알럿 띄워주기
                }
            }).disposed(by: disposeBag)
        
        output.emailText
            .drive(onNext: { [weak self] result in
                guard let self else { return }
                print(result)
                if result == false {
                    self.emailDescriptionLabel.text = "유효하지 않은 이메일 입니다."
                } else {
                    self.emailDescriptionLabel.text = ""
                }
            }).disposed(by: disposeBag)
        
        output.passwordText
            .drive(onNext: { [weak self] result in
                guard let self else { return }
                if result == false {
                    self.passwordDescription.text = "비밀번호는 8자이상 입력해주세요."
                } else {
                    self.passwordDescription.text = ""
                }
            }).disposed(by: disposeBag)
        
        output.passwordCheckText
            .drive(onNext: { [weak self] password in
                guard let self else { return }
                if password == false {
                    self.passwordCheckDescription.text = "비밀번호가 일치하지 않습니다."
                } else {
                    self.passwordCheckDescription.text = ""
                }
            }).disposed(by: disposeBag)
    }
}

