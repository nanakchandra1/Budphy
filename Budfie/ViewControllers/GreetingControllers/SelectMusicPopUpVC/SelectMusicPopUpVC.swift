//
//  SelectMusicPopUpVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 06/12/17.
//  Copyright © 2017 . All rights reserved.
//

import FreeStreamer

//MARK:- Get Selected Music Delegate
//==================================
protocol MusicDelegate : class {
    func didSelectMusic(_ music: String, index: Int)
}

//MARK:- SelectMusicPopUpVC class
//===============================
class SelectMusicPopUpVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var selectedMusic: String?
    var selectedRow     = -1
    weak var delegate   : MusicDelegate?
    var songNames = ["Eden Of Buddha",
                    "Feel So Good",
                    "Flying Away",
                    "In The Right Direction",
                    "Inside Beauty",
                    "Happy Trip"]

    var songs = ["eden-of-buddha",
                 "feel-so-good",
                 "flying-away",
                 "in-the-right-direction",
                 "inside-beauty",
                 "melodyloops-preview-happy-trip"]

    lazy var audioPlayer = FSAudioStream()
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var musicBackView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var chooseMusicLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var popUpTableView: UITableView!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInitailViews()
        self.registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backView.transform = CGAffineTransform(translationX: 0,
                                                    y: -screenHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5) {
            self.statusBarView.backgroundColor = AppColors.musicBackColor
            self.backGroundView.backgroundColor = AppColors.popUpBackground
            self.backView.transform = .identity
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        audioPlayer.stop()
        self.UpDownAnimation()
    }
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        audioPlayer.stop()
        self.UpDownAnimation()
        if let music = selectedMusic,
            let unwrappedDelegate = delegate {
            unwrappedDelegate.didSelectMusic(music, index: self.selectedRow)
        }
    }
    
    @objc func selectedRowBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.popUpTableView) else {
            fatalError("Cannot Find IndexPath")
        }
        
        audioPlayer.stop()

        if let musicURLString = selectedMusic,
            let path = Bundle.main.path(forResource: musicURLString, ofType: ".mp3"),
            let musicURL = URL(string: "file://\(path)") {
            audioPlayer.play(from: musicURL)
        }

        self.selectedRow = indexPath.row
        self.selectedMusic = self.songs[indexPath.row]
        self.popUpTableView.reloadData()
    }
}

//MARK: Extension for Regisering Nibs and Setting Up SubViews
//===========================================================
extension SelectMusicPopUpVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitailViews() {
        
        self.popUpTableView.delegate = self
        self.popUpTableView.dataSource = self
        self.popUpTableView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.clear
        self.backView.backgroundColor = UIColor.clear
        self.musicBackView.backgroundColor = AppColors.musicBackColor
        self.statusBarView.backgroundColor = UIColor.clear
        self.backGroundView.backgroundColor = UIColor.clear
        self.popUpView.backgroundColor = AppColors.whiteColor
        self.chooseMusicLabel.textColor = AppColors.blackColor
        self.chooseMusicLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)
        
        self.submitBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(15)
        self.submitBtn.roundCommonButtonPositive(title: StringConstants.Done.localized)
    }
    
    //MARK:- Nib Register method
    //==========================
    fileprivate func registerNibs() {
    }
    
    func show(parentVC: UIViewController) {
        self.didMove(toParentViewController: parentVC)
    }
    
    // Animation performed
    func UpDownAnimation() {
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.statusBarView.backgroundColor = UIColor.clear
                        self.backGroundView.backgroundColor = UIColor.clear
                        self.backView.transform = CGAffineTransform(translationX: 0,
                                                                    y: -screenHeight)
        },
                       completion: { (doneWith) in
                        self.hidePopUp()
        })
    }
    
}

