//
//  ViewModelType.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/18/25.
//

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
