//
//  PostCelll.swift
//  ios101-project5-tumblr
//
//  Created by Yonatan Simie on 10/30/25.
//

import UIKit
import Nuke

class PostCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!

    private var imageTask: ImageTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        print("photoView is nil? \(photoView == nil)")
        print("summaryLabel is nil? \(summaryLabel == nil)")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        photoView.image = nil
        summaryLabel.text = nil
        photoView.alpha = 1
    }

    func configure(with post: Post) {
        // Uses your `summary` exactly as defined in Post.swift
        summaryLabel.text = post.summary

        // Uses your `photos.first?.originalSize.url` exactly as defined in Post.swift
        guard let firstPhoto = post.photos.first else {
            photoView.image = nil
            return
        }

        let request = ImageRequest(url: firstPhoto.originalSize.url)
        imageTask = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.photoView.alpha = 0
                self.photoView.image = response.image
                UIView.animate(withDuration: 0.2) { self.photoView.alpha = 1 }
            case .failure:
                self.photoView.image = nil
            }
        }
    }
}
