//
//  SNVideoRecorderViewController.swift
//  Pods
//
//  Created by Dair Diaz on 24/08/17.
//
//

import AVFoundation

enum SNCaptureMode:UInt8 {
    case video = 0
    case photo = 1
}

public class SNVideoRecorderViewController: UIViewController {
    public weak var delegate:SNVideoRecorderDelegate?
    var session:AVCaptureSession?
    var videoInput:AVCaptureDeviceInput?
    var audioInput:AVCaptureDeviceInput?
    var movieFileOutput:AVCaptureMovieFileOutput?
    var imageFileOutput:AVCaptureStillImageOutput?
    public var closeOnCapture:Bool = true
    public var finalURL:URL?
    public var maxSecondsToRecord = 59
    public var initCameraPosition:AVCaptureDevice.Position = .front
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    // flash light button options
    public var flashLightOnIcon:UIImage?
    public var flashLightOffIcon:UIImage?
    
    // confirmation view button text
    public var agreeText:String = NSLocalizedString("Ok", comment: "")
    public var discardText:String = NSLocalizedString("Discard", comment: "")
    
    // components
    var previewLayer:AVCaptureVideoPreviewLayer?
    let countDown:SNRecordingCountDown = {
        let v = SNRecordingCountDown()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let recordOption:SNRecordButton = {
        let v = SNRecordButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    public let flashLightOption:UIButton = {
        let v = UIButton(type: .custom)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        v.tintColor = .white
        return v
    }()
    public let switchCameraOption:UIButton = {
        let v = UIButton(type: .custom)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        v.tintColor = .white
        return v
    }()
    public let closeOption:UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        v.tintColor = .white
        return v
    }()
    let galleryImagePicker = GalleryImagePickerViewController()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        galleryImagePicker.view.alpha = 0
        
        flashLightOption.setImage(flashLightOnIcon?.withRenderingMode(.alwaysTemplate), for: .normal)

        addChildViewController(galleryImagePicker)
        galleryImagePicker.delegate = self
        galleryImagePicker.view.translatesAutoresizingMaskIntoConstraints = false

        addViews()

        galleryImagePicker.didMove(toParentViewController: self)
        galleryImagePicker.willMove(toParentViewController: self)

        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isStatusBarHidden = true
        setupNavigationBar()
        setGalleryPickerHidden(false)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  .authorized {

            self.checkForMicrophonePermission(completion: { (granted) in
                if granted {
                    let _ = self.connect(withDeviceAt: self.initCameraPosition)
                } else {
                    self.showMicrophonePermissonRequestAlert()
                }
            })

        } else {

            switchCameraOption.isEnabled = false
            flashLightOption.isEnabled = false
            recordOption.isEnabled = false

            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) -> Void in

                if granted {
                    self.checkForMicrophonePermission(completion: { (granted) in
                        if granted {
                            let _ = self.connect(withDeviceAt: self.initCameraPosition)
                        } else {
                            self.showMicrophonePermissonRequestAlert()
                        }
                    })

                } else {
                    DispatchQueue.main.async {
                        let title = "Camera Access Denied"
                        let message = "Please enable camera access in your privacy settings";
                        CommonClass.showPermissionAlert(title: title, message: message)
                    }
                }
            })
        }
    }

    private func checkForMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission(completion)
        }
    }

    private func showMicrophonePermissonRequestAlert() {
        DispatchQueue.main.async {
            let title = "Microphone Access Denied"
            let message = "Please enable microphone access in your privacy settings";
            CommonClass.showPermissionAlert(title: title, message: message)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame.size = view.frame.size
        closeOption.layer.cornerRadius = closeOption.frame.width / 2
        switchCameraOption.layer.cornerRadius = switchCameraOption.frame.width / 2
        flashLightOption.layer.cornerRadius = switchCameraOption.layer.cornerRadius
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        switch UIDevice.current.orientation {
        case .portrait:
            previewLayer?.connection?.videoOrientation = .portrait
        case .landscapeLeft:
            previewLayer?.connection?.videoOrientation = .landscapeRight
        default:
            previewLayer?.connection?.videoOrientation = .landscapeLeft
        }
        
        recordOption.cancel()
    }
    
    func createSession(device: AVCaptureDevice, audioDevice: AVCaptureDevice) {
        session = AVCaptureSession()
        session?.beginConfiguration()
        do {
            try device.lockForConfiguration()
            videoInput = try AVCaptureDeviceInput(device: device)
            audioInput = try AVCaptureDeviceInput(device: audioDevice)
        } catch let error {
            print_debug(error)
        }
        
        if device.isFocusModeSupported(.autoFocus) {
            device.focusMode = .autoFocus
        }
        
        guard let s = session else {
            return
        }
        
        if s.canAddInput(audioInput!) {
            s.addInput(audioInput!)
        }
        if s.canAddInput(videoInput!) {
            s.addInput(videoInput!)
        }
        
        // video output
        if let output = movieFileOutput {
            if s.canAddOutput(output) {
                s.addOutput(output)
            }
        }
        
        // photo output
        if let output = imageFileOutput {
            if s.canAddOutput(output) {
                s.addOutput(output)
            }
        }
        
        updatePreview(session: s)
        
        device.unlockForConfiguration()
        s.commitConfiguration()
        s.startRunning()
    }
    
    func destroySession() {
        session?.removeInput(videoInput!)
        videoInput = nil
        
        if session != nil {
            if session!.isRunning {
                session?.stopRunning()
                session = nil
            }
        }
    }
    
    func updatePreview(session:AVCaptureSession) {
        previewLayer?.session = session
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> (audio:AVCaptureDevice?, video:AVCaptureDevice?) {
        let devices = AVCaptureDevice.devices()
        var audio:AVCaptureDevice?
        var video:AVCaptureDevice?
        for device in devices {
            if (device as AnyObject).hasMediaType(AVMediaType.video) {
                if (device as AnyObject).position == position {
                    video = device
                }
            }
            
            if (device as AnyObject).hasMediaType(AVMediaType.audio) {
                audio = device
            }
        }
        
        return (audio, video)
    }
    
    func addViews() {
        // camera preview
        previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.insertSublayer(previewLayer!, at: 0)

        // controls
        view.addSubview(countDown)
        view.addSubview(closeOption)
        view.addSubview(flashLightOption)
        view.addSubview(switchCameraOption)
        view.addSubview(recordOption)
        view.addSubview(galleryImagePicker.view)
        
        flashLightOption.addTarget(self, action: #selector(flashLightHandler), for: .touchUpInside)
        closeOption.addTarget(self, action: #selector(closeHandler), for: .touchUpInside)
        switchCameraOption.addTarget(self, action: #selector(switchCameraHandler), for: .touchUpInside)
    }
    
    func setupViews() {
        // count down
        countDown.widthAnchor.constraint(equalToConstant: 80).isActive = true
        countDown.heightAnchor.constraint(equalToConstant: 30).isActive = true
        countDown.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            countDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        } else {
            countDown.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        }
        
        // close option
        closeOption.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeOption.heightAnchor.constraint(equalTo: closeOption.widthAnchor).isActive = true
        closeOption.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        closeOption.centerYAnchor.constraint(equalTo: countDown.centerYAnchor).isActive = true
        
        // flash light
        flashLightOption.widthAnchor.constraint(equalToConstant: 45).isActive = true
        flashLightOption.heightAnchor.constraint(equalTo: switchCameraOption.widthAnchor).isActive = true
        flashLightOption.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        if #available(iOS 11.0, *) {
            flashLightOption.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        } else {
            flashLightOption.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        }
        // switch camera
        switchCameraOption.widthAnchor.constraint(equalToConstant: 45).isActive = true
        switchCameraOption.heightAnchor.constraint(equalTo: switchCameraOption.widthAnchor).isActive = true
        switchCameraOption.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        if #available(iOS 11.0, *) {
            switchCameraOption.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        } else {
            switchCameraOption.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        }
        
        // record option
        recordOption.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordOption.widthAnchor.constraint(equalToConstant: 60).isActive = true
        recordOption.heightAnchor.constraint(equalTo: recordOption.widthAnchor).isActive = true
        if #available(iOS 11.0, *) {
            recordOption.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            recordOption.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }

        // gallery image picker
        galleryImagePicker.view.bottomAnchor.constraint(equalTo: recordOption.topAnchor, constant: -15).isActive = true
        galleryImagePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        galleryImagePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        galleryImagePicker.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func switchCameraHandler(sender:UIButton) {
        if initCameraPosition == .front {
            initCameraPosition = .back
        } else {
            initCameraPosition = .front
        }
        
        destroySession()
        let _ = connect(withDeviceAt: initCameraPosition)
    }
    
    @objc func flashLightHandler(sender:UIButton) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    let state = !device.isTorchActive
                    device.torchMode = state ? .on : .off
                    if state {
                        sender.setImage(flashLightOffIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
                    } else {
                        sender.setImage(flashLightOnIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
                    }
                    device.unlockForConfiguration()
                } catch {
                    print_debug(error)
                }
            }
        } else {
            print_debug("no device camera")
        }
    }
    
    @objc func closeHandler(sender:UIButton) {
        closeView()
    }
    
    func connect(withDeviceAt position: AVCaptureDevice.Position) -> Bool {
        let devices = cameraWithPosition(position: position)
        guard let video = devices.video else {
            return false
        }
        guard let audio = devices.audio else {
            return false
        }

        DispatchQueue.main.async {
            if video.hasTorch {
                self.flashLightOption.isEnabled = true
                self.flashLightOption.isHidden = false
            } else {
                self.flashLightOption.isEnabled = false
                self.flashLightOption.isHidden = true
            }

            self.recordOption.isEnabled = true
            self.recordOption.isHidden = false

            self.switchCameraOption.isEnabled = true
            self.switchCameraOption.isHidden = false
        }
        
        // video output
        movieFileOutput = AVCaptureMovieFileOutput()
        let maxDuration:CMTime = CMTimeMake(600, 10)
        movieFileOutput?.maxRecordedDuration = maxDuration
        movieFileOutput?.minFreeDiskSpaceLimit = 1024 * 1024
        
        // image output
        imageFileOutput = AVCaptureStillImageOutput()
        imageFileOutput?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        createSession(device: video, audioDevice: audio)
        recordOption.delegate = self
        countDown.setup(seconds: maxSecondsToRecord)
        countDown.delegate = self
        return false
    }
    
    func closeView() {
        if let navigation = navigationController {
            let _ = navigation.popViewController(animated: true)
        } else {
            UIApplication.shared.isStatusBarHidden = false
            dismiss(animated: true) {
                print_debug("done")
            }
        }
    }
}

