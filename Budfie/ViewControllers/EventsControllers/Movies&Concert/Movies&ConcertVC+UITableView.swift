//
//  Movies&ConcertVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SafariServices

extension MoviesSeriesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventDetailsModel == nil {
            return 0
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else { fatalError("TableTopCurveHeaderFooterView not found") }

        //headerCell.shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        return headerCell

        /*
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView else { fatalError("AddEventHeaderView not found") }
        
        self.headerView = headerView
        
        self.headerView.centerMovieBtn.addTarget(self,
                                                 action: #selector(self.playMovie(_:)),
                                                 for: .touchUpInside)
        headerView.setForMoviesOrConcert()
        headerView.eventsImage.curvHeaderView(height: 250)
        headerView.overlayView.curvHeaderView(height: 250)
        /*
        headerView.submitImageBtn.addTarget(self,
                                            action: #selector(self.shareBtnTapped(_:)),
                                            for: .touchUpInside)
        headerView.sideCameraBtn.addTarget(self,
                                           action: #selector(self.unFavBtnTapped(_:)),
                                           for: .touchUpInside)
        headerView.backBtn.addTarget(self,
                                     action: #selector(self.backBtnTapped(_:)),
                                     for: .touchUpInside)
        */
        if let image = self.eventDetailsModel?.eventImage {
            headerView.eventsImage.setImage(withSDWeb: image,
                                            placeholderImage: AppImages.icEventsbudfiePlaceholder)
        }
        
        if self.moviesOrConcert == .movies {
            headerView.headerLabel.text = "Movies"
        } else {
            headerView.headerLabel.text = "Concert"
            headerView.centerMovieBtn.isHidden = true
        }
        if let fav = self.eventDetailsModel?.isFavourite, fav == "0" {
            headerView.sideCameraBtn.isSelected = false
            headerView.sideCameraBtn.setImage(AppImages.icUnselectFav, for: .normal)
        } else {
            headerView.sideCameraBtn.isSelected = true
            headerView.sideCameraBtn.setImage(AppImages.icSelectFav, for: .normal)
        }
        return headerView
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.moviesOrConcert == .movies {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesDetails", for: indexPath) as? MoviesDetails else { fatalError("MoviesDetails") }
            
            if let ob = self.eventDetailsModel {
                cell.populate(obMovies: ob)
            }
            
            cell.ticketLinkBtn.addTarget(self,
                                         action: #selector(ticketLinkBtnTapped(_ : )),
                                         for: UIControlEvents.touchUpInside)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConcertCell", for: indexPath) as? ConcertCell else { fatalError("ConcertCell") }
            
            if let ob = self.eventDetailsModel {
                cell.populate(obConcert: ob)
            }
            cell.ticketLinkBtn.addTarget(self,
                                         action: #selector(ticketLinkBtnTapped(_ : )),
                                         for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    @objc func playMovie(_ sender: UIButton) {

        if let urlString = eventDetailsModel?.eventVideo {
            let trailerPlayerScene = TrailersPlayerVC.instantiate(fromAppStoryboard: .Events)
            trailerPlayerScene.url = urlString
            present(trailerPlayerScene, animated: false, completion: nil)
        }

        /*
        if let url = URL(string:self.eventDetailsModel?.eventVideo ?? "") {
            
            if #available(iOS 9.0, *) {
                
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        */
        
    }
    
}

//MARK: Extension: for UIScrollViewDelegate
//=========================================
extension MoviesSeriesVC: UIScrollViewDelegate {

    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}

class MoviesDetails: UITableViewCell {
    
    @IBOutlet weak var moviesNameLabel: UILabel!
    @IBOutlet weak var moviesTypeLabel: UILabel!
    @IBOutlet weak var moviesDurationLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var dateLocationLabel: UILabel!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var moviesDescLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var ticketURLLabel: UILabel!
    @IBOutlet weak var ticketLinkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    func initialSetUp() {
        
        self.moviesNameLabel.textColor = AppColors.blackColor
        self.moviesNameLabel.font = AppFonts.Comfortaa_Bold_0.withSize(17.5)
        
        self.moviesTypeLabel.textColor = AppColors.blackColor
        self.moviesTypeLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.moviesDurationLabel.textColor = AppColors.blackColor
        self.moviesDurationLabel.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        
        self.releaseLabel.text = "Release"
        self.releaseLabel.textColor = AppColors.blackColor
        self.releaseLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.5)
        
        self.dateLocationLabel.textColor = AppColors.blackColor
        self.dateLocationLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.descTitleLabel.text = "Storyline"
        self.descTitleLabel.textColor = AppColors.blackColor
        self.descTitleLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.3)
        
        self.moviesDescLabel.textColor = AppColors.blackColor
        self.moviesDescLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.ticketLabel.text = "Tickets will be avaliable here"
        self.ticketLabel.textColor = AppColors.popUpBackground
        self.ticketLabel.font = AppFonts.Comfortaa_Bold_0.withSize(12)
        
        self.ticketURLLabel.textColor = AppColors.themeBlueColor
        self.ticketURLLabel.font = AppFonts.Comfortaa_Bold_0.withSize(14)
    }
    
