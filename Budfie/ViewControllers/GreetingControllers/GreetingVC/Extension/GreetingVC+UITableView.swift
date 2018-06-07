////
////  GreetingVC+UITableView.swift
////  Budfie
////
////  Created by aishwarya rastogi on 10/01/18.
////  Copyright © 2018 Budfie. All rights reserved.
////
//
//import Foundation
//
////MARK:- Extension for UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
////======================================================================================
//extension GreetingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.row {
//        case 0,2:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GreetingCollectionViewCell.self), for: indexPath) as! GreetingCollectionViewCell
//            cell.imageView.image = self.imageArray[indexPath.row]
//            return cell
//            
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Greeting2CollectionViewCell.self), for: indexPath) as! Greeting2CollectionViewCell
//            cell.imageView.image = self.imageArray[indexPath.row]
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height:100)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//}