extension SNVideoRecorderViewController: SNVideoRecorderViewProtocol {
    
}

extension SNVideoRecorderViewController: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(_ captureOutput: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    public func fileOutput(_ captureOutput: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let randomName = ProcessInfo.processInfo.globallyUniqueString
        let videoFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(randomName).appendingPathExtension("mp4")
        
        if FileManager.default.fileExists(atPath: videoFilePath.absoluteString) {
            do {
                try FileManager.default.removeItem(atPath: videoFilePath.absoluteString)
            }
            catch {
                
            }
        }
        
        let sourceAsset = AVURLAsset(url: outputFileURL)
        let export: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        export.outputFileType = AVFileType.mp4
        export.outputURL = videoFilePath
        export.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, sourceAsset.duration)
        export.timeRange = range
        export.exportAsynchronously { () -> Void in
            DispatchQueue.main.async(execute: {
                AppNetworking.hideLoader()
                self.recordOption.isEnabled = true
            })
            switch export.status {
            case .completed:
                DispatchQueue.main.async(execute: {
                    let vc = SNVideoViewerViewController()
                    //vc.modalPresentationStyle = .overCurrentContext
                    vc.delegate = self
                    vc.url = videoFilePath
                    self.present(vc, animated: false, completion: nil)
                })
            case  .failed:
                print_debug("failed \(String(describing: export.error))")
            case .cancelled:
                print_debug("cancelled \(String(describing: export.error))")
            default:
                print_debug("complete")
            }
        }
    }
}

