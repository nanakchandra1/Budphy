//
//  SportsCricketCellClasses.swift
//  Budfie
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

class StartODICell: UITableViewCell {
    
    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var typeDateLocationLabel: UILabel!
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    
    @IBOutlet weak var roundedVLabel: UILabel!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    
    @IBOutlet weak var numberDayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var numberHourLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var numberMinLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    
    @IBOutlet weak var scoreContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        typeDateLocationLabel.numberOfLines = 0
        resetData()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.roundedVLabel.roundCorners()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func resetData() {
        
        typeDateLocationLabel.text = nil
        matchNameLbl .text = nil
        
        firstTeamImageView.image = nil
        firstTeamNameLbl.text = nil
        
        secondTeamImageView.image = nil
        secondTeamNameLbl.text = nil
        
        numberDayLabel.text = "0"
        dayLabel.text = "DAY"
        
        numberHourLabel.text = "0"
        hourLabel.text = "HOUR"
        
        numberMinLabel.text = "0"
        minLabel.text = "MIN"
        
        roundedVLabel.backgroundColor = AppColors.cricketVLabel
    }
    
    func populate(with cricketDetail: CricketDetailsModel) {

        var matchDate = ""
        var combinedTime = ""

        if let date = cricketDetail.match_date.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            matchDate = date.toString(dateFormat: DateFormat.cricketDate.rawValue)
            combinedTime = date.toString(dateFormat: DateFormat.calendarDate.rawValue)
        }

        typeDateLocationLabel.text = "\(cricketDetail.related_name) • \(matchDate), \(cricketDetail.venue)"
        matchNameLbl.text = cricketDetail.season_name
        
        let placeholderImage = AppImages.myprofilePlaceholder
        
        if let url = URL(string: cricketDetail.team1_img) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = cricketDetail.team1_short_name
        
        if let url = URL(string: cricketDetail.team2_img) {
            self.secondTeamImageView.sd_addActivityIndicator()
            self.secondTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            secondTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        secondTeamNameLbl.text = cricketDetail.team2_short_name
        combinedTime = "\(combinedTime) \(cricketDetail.match_time)"

        if let sTime = combinedTime.toDate(dateFormat: DateFormat.shortDate.rawValue) {

            let int = sTime.timeIntervalSince(Date())
            let days = int.days
            let hours = int.hours
            let mins = int.minutes
            
            if hours > 1 {
                hourLabel.text = "HOURS"
                numberHourLabel.text = "\(hours)"
            } else if hours == 1 {
                hourLabel.text = "HOUR"
                numberHourLabel.text = "1"
            } else {
                hourLabel.text = "HOUR"
                numberMinLabel.text = "0"
            }
            
            if mins > 1 {
                minLabel.text = "MINS"
                numberMinLabel.text = "\(mins)"
            } else if mins == 1 {
                minLabel.text = "MIN"
                numberMinLabel.text = "1"
            } else {
                minLabel.text = "MIN"
                numberMinLabel.text = "0"
            }
            
            if days > 1 {
                dayLabel.text = "DAYS"
                numberDayLabel.text = "\(days)"
            } else if days == 1 {
                dayLabel.text = "DAY"
                numberDayLabel.text = "1"
            } else {
                dayLabel.text = "DAY"
                numberDayLabel.text = "0"
            }
        }
    }
    
}

class InprogressODICell: UITableViewCell {
    
    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var typeDateLocationLabel: UILabel!
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    
    @IBOutlet weak var tossLabel: UILabel!
    
    @IBOutlet weak var scoreContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        typeDateLocationLabel.numberOfLines = 0
        resetData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func resetData() {
        
        typeDateLocationLabel.text = nil
        matchNameLbl .text = nil
        
        firstTeamImageView.image = nil
        firstTeamNameLbl.text = nil
        
        secondTeamImageView.image = nil
        secondTeamNameLbl.text = nil
        tossLabel.text = nil
    }
    
    func populate(with cricketDetail: CricketDetailsModel) {
        
        if let date = cricketDetail.match_date.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            cricketDetail.match_date = date.toString(dateFormat: DateFormat.cricketDate.rawValue)
        }
        
        typeDateLocationLabel.text = "\(cricketDetail.related_name) • \(cricketDetail.match_date), \(cricketDetail.venue)"
        matchNameLbl.text = cricketDetail.name
        
        let placeholderImage = AppImages.myprofilePlaceholder
        
