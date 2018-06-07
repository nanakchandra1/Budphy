//
//  InterestsCell.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 21/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

protocol updateOrPushToVCDelegate {
    func updateOrPush(isPush: Bool,selectedId : [String])
}

//MARK:- TableCellForCollectionView class
//=======================================
class InterestsCell: BaseCell {
    
    //MARK:- Properties
    //=================
    
    static var selectedId  = [String]()
    var selectedCricketId  = [String]()
    var selectedFootballId = [String]()
    var delegate : updateOrPushToVCDelegate?
    var removeId : String?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var addInterestsCollectionView: UICollectionView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var intrestLabel: UILabel!
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetup()
        self.registerNibs()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


//MARK: Extension for Registering Nibs and Setting Up SubViews
//============================================================
extension InterestsCell {
    
    private func initialSetup(){
        
        self.addInterestsCollectionView.delegate = self
        self.addInterestsCollectionView.dataSource = self
        self.baseView.backgroundColor = AppColors.addEventBaseLine
        self.intrestLabel.textColor = AppColors.floatingPlaceHolder
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "EditCell", bundle: nil)
        self.addInterestsCollectionView.register(cell, forCellWithReuseIdentifier: "EditCell")
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        
        guard let indexPath = sender.collectionViewIndexPath(self.addInterestsCollectionView) else {
            return
        }
        let id = InterestsCell.selectedId[indexPath.row-1]
        InterestsCell.selectedId = InterestsCell.selectedId.filter { $0 != String(id)}
        self.delegate?.updateOrPush(isPush: false, selectedId: InterestsCell.selectedId)
        self.addInterestsCollectionView.reloadData()
    }
    
}


//MARK: Extension for UICollectionView Delegate and DataSource
//============================================================
extension InterestsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InterestsCell.selectedId.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCell", for: indexPath) as? EditCell else { fatalError("EditCell not found") }
        switch indexPath.row {
        case 0:
            cell.populateFirstCell()
        default:
            cell.populateData(id: InterestsCell.selectedId[indexPath.row-1] )
            cell.removeBtn.addTarget(self,
                                     action: #selector(self.removeButtonTapped(_:)),
                                     for: UIControlEvents.touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            delegate?.updateOrPush(isPush: true, selectedId: InterestsCell.selectedId)
            
        }
    }
    
}

//MARK: Extension for UICollectionView Layout
//===========================================

extension InterestsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: addInterestsCollectionView.frame.height -  30, height:addInterestsCollectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0//spacingBetweenItems - 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0//spacingTopDownItems
    }
    
}