    func populate(obMovies: EditEventDetailsModel) {
        
        self.moviesNameLabel.text = obMovies.eventName
        self.moviesTypeLabel.text = obMovies.genre
        self.moviesDurationLabel.text = obMovies.duration
        if let d = obMovies.moviereleaseDate {
            self.dateLocationLabel.text = "In Cinemas on \(d) (India)"
        }
        self.moviesDescLabel.text = obMovies.story
        self.ticketURLLabel.text = obMovies.url
    }
    
}

class ConcertCell: UITableViewCell {
    
    @IBOutlet weak var concertNameLabel: UILabel!
    @IBOutlet weak var dayDateTimeLabel: UILabel!
    @IBOutlet weak var concertDurationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var concertDescLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var ticketURLLabel: UILabel!
    @IBOutlet weak var ticketLinkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.initialSetUp()
    }
    
    func initialSetUp() {
        
        self.concertNameLabel.textColor = AppColors.blackColor
        self.concertNameLabel.font = AppFonts.Comfortaa_Bold_0.withSize(17.5)
        
        self.dayDateTimeLabel.textColor = AppColors.popUpBackground
        self.dayDateTimeLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.concertDurationLabel.textColor = AppColors.popUpBackground
        self.concertDurationLabel.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        
        self.locationLabel.textColor = AppColors.popUpBackground
        self.locationLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.descTitleLabel.text = "Description"
        self.descTitleLabel.textColor = AppColors.blackColor
        self.descTitleLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.3)
        
        self.concertDescLabel.textColor = AppColors.popUpBackground
        self.concertDescLabel.font = AppFonts.Comfortaa_Regular_0.withSize(14)
        
        self.ticketLabel.text = "Tickets will be avaliable here"
        self.ticketLabel.textColor = AppColors.popUpBackground
        self.ticketLabel.font = AppFonts.Comfortaa_Bold_0.withSize(12)
        
        self.ticketURLLabel.textColor = AppColors.themeBlueColor
        self.ticketURLLabel.font = AppFonts.Comfortaa_Bold_0.withSize(14)
    }
    
    func populate(obConcert: EditEventDetailsModel) {
        
        self.concertNameLabel.text = obConcert.eventName
        if let d = obConcert.concertreleaseDate, let t = obConcert.concertTime {
            self.dayDateTimeLabel.text = "\(obConcert.day), \(d) \(t)"
        }
        self.concertDurationLabel.text = obConcert.duration
        self.locationLabel.text = obConcert.eventAddress
        self.concertDescLabel.text = obConcert.description
        self.ticketURLLabel.text = obConcert.purchase_url
    }
    
}