        if let url = URL(string: cricketDetail.team1_img) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = "\(cricketDetail.team1_short_name) - \(cricketDetail.innings[0].team_run)/\(cricketDetail.innings[0].team_wicket) (\(cricketDetail.innings[0].team_over))" // changes
        
        if let url = URL(string: cricketDetail.team2_img) {
            self.secondTeamImageView.sd_addActivityIndicator()
            self.secondTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            secondTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        secondTeamNameLbl.text = cricketDetail.team2_short_name
        tossLabel.text = cricketDetail.toss
        
    }
    
}

class Inprogress2InningODICell: UITableViewCell {
    
    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var typeDateLocationLabel: UILabel!
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    
    @IBOutlet weak var remainingScoreLabel: UILabel!
    
    @IBOutlet weak var runRateLabel: UILabel!
    @IBOutlet weak var currentRunRateLabel: UILabel!
    
    @IBOutlet weak var batsman1Label: UILabel!
    @IBOutlet weak var batsman2Label: UILabel!
    
    @IBOutlet weak var scoreContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        typeDateLocationLabel.numberOfLines = 0
        remainingScoreLabel.numberOfLines = 0
        resetData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func resetData() {
        
        typeDateLocationLabel.text = nil
        matchNameLbl .text = nil
        
        firstTeamImageView.image = nil
        firstTeamNameLbl.text = nil
        
        secondTeamImageView.image = nil
        secondTeamNameLbl.text = nil
        
        remainingScoreLabel.text = nil
        runRateLabel.text = nil
        currentRunRateLabel.text = nil
        batsman1Label.text = nil
        batsman2Label.text = nil
    }
    
    func populate(with cricketDetail: CricketDetailsModel) {
        
        if let date = cricketDetail.match_date.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            cricketDetail.match_date = date.toString(dateFormat: DateFormat.cricketDate.rawValue)
        }
        
        typeDateLocationLabel.text = "\(cricketDetail.related_name) • \(cricketDetail.match_date), \(cricketDetail.venue)"
        matchNameLbl.text = cricketDetail.name
        
        let placeholderImage = AppImages.myprofilePlaceholder
        
        if let url = URL(string: cricketDetail.team2_img) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }

        secondTeamNameLbl.text = "\(cricketDetail.team2_short_name) - \(cricketDetail.innings[1].team_run)/\(cricketDetail.innings[1].team_wicket) (\(cricketDetail.innings[1].team_over))" // changes
        
        if let url = URL(string: cricketDetail.team1_img) {
            self.secondTeamImageView.sd_addActivityIndicator()
            self.secondTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            secondTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = "\(cricketDetail.team1_short_name) - \(cricketDetail.innings[0].team_run)/\(cricketDetail.innings[0].team_wicket) (\(cricketDetail.innings[0].team_over))"

        if cricketDetail.innings[1].current_player1 != "" {

            if cricketDetail.innings[1].req_runs_rate != "0.0" {
                runRateLabel.text = "RRR: \(cricketDetail.innings[1].req_runs_rate)"
            } else {
                runRateLabel.isHidden = true
            }
            currentRunRateLabel.text = "CRR: \(cricketDetail.innings[1].current_runs_rate)"
            remainingScoreLabel.text = cricketDetail.result
            batsman1Label.text = "\(cricketDetail.innings[1].current_player1) \(cricketDetail.innings[1].current_player1_run)* (\(cricketDetail.innings[1].current_player1_balls))"
            batsman2Label.text = "\(cricketDetail.innings[1].current_player2) \(cricketDetail.innings[1].current_player2_run)* (\(cricketDetail.innings[1].current_player2_balls))"

        } else {

            if cricketDetail.innings[1].req_runs_rate != "0.0" {
                runRateLabel.text = "RRR: \(cricketDetail.innings[0].req_runs_rate)"
            } else {
                runRateLabel.isHidden = true
            }
            currentRunRateLabel.text = "CRR: \(cricketDetail.innings[0].current_runs_rate)"
            remainingScoreLabel.text = cricketDetail.result
            batsman1Label.text = "\(cricketDetail.innings[0].current_player1) \(cricketDetail.innings[0].current_player1_run)* (\(cricketDetail.innings[0].current_player1_balls))"
            batsman2Label.text = "\(cricketDetail.innings[0].current_player2) \(cricketDetail.innings[0].current_player2_run)* (\(cricketDetail.innings[0].current_player2_balls))"
        }
    }
    
}

