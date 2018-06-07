//
//  StickerInputView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 14/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

protocol StickerInputViewDelegate: class {
    func didSelectEmoji(_ name: String)
    func didSelectSticker(_ name: String)
    func didLongPressEmoji(_ name: String)
    func didLongPressSticker(_ name: String)
}

class StickerInputView: UIView {

    enum InputType {
        case emoji
        case sticker
    }

    fileprivate var emojiNames = [String]()
    fileprivate var stickerNames = [String]()

    var type: InputType = .sticker
    weak var delegate: StickerInputViewDelegate?

    @IBOutlet weak var stickerCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        emojiNames = ["adult", "be_calm", "bum", "call_me", "chatterbox", "chillax", "chipku", "donkey", "eyes_on_you", "happy_birthday", "high_five", "i_love_you", "jalebi", "moustache", "patakha", "pinki_promise", "sheep", "super_women", "talli", "ullu"].sorted()

        stickerNames = ["awww", "baby", "bheja_fry", "confidential_giff", "congratulation", "fist_bump", "go_for_it", "paris_love", "til_the_end_of_time", "rock_n_rule", "jhakaas", "shit", "jadu_ki_jhappi", "oops_my_bad", "swag", "watt_lag_gayi", "party", "hanging_dog", "shut_up_please", "hand_heart_over_chest", "i_only_have_eyes_for_you", "so_sorry", "tubelight", "wtf"].sorted()

        let nibName = ParticipantCollectionCell.defaultReuseIdentifier
        let nib = UINib(nibName: nibName, bundle: nil)
        stickerCollectionView.register(nib, forCellWithReuseIdentifier: nibName)

        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.allowsMultipleSelection = false
    }
}

extension StickerInputView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .emoji:
            return emojiNames.count
        case .sticker:
            return stickerNames.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCollectionCell.defaultReuseIdentifier, for: indexPath) as? ParticipantCollectionCell else {
            fatalError("ParticipantCollectionCell not found")
        }

        if let selectedIndices = collectionView.indexPathsForSelectedItems,
            selectedIndices.contains(indexPath) {
            cell.overlaySendView.isHidden = false
        }

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressItem))
        cell.addGestureRecognizer(longPressGesture)

        cell.participantImageView.layer.cornerRadius = 0
        cell.removeBtn.isHidden = true

        switch type {
        case .emoji:
            let asset = emojiNames[indexPath.item]
            if let image = UIImage(named: asset) {
                cell.participantImageView.image = image
            }

        case .sticker:
            let asset = stickerNames[indexPath.item]
            if let image = UIImage(named: asset) {
                cell.participantImageView.image = image

            } else if let asset = NSDataAsset(name: asset) {
                cell.participantImageView.image = UIImage.sd_animatedGIF(with: asset.data)
            }
        }

        return cell
    }

    @objc private func didLongPressItem(_ gesture: UILongPressGestureRecognizer) {
        guard let indexPath = gesture.view?.collectionViewIndexPath(stickerCollectionView) else {
            return
        }
        switch type {
        case .emoji:
            delegate?.didLongPressEmoji(emojiNames[indexPath.item])
        case .sticker:
            delegate?.didLongPressSticker(stickerNames[indexPath.item])
        }
    }
}

extension StickerInputView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ParticipantCollectionCell else {
            return
        }
        if cell.overlaySendView.isHidden {
            cell.overlaySendView.isHidden = false
        } else {
            switch type {
            case .emoji:
                delegate?.didSelectEmoji(emojiNames[indexPath.item])
            case .sticker:
                delegate?.didSelectSticker(stickerNames[indexPath.item])
            }
            cell.overlaySendView.isHidden = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ParticipantCollectionCell {
            cell.overlaySendView.isHidden = true
        }
    }
}

extension StickerInputView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .emoji:
            let side = (screenWidth - 20)/3
            return CGSize(width: side, height: side)
        case .sticker:
            let side = (screenWidth - 15)/2
            return CGSize(width: side, height: side)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}
