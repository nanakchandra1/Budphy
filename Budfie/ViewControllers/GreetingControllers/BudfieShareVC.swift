//
//  BudfieShareVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import MessageUI
import MobileCoreServices

protocol BudfieShareDelegate: class {
    func shareWithBudfie()
}

class BudfieShareVC: BaseVc {

    var text: String?
    var image: UIImage?

    weak var delegate: BudfieShareDelegate?

    @IBOutlet weak var budfieShareStackView: UIStackView!
    @IBOutlet weak var normalShareStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0

        let budfieShareTapGesture = UITapGestureRecognizer(target: self, action: #selector(budfieShareTapped))
        budfieShareStackView.addGestureRecognizer(budfieShareTapGesture)

        let normalShareTapGesture = UITapGestureRecognizer(target: self, action: #selector(normalShareTapped))
        normalShareStackView.addGestureRecognizer(normalShareTapGesture)

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(backgroundTapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showShareView(animated: true)
    }

    @objc private func budfieShareTapped(_ sender: UITapGestureRecognizer) {
        budifeShare()
    }

    @objc private func normalShareTapped(_ sender: UITapGestureRecognizer) {
        normalShare()
    }

    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        hideShareView(animated: true)
    }

    private func showShareView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.alpha = 1
            }
        } else {
            view.alpha = 1
        }
    }

    private func hideShareView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.removeFromParent()
            })
        } else {
            view.alpha = 0
            removeFromParent()
        }
    }

    private func removeFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }

    @IBAction func budfieBtnTapped(_ sender: UIButton) {
        delegate?.shareWithBudfie()
        hideShareView(animated: false)
    }

    @IBAction func messageBtnTapped(_ sender: UIButton) {

        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = parent as? MFMessageComposeViewControllerDelegate
        messageController.disableUserAttachments()

        if let unwrappedText = text,
            MFMessageComposeViewController.canSendText() {
            messageController.body = unwrappedText

        } else if let unwrappedImage = image,
            let data = UIImageJPEGRepresentation(unwrappedImage, 1),
            MFMessageComposeViewController.canSendAttachments() {

            messageController.addAttachmentData(data, typeIdentifier: (kUTTypeJPEG as String), filename: "budfie.jpeg")

        } else {
            CommonClass.showToast(msg: "Cannot send via message")
            return
        }

        parent?.present(messageController, animated: true, completion: {
            self.hideShareView(animated: false)
        })
    }

    @IBAction func mailBtnTapped(_ sender: UIButton) {

        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = parent as? MFMailComposeViewControllerDelegate
            if let unwrappedText = text {
                composer.setMessageBody(unwrappedText, isHTML: false)

            } else if let unwrappedImage = image,
                let data = UIImageJPEGRepresentation(unwrappedImage, 1) {
                composer.addAttachmentData(data, mimeType: (kUTTypeJPEG as String), fileName: "budfie.jpeg")
            }
            parent?.present(composer, animated: true, completion: {
                self.hideShareView(animated: false)
            })
        }
    }

    @IBAction func otherBtnTapped(_ sender: UIButton) {
        normalShare()
    }

    private func budifeShare() {
        delegate?.shareWithBudfie()
        hideShareView(animated: false)
    }

    private func normalShare() {
        guard let parent = self.parent else {
            return
        }
        if let unwrappedImage = image {
            CommonClass.imageShare(textURL: "", shareImage: unwrappedImage, viewController: parent)
        } else if let unwrappedText = text {
            let modifiedText = "Click link for special wish ....\n\(unwrappedText)"
            let shareController = UIActivityViewController(activityItems: [modifiedText], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = view
            parent.present(shareController, animated: true, completion: nil)

        }
        hideShareView(animated: false)
    }
}
