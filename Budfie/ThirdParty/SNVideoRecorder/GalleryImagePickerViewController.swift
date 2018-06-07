//
//  GalleryImagePickerViewController.swift
//  SNVideoRecorder_Example
//
//  Created by Aakash Srivastav on 07/03/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Photos

class GalleryImagePickerViewController: UIViewController {

    weak var delegate: SNImageViewerDelegate?

    private var assets = [PHAsset]() {
        didSet {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
    private let targetImageSize = CGSize(width: 100, height: 100)
    private let imageContentMode: PHImageContentMode = .aspectFill
    private let cachingManager = PHCachingImageManager.default() as? PHCachingImageManager
    private var currentRequestingAssetIds = [IndexPath: PHImageRequestID]()

    private var galleryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print_debug("Good to proceed")
                self.fetchAssets()
            case .denied, .restricted:
                print_debug("Not allowed")
            case .notDetermined:
                print_debug("Not determined yet")
            }
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        galleryCollectionView.backgroundColor = .clear
        galleryCollectionView.showsHorizontalScrollIndicator = false
        galleryCollectionView.showsVerticalScrollIndicator = false
        galleryCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "\(ImageCollectionCell.self)")

        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self

        view.addSubview(galleryCollectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.frame = view.bounds
    }

    private func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d AND duration < 10", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let fetchResults = PHAsset.fetchAssets(with: fetchOptions)
        assets = FetchPhoto.assetCollection(result: fetchResults)

        cachingManager?.allowsCachingHighQualityImages = false
        cachingManager?.startCachingImages(for: assets, targetSize: targetImageSize, contentMode: imageContentMode, options: nil)

        /*
         DispatchQueue.main.async {
         self.galleryCollectionView.reloadData()
         }
         */
    }

}

extension GalleryImagePickerViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell else {
            fatalError("ImageCollectionCell not found")
        }

        let asset = assets[indexPath.item]

        switch asset.mediaType {
        case .image:
            cell.videoImageView.isHidden = true
            cachingManager?.requestImage(for: asset, targetSize: targetImageSize, contentMode: imageContentMode, options: nil, resultHandler: { (optionalImage, _) in
                DispatchQueue.main.async {
                    cell.imageView.image = optionalImage
                }
            })

        case .video:
            cell.videoImageView.isHidden = false
            cachingManager?.requestAVAsset(forVideo: asset, options: nil, resultHandler: { (optionalAsset, _, _) in

                guard let unwrappedAsset = optionalAsset else {
                    return
                }
                let assetImgGenerate = AVAssetImageGenerator(asset: unwrappedAsset)
                assetImgGenerate.appliesPreferredTrackTransform = true

                let time = CMTimeMake(1, 30)
                let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)

                guard let cgImage = img else { return }

                let frameImg = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    cell.imageView.image = frameImg
                }
            })

        case .audio:
            print_debug("Audio")
        case .unknown:
            print_debug("Unknown")
        }

        return cell
    }
}

extension GalleryImagePickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let asset = assets[indexPath.item]
        //let imageSize = CGSize(width: 320, height: 240) //.zero

        let options = PHImageRequestOptions()
        options.resizeMode = .none
        //options.deliveryMode = .fastFormat

        cachingManager?.requestImageData(for: asset, options: options, resultHandler: { (imageData, dataUTI, orientation, info) in

            if let d = self.delegate, let imgData = imageData {
                let optionalImage = UIImage(data: imgData)
                d.imageView(finishWithAgree: true, andImage: optionalImage)
                self.delegate = nil
            }
        })

        /*
         cachingManager?.requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: options, resultHandler: { (optionalImage, _) in
         DispatchQueue.main.async {
         self.delegate?.imageView(finishWithAgree: true, andImage: optionalImage)
         self.delegate = nil
         }
         })
         */
    }
}

extension GalleryImagePickerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.frame.height
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero //UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension GalleryImagePickerViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let asset = assets[indexPath.item]

            switch asset.mediaType {
            case .image:
                print_debug("Image")
                cachingManager?.requestImage(for: asset, targetSize: targetImageSize, contentMode: imageContentMode, options: nil, resultHandler: { (_, _) in })

            case .video:
                print_debug("Video")
                cachingManager?.requestAVAsset(forVideo: asset, options: nil, resultHandler: { (_, _, _) in })

            case .audio:
                print_debug("Audio")
            case .unknown:
                print_debug("Unknown")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let fetchingAssetId = currentRequestingAssetIds[indexPath] {
                cachingManager?.cancelImageRequest(fetchingAssetId)
            }
        }
    }
}

class ImageCollectionCell: UICollectionViewCell {

    lazy var imageView = UIImageView()
    lazy var videoImageView = UIImageView(image: #imageLiteral(resourceName: "ic53VideosOpt1V1PlayVideo"))

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        videoImageView.center = imageView.center
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    private func commonInit() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        contentView.addSubview(videoImageView)
    }
}

class FetchPhoto {

    class func assetCollection<T : PHObject>(result : PHFetchResult<T>) -> [T] {

        let list = SynchronizedArray<T>()

        result.enumerateObjects(options: NSEnumerationOptions.concurrent) { (object, _, _) in
            list.append(object)
        }

        return list.value
    }
}
