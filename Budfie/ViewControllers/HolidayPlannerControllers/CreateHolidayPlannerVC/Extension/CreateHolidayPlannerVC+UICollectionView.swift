//
//  CreateHolidayPlannerVC+UICollectionView.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 27/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//


extension TrendingDestinationCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationDescriptionCell", for: indexPath) as? DestinationDescriptionCell else { fatalError("DestinationDescriptionCell not found") }
        
        if isNational {
            cell.destinationLocationLabel.text = nationalPlaces[indexPath.row]
            cell.destinationImage.image = nationalImages[indexPath.row]
        } else {
            cell.destinationLocationLabel.text = interNationalPlaces[indexPath.row]
            cell.destinationImage.image = interNationalImages[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var placeName = String()
        if isNational {
            placeName = nationalPlaces[indexPath.row]
        } else {
            placeName = interNationalPlaces[indexPath.row]
        }
        delegate?.getLocation(isNational: isNational, placeName: placeName)
    }
    
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension TrendingDestinationCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenWidth - 60, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    }
}
