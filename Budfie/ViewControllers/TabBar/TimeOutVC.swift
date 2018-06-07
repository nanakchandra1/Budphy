//
//  TimeOutVC.swift
//  beziarPath
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

//MARK: TimeOutVC class
//=====================
class TimeOutVC: BaseVc {
    
    //MARK: Property
    //==============
    let image = [AppImages.ic_happy_graphic,
                 AppImages.ic_bored_graphic,
                 AppImages.ic_fight_graphic,
                 AppImages.ic_bad_day_graphic,
                 AppImages.ic_sad_graphic]
    let headerText = [StringConstants.K_Happy.localized,
                      StringConstants.K_Bored.localized,
                      StringConstants.K_Fight.localized,
                      StringConstants.K_Bad_Day.localized,
                      StringConstants.K_Sad.localized]
    let backColors = [AppColors.happy,
                      AppColors.bored,
                      AppColors.fight,
                      AppColors.badDay,
                      AppColors.sad]
    var pageNumber: Int {
        return Int(ceil(self.timeOutCollectionView.contentOffset.x / self.timeOutCollectionView.width))
    }
    
    var panGesture: UIPanGestureRecognizer!
    var isScrollingEnabled = true
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var timeOutCollectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var sliderBaseView: UIView!
    @IBOutlet weak var happyBtn: UIButton!
    @IBOutlet weak var boredBtn: UIButton!
    @IBOutlet weak var fightBtn: UIButton!
    @IBOutlet weak var badDayBtn: UIButton!
    @IBOutlet weak var sadBtn: UIButton!
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var boredLabel: UILabel!
    @IBOutlet weak var fightLabel: UILabel!
    @IBOutlet weak var sadLabel: UILabel!
    @IBOutlet weak var BadDayLabel: UILabel!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setSliderView()
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func happyBtnTapped(_ sender: UIButton) {
        self.timeOutCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func boredBtnTapped(_ sender: UIButton) {
        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
    }
    
    @IBAction func fightBtnTapped(_ sender: UIButton) {
        self.timeOutCollectionView.setContentOffset(CGPoint(x: 2 * screenWidth, y: 0), animated: true)
    }
    
    @IBAction func badDayBtnTapped(_ sender: UIButton) {
        self.timeOutCollectionView.setContentOffset(CGPoint(x: 3 * screenWidth, y: 0), animated: true)
    }
    
    @IBAction func sadBtnTapped(_ sender: UIButton) {
        self.timeOutCollectionView.setContentOffset(CGPoint(x: 4 * screenWidth, y: 0), animated: true)
    }
    
}

//MARK: Extension for InitialSetup and private methods
//====================================================
extension TimeOutVC {
    
    func initialSetUp() {
        
        self.timeOutCollectionView.delegate = self
        self.timeOutCollectionView.dataSource = self
        self.panGesture = UIPanGestureRecognizer(target: self,
                                                 action: #selector(self.panGestureAction(_:)))
        self.sliderView.addGestureRecognizer(self.panGesture)
        self.sliderView.dropShadow(width: 10, shadow: AppColors.whiteColor)

        self.roundSubmitBtn()
        self.setLabels()
    }
    
    func roundSubmitBtn() {
        
        self.submitBtn.layer.borderWidth = 2
        self.submitBtn.roundCommonButton(title: StringConstants.SUBMIT.localized)
        self.submitBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.submitBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.submitBtn.backgroundColor = UIColor.clear
        self.submitBtn.layer.borderColor = AppColors.whiteColor.cgColor
    }
    
    func setSliderView() {
        
        self.sliderView.border(width: 7, borderColor: AppColors.FacetextColor)
        self.sliderView.layer.cornerRadius = self.sliderView.frame.width / 2
//        self.sliderView.layer.shadowColor = AppColors.whiteColor.cgColor
//        self.sliderView.layer.shadowRadius = 10
//        self.sliderView.layer.shadowOpacity = 1
    }
    
    func setLabels() {
        
        self.happyLabel.text  = StringConstants.K_Happy.localized
        self.boredLabel.text  = StringConstants.K_Bored.localized
        self.fightLabel.text  = StringConstants.K_Fight.localized
        self.BadDayLabel.text = StringConstants.K_Bad_Day.localized
        self.sadLabel.text    = StringConstants.K_Sad.localized
        
        self.happyLabel.textColor  = AppColors.FacetextColor
        self.boredLabel.textColor  = AppColors.FacetextColor
        self.fightLabel.textColor  = AppColors.FacetextColor
        self.BadDayLabel.textColor = AppColors.FacetextColor
        self.sadLabel.textColor    = AppColors.FacetextColor
        
        self.setFonts()
    }
    
    func setFonts() {
        self.happyLabel.font  = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.boredLabel.font  = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.fightLabel.font  = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.BadDayLabel.font = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.sadLabel.font    = AppFonts.Comfortaa_Regular_0.withSize(15)
    }
    
    func setFontOnScroll(row: Int) {
        self.setFonts()
        switch row {
        case 0:
            self.happyLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        case 1:
            self.boredLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        case 2:
            self.fightLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        case 3:
            self.BadDayLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        default:
            self.sadLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        }
    }
    
}


extension TimeOutVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeFaceCell", for: indexPath) as? ChangeFaceCell else { fatalError("ChangeFaceCell not found") }
        
