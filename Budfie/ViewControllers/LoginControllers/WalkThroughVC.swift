//
//  WalkThroughVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import CHIPageControl

class WalkThroughVC: BaseVc {

    let walkThroughImages = [#imageLiteral(resourceName: "walkthrough"), #imageLiteral(resourceName: "walkthrough2"), #imageLiteral(resourceName: "walkthrough3"), #imageLiteral(resourceName: "walkthrough4")]

    @IBOutlet weak var walkThroughCollectionView: UICollectionView!

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var pageControl: CHIPageControlJalapeno!

    override func viewDidLoad() {
        super.viewDidLoad()

        walkThroughCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "\(ImageCollectionCell.self)")

        walkThroughCollectionView.contentInset = .zero
        walkThroughCollectionView.dataSource = self
        walkThroughCollectionView.delegate = self

        pageControl.radius = 5
        pageControl.tintColor = .white
        pageControl.numberOfPages = walkThroughImages.count
    }

    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

     AppUserDefaults.save(value: true, forKey: .isDisplayingWalkThrough)
     }
     */

    @IBAction func skipBtnTapped(_ sender: UIButton) {
        //AppUserDefaults.save(value: false, forKey: .isDisplayingWalkThrough)

        let logInScene = LogInVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(logInScene, animated: true)
    }
}

extension WalkThroughVC: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walkThroughImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell else {
            fatalError("ImageCollectionCell not found")
        }

        cell.videoImageView.isHidden = true
        cell.imageView.image = walkThroughImages[indexPath.row]
        return cell
    }
}

extension WalkThroughVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.frame.origin.y = 0
    }
}

extension WalkThroughVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size
    }
}

extension WalkThroughVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)

        let numberOfPages = walkThroughImages.count
        let progress = percent * Double(numberOfPages - 1)

        if progress > (Double(numberOfPages - 2) + 0.5) {
            skipBtn.setTitle("LET'S GET STARTED", for: .normal)

        } else if progress < Double(numberOfPages - 3) {

        } else {
            skipBtn.setTitle("SKIP", for: .normal)
        }

        pageControl.progress = progress
    }
}
