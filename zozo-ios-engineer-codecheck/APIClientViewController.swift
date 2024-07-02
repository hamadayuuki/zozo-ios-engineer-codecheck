//
//  APIClientViewController.swift
//  zozo-ios-engineer-codecheck
//
//  Created by yuki.hamada on 2024/06/25.
//

import UIKit
import Combine

class APIClientViewController: UIViewController {
    private let viewModel: APIClientViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: APIClientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureViews()
        setupBinding()
    }

    // MARK: - UI components

    private lazy var getButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        button.setTitle("GET", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.addAction(
            .init { [weak self] _ in
                self?.getButtonTapped()
            },
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - function

    private func configureViews() {
        view.addSubview(getButton)

        getButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        getButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func setupBinding() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)   // メインスレッドで実行
            .sink { [weak self] isLoading in   // 循環参照を防ぐ
                self?.view.backgroundColor = isLoading ? .gray : .white
            }
            .store(in: &cancellables)
    }

    private func getButtonTapped() {
        viewModel.tappedGetButton()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