        cell.backFaceImage.image = self.image[indexPath.row]
        cell.headerLabel.text = self.headerText[indexPath.row]
        cell.contentView.backgroundColor = self.backColors[indexPath.row]
    
        return cell
    }
    
}


extension TimeOutVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.timeOutCollectionView.width, height: self.timeOutCollectionView.height)
    }
}


extension TimeOutVC {
    
    //ScrollView delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.panGesture.state != .changed && self.panGesture.state != .began && self.isScrollingEnabled {
            let ratio = (self.view.frame.width-(self.happyBtn.frame.midX*2))/(scrollView.contentSize.width-self.view.frame.width)
            self.sliderView.center.x = ((scrollView.contentOffset.x)*ratio)+self.happyBtn.frame.midX
        }
    }
    
    @objc private func panGestureAction(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: self.sliderView)
        panGesture.setTranslation(.zero, in: sliderView)
        
        switch pan.state {
        case .began:
            return
            
        case .cancelled:
            return
            
        case .changed:
            
            guard self.sliderView.center.x >= self.happyBtn.frame.midX && self.sliderView.center.x <= self.sadBtn.frame.midX else { return }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.sliderView.center.x += translation.x
            }, completion: { (finished) in
                if self.sliderView.center.x < self.happyBtn.frame.midX {
                    self.sliderView.center.x = self.happyBtn.frame.midX
                } else if self.sliderView.center.x > self.sadBtn.frame.midX {
                    self.sliderView.center.x = self.sadBtn.frame.midX
                }
            })
            
            let ratio = (self.view.frame.width*4)/(self.view.frame.width-(self.happyBtn.frame.midX*2))
            self.timeOutCollectionView.contentOffset.x = ((self.sliderView.center.x-self.happyBtn.frame.midX)*ratio)
            
            if self.timeOutCollectionView.contentOffset.x < 0 {
                self.timeOutCollectionView.contentOffset.x = 0
            } else if self.timeOutCollectionView.contentOffset.x > (self.view.frame.width*4) {
                self.timeOutCollectionView.contentOffset.x = (self.view.frame.width*4)
            }
            
        case .ended:
            
            self.isScrollingEnabled = false
            let slideCenter = self.sliderView.frame.midX
            let distance = self.boredBtn.frame.midX - self.happyBtn.frame.midX
            
            UIView.animate(withDuration: 0.2, animations: {
                if slideCenter >= self.happyBtn.frame.midX && slideCenter <= self.boredBtn.frame.midX {
                    if (slideCenter+(distance/2)) < self.boredBtn.frame.midX {
                        self.sliderView.center.x = self.happyBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    } else {
                        self.sliderView.center.x = self.boredBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
                    }
                } else if slideCenter >= self.boredBtn.frame.midX && slideCenter <= self.fightBtn.frame.midX {
                    if (slideCenter+(distance/2)) < self.fightBtn.frame.midX {
                        self.sliderView.center.x = self.boredBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
                    } else {
                        self.sliderView.center.x = self.fightBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth*2, y: 0), animated: true)
                    }
                } else if slideCenter >= self.fightBtn.frame.midX && slideCenter <= self.badDayBtn.frame.midX {
                    if (slideCenter+(distance/2)) < self.badDayBtn.frame.midX {
                        self.sliderView.center.x = self.fightBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth*2, y: 0), animated: true)
                    } else {
                        self.sliderView.center.x = self.badDayBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth*3, y: 0), animated: true)
                    }
                } else if slideCenter >= self.badDayBtn.frame.midX && slideCenter <= self.sadBtn.frame.midX {
                    if (slideCenter+(distance/2)) < self.sadBtn.frame.midX {
                        self.sliderView.center.x = self.badDayBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth*3, y: 0), animated: true)
                    } else {
                        self.sliderView.center.x = self.sadBtn.frame.midX
                        self.timeOutCollectionView.setContentOffset(CGPoint(x: screenWidth*4, y: 0), animated: true)
                    }
                }
            }, completion: { (finished) in
                if finished {
                    delayWithSeconds(0.2, completion: {
                        self.isScrollingEnabled = true
                        
                    })
                }
            })
            
        case .failed:
            return
            
        case .possible:
            return
        }
    }
    
}


class ChangeFaceCell: UICollectionViewCell {
    
    @IBOutlet weak var backFaceImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.backFaceImage.image = AppImages.ic_congratulations
        self.headerLabel.font = AppFonts.Comfortaa_Bold_0.withSize(30)
        self.headerLabel.textColor = AppColors.whiteColor
    }
    
}

