//
//  ChatImagePreviewVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class ChatImagePreviewVC: BaseVc {

    enum VCType {
        case viewImage
        case profileImage
    }

    var image: UIImage!
    var sticker: String?
    var vcType: VCType = .viewImage

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = ZoomImageView(image: image)
        imageView.frame = view.bounds
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
        shareBtn.isHidden = (vcType == .profileImage)
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func shareBtnTapped(_ sender: UIButton) {

        if let s = sticker, let asset = NSDataAsset(name: s),
            let stickerGif = UIImage.sd_animatedGIF(with: asset.data) {
            let shareController = UIActivityViewController(activityItems: [stickerGif], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = view
            present(shareController, animated: true, completion: nil)

        } else {
            CommonClass.imageShare(textURL: "", shareImage: image, viewController: self)
        }
    }
}
