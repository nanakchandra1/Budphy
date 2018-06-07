//
//  TrailersPlayerVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import youtube_ios_player_helper
import AVFoundation

class TrailersPlayerVC: BaseVc {

    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var ytPlayer: YTPlayerView!

    var url: String?
    private var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture))
        self.transparantView.addGestureRecognizer(tapGesture)

        self.ytPlayer.backgroundColor = UIColor.gray
        self.ytPlayer.roundCornerWith(radius: 3.0)

        if let unwrappedUrl = self.url,
            let trailerId = unwrappedUrl.components(separatedBy: "=").last {
            self.ytPlayer.load(withVideoId: trailerId)
        }

        transparantView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: {

            self.transparantView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    @objc private func handleTapGesture() {

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: {

            self.transparantView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)

        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: YTPlayerView Delegate Methods
extension TrailersPlayerVC: YTPlayerViewDelegate {

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print_debug(#function)
    }

    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        print_debug(#function)
    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print_debug(#function)
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        print_debug(#function)
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print_debug(#function)
    }

    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        print_debug(#function)
        return .red
    }

}