extension SNVideoRecorderViewController: SNRecordButtonDelegate {

    func willStart(mode:SNCaptureMode) {
        setGalleryPickerHidden(true)
    }
    
    func didStart(mode:SNCaptureMode) {
        if mode == .video {
            let randomName = ProcessInfo.processInfo.globallyUniqueString
            let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(randomName).appendingPathExtension("mp4")
            
            movieFileOutput?.startRecording(to: filePath, recordingDelegate: self)
            countDown.start(on: maxSecondsToRecord)
        } else {
            if let videoConnection = imageFileOutput?.connection(with: AVMediaType.video) {
                imageFileOutput?.captureStillImageAsynchronously(from: videoConnection) {
                    (buffer, error) -> Void in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!) {
                        let vc = SNImageViewerViewController()
                        //vc.modalPresentationStyle = .overCurrentContext
                        vc.image = UIImage(data: imageData)
                        vc.delegate = self
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }
    }

    func willEnd(isCanceled:Bool) {
        //toggleGalleryPickerVisibility()
    }
    
    func didEnd(isCanceled:Bool) {
        guard let s = session else {
            return
        }

        countDown.pause()
        if !isCanceled {
            s.stopRunning()
            recordOption.isEnabled = false
            AppNetworking.showLoader()
        } else {
            countDown.setup(seconds: maxSecondsToRecord)
        }
    }

    private func setGalleryPickerHidden(_ hidden: Bool) {
        let alpha: CGFloat = hidden ? 0:1
        UIView.animate(withDuration: 0.25) {
            self.galleryImagePicker.view.alpha = alpha
        }
    }
}

extension SNVideoRecorderViewController: SNRecordingCountDownDelegate {
    
    func countDown(didStartAt time: TimeInterval) {
        print_debug("empezó el conteo regresivo")
    }
    
    func countDown(didPauseAt time: TimeInterval) {
        print_debug("el usuario ha detenido el conteo regresivo antes de finalizar")
    }
    
    func countDown(didFinishAt time: TimeInterval) {
        print_debug("terminó el tiempo máximo de grabación")
    }
}

extension SNVideoRecorderViewController: SNImageViewerDelegate {
    
    func imageView(finishWithAgree agree: Bool, andImage image: UIImage?) {
        if agree {
            guard let img = image else {
                return
            }
            
            delegate?.videoRecorder(withImage: img)
            
            if closeOnCapture {
                closeView()
            }
        }
    }
}

extension SNVideoRecorderViewController: SNVideoViewerDelegate {
    
    func videoView(finishWithAgree agree: Bool, andURL url: URL?) {
        if agree {
            guard let value = url else {
                return
            }
            
            self.delegate?.videoRecorder(withVideo: value)
            
            if closeOnCapture {
                closeView()
            }
        }
    }
}