class completedODICell: UITableViewCell {
    
    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var typeDateLocationLabel: UILabel!
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    
    @IBOutlet weak var remainingScoreLabel: UILabel!
    
    @IBOutlet weak var manOfMatchLabel: UILabel!
    @IBOutlet weak var highestRunsLabel: UILabel!
    
    @IBOutlet weak var highestWicketLabel: UILabel!
    
    @IBOutlet weak var scoreContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        typeDateLocationLabel.numberOfLines = 0
        remainingScoreLabel.numberOfLines = 0
        resetData()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
    
    private func resetData() {
        
        typeDateLocationLabel.text = nil
        matchNameLbl .text = nil
        
        firstTeamImageView.image = nil
        firstTeamNameLbl.text = nil
        
        secondTeamImageView.image = nil
        secondTeamNameLbl.text = nil
        
        remainingScoreLabel.text = nil
        manOfMatchLabel.text = nil
        highestRunsLabel.text = nil
        highestWicketLabel.text = nil
    }
    
    func populate(with cricketDetail: CricketDetailsModel) {
        
        if let date = cricketDetail.match_date.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            cricketDetail.match_date = date.toString(dateFormat: DateFormat.cricketDate.rawValue)
        }
        
        typeDateLocationLabel.text = "\(cricketDetail.related_name) • \(cricketDetail.match_date), \(cricketDetail.venue)"
        matchNameLbl.text = cricketDetail.name
        
        let placeholderImage = AppImages.myprofilePlaceholder

        if let url = URL(string: cricketDetail.team2_img) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = "\(cricketDetail.team2_short_name) - \(cricketDetail.innings[1].team_run)/\(cricketDetail.innings[1].team_wicket) (\(cricketDetail.innings[1].team_over))" // changes
        
        if let url = URL(string: cricketDetail.team1_img) {
            self.secondTeamImageView.sd_addActivityIndicator()
            self.secondTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            secondTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        secondTeamNameLbl.text = "\(cricketDetail.team1_short_name) - \(cricketDetail.innings[0].team_run)/\(cricketDetail.innings[0].team_wicket) (\(cricketDetail.innings[0].team_over))"
        
        remainingScoreLabel.text = cricketDetail.result
        manOfMatchLabel.text = cricketDetail.man_of_match
        highestRunsLabel.text = cricketDetail.highest_run
        highestWicketLabel.text = cricketDetail.highest_wicket
    }
    
}

class MatchHeadCell: UITableViewCell {
    
    @IBOutlet weak var matchNameLbl: UILabel!
    @IBOutlet weak var typeDateLocationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        typeDateLocationLabel.numberOfLines = 0
        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        matchNameLbl.text = nil
        typeDateLocationLabel.text = nil
    }

    func populate(with cricketDetail: CricketDetailsModel) {
        
        if let date = cricketDetail.match_date.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            cricketDetail.match_date = date.toString(dateFormat: DateFormat.cricketDate.rawValue)
        }
        
        typeDateLocationLabel.text = "\(cricketDetail.related_name) • \(cricketDetail.match_date), \(cricketDetail.venue)"
        matchNameLbl.text = cricketDetail.name
    }
}

class TossCell: UITableViewCell {
    
    @IBOutlet weak var tossLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        tossLbl.text = nil
    }
}

class InningsCell : UITableViewCell {
    
    @IBOutlet weak var inningsLbl: UILabel!
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    @IBOutlet weak var scoreContainerView: UIView!
    @IBOutlet weak var scoreInningsContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreContainerView.layer.cornerRadius = 6
        scoreContainerView.layer.borderWidth = 0.5
        scoreContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        scoreInningsContainerView.layer.cornerRadius = 6
        scoreInningsContainerView.backgroundColor = AppColors.imageBackView
        
        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        inningsLbl.text = nil
        firstTeamNameLbl.text = nil
        firstTeamImageView.image = nil
    }
    
    func populate(with inningsDetails: InningsModel) {
        
        let placeholderImage = AppImages.myprofilePlaceholder
        
        if let url = URL(string: inningsDetails.team_img) {
            self.firstTeamImageView.sd_addActivityIndicator()
            self.firstTeamImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            firstTeamImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        firstTeamNameLbl.text = "\(inningsDetails.team_short_name) - \(inningsDetails.team_run)/\(inningsDetails.team_wicket) (\(inningsDetails.team_over))" // changes
        
    }
    
}


class SportDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        reset()
        descriptionLbl.numberOfLines = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        descriptionLbl.text = nil
    }
}
