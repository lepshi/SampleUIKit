//
//  ThumbImageCell.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import UIKit
import Photos

class ThumbImageCell: UICollectionViewCell {

    override func prepareForReuse() {
        cancelImageRequest()
    }

    func setup(asset: PHAsset, frame: CGSize) {
        self.viewModel = ThumbImageCellViewModel(asset: asset)
        viewModel?.fetchImage(targetSize: frame) { [weak self] val in
            guard let self = self else { return }
            image = val
            thumbImageView?.image = image
        }
        title = viewModel?.duration()
    }

    func cancelImageRequest() {
        viewModel?.cancelImageRequest()
    }

    private var viewModel: ThumbImageCellViewModel?
    private var thumbImageView: UIImageView?
    private var durationLabel: UILabel?

    private var image: UIImage? {
        didSet {
            thumbImageView?.image = image
        }
    }

    private var title: String? {
        didSet {
            durationLabel?.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ThumbImageCell {
    func setupUI() {
        let thumbImage = UIImageView(frame: .zero)
        contentView.addSubview(thumbImage)
        thumbImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbImage.contentMode = .scaleAspectFill
        thumbImage.clipsToBounds = true
        self.thumbImageView = thumbImage

        let duration = UILabel(frame: .zero)
        contentView.addSubview(duration)
        duration.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.bottom.equalTo(-8)
        }
        self.durationLabel = duration
    }
}
