//
//  RecordVoiceVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 06/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import AVFoundation
import UIKit
import FreeStreamer

protocol VoiceRecordingDelegate: class {
    func didRecordVoice(_ url: URL)
}

class RecordVoiceVC: BaseVc {

    weak var delegate: VoiceRecordingDelegate?

    private lazy var audioPlayer = FSAudioStream()
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var soundFileURL: URL!
    private var hasRecorded = false

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var currentVoiceTimeLbl: UILabel!
    @IBOutlet weak var maxVoiceLengthLbl: UILabel!

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.backgroundColor = AppColors.themeBlueColor
        containerView.layer.cornerRadius = 8
        hideRecorder()
        audioPlayer.strictContentTypeChecking = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playBtn.isEnabled = false

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.showRecorder()
        }, completion: nil)

        // location for sound file
        soundFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("RecordedFile.aac")

        // settings for recording, can be changed to liking
        let recordSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                              AVSampleRateKey: 44100,
                              AVNumberOfChannelsKey: 1,
                              AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey: 192000] as [String: Any]

        // activating app's audio session
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        }
        catch let error as NSError {
            print_debug("audioSession error: \(error.localizedDescription)")
        }

        // initializing our audio recording capabilities
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.prepareToRecord()
        }
        catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
    }

    private func showRecorder() {
        self.containerView.transform = .identity
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    private func hideRecorder() {
        let height = (containerView.height/2 + containerView.centerY)
        containerView.transform = CGAffineTransform(translationX: 0, y: height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
    }

    @IBAction func recordBtnTapped(_ sender: UIButton) {
        if hasRecorded {
            sendRecording()
        } else if audioRecorder?.isRecording == false {
            startRecording()
        } else {
            stopRecording()
        }
    }

    private func startRecording() {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
            recordBtn.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        }
    }

    @objc private func timeElapsed(_ sender: Timer) {
        if let recorder = audioRecorder {
            let time = Date(timeIntervalSince1970: recorder.currentTime)
            if recorder.currentTime >= 60 {
                stopRecording()
            }
            let timeZone = TimeZone(identifier: "UTC")!
            currentVoiceTimeLbl.text = time.toString(dateFormat: "mm:ss", timeZone: timeZone)
        }
    }

    private func sendRecording() {
        self.delegate?.didRecordVoice(soundFileURL)
        self.cancelBtnTapped(self.cancelBtn)
    }

    @IBAction func playBtnTapped(_ sender: UIButton) {
        if audioPlayer.isPlaying() {
            stopRecording()

        } else if let url = soundFileURL {
            audioPlayer.play(from: url)
            playBtn.setTitle("Stop", for: .normal)

            audioPlayer.onCompletion = { [weak self] in
                if let strongSelf = self {
                    strongSelf.stopRecording()
                }
            }
        }
    }

    private func stopRecording() {
        playBtn.isEnabled = true
        playBtn.setTitle("Play", for: .normal)
        recordBtn.setTitle("Send", for: .normal)
        hasRecorded = true

        timer?.invalidate()
        timer = nil

        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer.stop()
        }
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.hideRecorder()
        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: AVAudioRecorder Delegate Methods
extension RecordVoiceVC: AVAudioRecorderDelegate {

}
