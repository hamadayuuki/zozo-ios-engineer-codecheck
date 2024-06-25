//
//  APIClientViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import UIKit

class APIClientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        addSubViews()
        setupLayout()
        setupBinding()
    }

    // MARK: - UI compornents

    private var getButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        button.setTitle("GET", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // MARK: - function

    private func addSubViews() {
        view.addSubview(getButton)
    }

    private func setupLayout() {
        getButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        getButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func setupBinding() {
        getButton.addTarget(self, action: #selector(getButtonTapped), for: .touchUpInside)
    }

    @objc private func getButtonTapped() {
        print(#function)
    }
}
