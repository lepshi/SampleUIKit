//
//  MultiplePhotoView.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import UIKit
import Accelerate
import Photos
import SnapKit

class MultiplePhotoView: UIView {

    var assets: [PHAsset] = [] {
        didSet {
            assetsCollectionView?.reloadData()
        }
    }

    var thumbImageService: ThumbImageSupporter = ThumbImageService()

    private var assetsCollectionView: UICollectionView?
    let numberInRow = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MultiplePhotoView {
    func setup() {
        setupCollectionView()
    }

    func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.register(ThumbImageCell.self, forCellWithReuseIdentifier: ThumbImageCell.reuseIdentifier())
        collectionView.delegate = self
        collectionView.dataSource = self
        self.assetsCollectionView = collectionView
    }
}

extension MultiplePhotoView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var thumbWidth: CGFloat {
        return bounds.width / CGFloat(numberInRow)
    }

    var thumbSize: CGSize {
        return CGSize(width: thumbWidth, height: thumbWidth)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbImageCell.reuseIdentifier(), for: indexPath) as? ThumbImageCell
        else {
            return UICollectionViewCell()
        }

        let asset = self.assets[indexPath.row]
        cell.setup(asset: asset, frame: thumbSize)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cellU = cell as? ThumbImageCell {
            cellU.cancelImageRequest()
        }
    }
}
