//
//  CalmMusicVC.swift
//  Budfie
//
//  Created by appinventiv on 10/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FreeStreamer

class CalmMusicVC: BaseVc {
    
    //MARK:- Properties
    //=================
    lazy var audioPlayer = FSAudioStream()
    var index: IndexPath = [-1,-1]
    var songName = ["Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me",
                    "Next To Me"]
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
//    @IBOutlet weak var logoutBtn        : UIButton!
    @IBOutlet weak var showMusicList    : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNib()
        self.initialSetup()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        pop()
    }
}


//MARK:- Private Extension
//========================
extension CalmMusicVC {
    
    private func initialSetup() {
        
        self.showMusicList.delegate = self
        self.showMusicList.dataSource = self
        self.showMusicList.backgroundColor = UIColor.clear
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
    }
    
    private func registerNib() {
        
        let cell = UINib(nibName: "CalmMusicCell", bundle: nil)
        self.showMusicList.register(cell, forCellReuseIdentifier: "CalmMusicCell")
    }
    
    func playMusic() {
        if let path = Bundle.main.path(forResource: "melodyloops-preview-happy-trip-1m0s", ofType: ".mp3"),
            let musicURL = URL(string: "file://\(path)") {
            audioPlayer.play(from: musicURL)
        }
    }
}


