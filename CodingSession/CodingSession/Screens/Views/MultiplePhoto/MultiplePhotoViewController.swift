//
//  MultiplePhotoViewController.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import UIKit
import SnapKit

class MultiplePhotoViewController: UIViewController {
    var viewModel: MultiplePhotoSupporter = MultiplePhotoViewModel()
    var multiplePhotoView: MultiplePhotoView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension MultiplePhotoViewController {
    func setup() {
        setupUI()
        bind()
    }

    func setupUI() {
        let multipleView = MultiplePhotoView(frame: view.bounds)
        view.addSubview(multipleView)
        multipleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.multiplePhotoView = multipleView
    }

    func bind() {
        let assetsStream = viewModel.assets
        Task { [weak self] in
            for await assets in assetsStream {
                await MainActor.run { [weak self] in
                    self?.multiplePhotoView?.assets = assets
                }
            }
        }
    }
}
