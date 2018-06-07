//
//  ChooseChatBackgroundVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

protocol ChatBackgroundDelegate: class {
    func didChooseChatBackground(_ name: String)
}

class ChooseChatBackgroundVC: BaseVc {

    var roomInfo = ""
    weak var delegate: ChatBackgroundDelegate?

    private let chatBackgrounds = ["chat_bg_1", "chat_bg_2", "chat_bg_3", "chat_bg_4", "chat_bg_5", "ic_event_bg"]

    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundCollectionView.dataSource = self
        backgroundCollectionView.delegate = self

        okBtn.round()
        containerView.layer.cornerRadius = 8
        hideBackgrounds()

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.showBackgrounds()
        }, completion: nil)

        let chatBackgroundInfo = AppUserDefaults.value(forKey: .chatBackgroundInfo)
        let indexPath: IndexPath

        if let imgStr = chatBackgroundInfo[roomInfo].string,
            let index = chatBackgrounds.index(where: {$0 == imgStr}) {
            indexPath = IndexPath(item: index, section: 0)
        } else {
            indexPath = IndexPath(item: (chatBackgrounds.count - 1), section: 0)
        }
        backgroundCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {

        let touchLocation = gesture.location(in: view)
        guard !containerView.frame.contains(touchLocation) else {
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.hideBackgrounds()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }

    private func showBackgrounds() {
        containerView.alpha = 1
        self.containerView.transform = .identity
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    private func hideBackgrounds() {
        //let height = (containerView.height/2 + containerView.centerY)
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
    }

    @IBAction func okBtnTapped(_ sender: UIButton) {
        if let indexPath = backgroundCollectionView.indexPathsForSelectedItems?.first {
            delegate?.didChooseChatBackground(chatBackgrounds[indexPath.row])
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.hideBackgrounds()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

extension ChooseChatBackgroundVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatBackgrounds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatBackgroundImageCollectionCell.defaultReuseIdentifier, for: indexPath) as? ChatBackgroundImageCollectionCell else {
            fatalError("ChatBackgroundImageCollectionCell not found")
        }

        cell.chatBackgroundImageView.image = UIImage(named: chatBackgrounds[indexPath.row])
        return cell
    }
}

extension ChooseChatBackgroundVC: UICollectionViewDelegate {

}

extension ChooseChatBackgroundVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 //20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 80, height: 80)
        return size
    }
}

class ChatBackgroundImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var chatBackgroundImageView: UIImageView!
    @IBOutlet weak var checkMarkImageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            checkMarkImageView.isHidden = !isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        checkMarkImageView.isHidden = true
        chatBackgroundImageView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        checkMarkImageView.isHidden = true
        chatBackgroundImageView.image = nil
    }

    
}
