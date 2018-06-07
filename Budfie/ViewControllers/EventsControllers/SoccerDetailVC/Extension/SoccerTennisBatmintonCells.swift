//
//  SoccerTennisBatmintonCells.swift
//  Budfie
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

class SportDetailCell: UITableViewCell {
    
    @IBOutlet weak var leagueNameLbl: UILabel!
//    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    @IBOutlet weak var firstTeamFormLbl: UILabel!
    
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    @IBOutlet weak var secondTeamFormLbl: UILabel!
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var lastScoreUpdateTimeLbl: UILabel!
    
    @IBOutlet weak var matchVenueAddressLbl: UILabel!
    @IBOutlet weak var scoreContainerView: UIView!

    @IBOutlet weak var durationContainerStackView: UIStackView!
    @IBOutlet weak var venueContainerStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        matchVenueAddressLbl.numberOfLines = 0
        resetData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func resetData() {
        
        leagueNameLbl.text = nil
//        matchNameLbl.text = nil
        durationLbl.text = nil
        
        firstTeamImageView.image = nil
        firstTeamNameLbl.text = nil
        firstTeamFormLbl.text = nil
        
        secondTeamImageView.image = nil
        secondTeamNameLbl.text = nil
        secondTeamFormLbl.text = nil
        
        scoreLbl.text = nil
        lastScoreUpdateTimeLbl.text = nil
        
        matchVenueAddressLbl.text = nil
//        matchNameLbl.isHidden = true

        durationContainerStackView.isHidden = false
        venueContainerStackView.isHidden = false
    }
    
    func populate(with sportDetail: SportDetail) {
        
        leagueNameLbl.text = sportDetail.league
        
        let placeholderImage = AppImages.myprofilePlaceholder
        
        if let url = URL(string: sportDetail.localTeamImage) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = sportDetail.localTeamName
        firstTeamFormLbl.text = nil //sportDetail.loc
        firstTeamFormLbl.isHidden = true
        
        if let url = URL(string: sportDetail.visitorTeamImage) {
            self.secondTeamImageView.sd_addActivityIndicator()
            self.secondTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            secondTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        secondTeamNameLbl.text = sportDetail.visitorTeamName
        secondTeamFormLbl.text = nil //sportDetail.loc
        secondTeamFormLbl.isHidden = true
        
        scoreLbl.text = "\(sportDetail.localTeamScore) / \(sportDetail.visitorTeamScore)"
        
//        lastScoreUpdateTimeLbl.text = sportDetail.soccerEventTime'

        let duration = "\(sportDetail.soccerEventDate ?? "") \(sportDetail.soccerEventTime ?? "")"
        if duration.isEmpty {
            durationContainerStackView.isHidden = true
        }
        durationLbl.text = duration

        if sportDetail.venue.isEmpty {
            venueContainerStackView.isHidden = true
        }
        matchVenueAddressLbl.text = sportDetail.venue
    }
}

class BatmintonTennisCell: UITableViewCell {
    
    var teamScoreModel: TennisBadmintonModel! = nil
    
    @IBOutlet weak var matchProgressLbl: UILabel!

    @IBOutlet weak var team1Player1NameLbl: UILabel!
    @IBOutlet weak var team1Player2NameLbl: UILabel!
    
    @IBOutlet weak var team2Player1NameLbl: UILabel!
    @IBOutlet weak var team2Player2NameLbl: UILabel!
    
    @IBOutlet weak var mainScoreLbl: UILabel!
    
    @IBOutlet weak var team1PlayersNameLbl: UILabel!
    @IBOutlet weak var team2PlayersNameLbl: UILabel!
    
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    
    @IBOutlet weak var matchVenueAddressLbl: UILabel!
    @IBOutlet weak var scoreContainerView: UIView!
    @IBOutlet weak var scoreCollectionWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
        resetData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func initialSetup() {
    
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        matchVenueAddressLbl.numberOfLines = 0
        
        scoreCollectionView.delegate = self
        scoreCollectionView.dataSource = self
    }
    
    func populate(model: TennisBadmintonModel) {
        
        matchProgressLbl.text = model.type
        
        if !model.team1.player2.isEmpty {
            
            team1Player1NameLbl.text = "\(model.team1.player1)/"
            team1Player2NameLbl.text = model.team1.player2
            team2Player1NameLbl.text = "\(model.team2.player1)/"
            team2Player2NameLbl.text = model.team2.player2
            team1PlayersNameLbl.text = "\(model.team1.player1)/ \(model.team1.player2)"
            team2PlayersNameLbl.text = "\(model.team2.player1)/ \(model.team2.player2)"

        } else {
            
            team1Player1NameLbl.text = "\(model.team1.player1)"
            team2Player1NameLbl.text = "\(model.team2.player1)"
            team1PlayersNameLbl.text = "\(model.team1.player1)"
            team2PlayersNameLbl.text = "\(model.team2.player1)"
            team1Player2NameLbl.text = ""
            team2Player2NameLbl.text = ""
        }
        
        mainScoreLbl.text = "\(model.team1.winning_set) - \(model.team2.winning_set)"
        matchVenueAddressLbl.text = model.venue
        
        self.scoreCollectionWidth.constant = (self.teamScoreModel.team1.score.count * 30).toCGFloat

    }
    
    private func resetData() {
        
         matchProgressLbl.text = nil
         team1Player1NameLbl.text = nil
         team1Player2NameLbl.text = nil
         team2Player1NameLbl.text = nil
         team2Player2NameLbl.text = nil
         mainScoreLbl.text = nil
         team1PlayersNameLbl.text = nil
         team2PlayersNameLbl.text = nil
         matchVenueAddressLbl.text = nil
    }
    
}

extension BatmintonTennisCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teamScoreModel.team1.score.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCellClass", for: indexPath) as? ScoreCellClass else {
            fatalError("ScoreCellClass not found")
        }
        
        cell.team1ScoreLbl.text = self.teamScoreModel.team1.score[indexPath.row]
        cell.team2ScoreLbl.text = self.teamScoreModel.team2.score[indexPath.row]
        
        return cell
    }
    
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension BatmintonTennisCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 20, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}


class ScoreCellClass: UICollectionViewCell {
    
    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}

class SoccerGoalScoreCell: UITableViewCell {

    @IBOutlet weak var scoreLbl: UILabel!
}
