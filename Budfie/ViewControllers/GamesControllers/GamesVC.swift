//
//  GamesVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 03/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import GCDWebServer
import SSZipArchive
import WebKit

class GamesVC: BaseVc {

    // MARK: Private Properties
    private let webServer = GCDWebServer()
    private lazy var webView = WKWebView()

    // MARK: IBOutlets
    @IBOutlet weak var loadingProgressBar: UIProgressView!
    @IBOutlet weak var backBtn: UIButton!

    // MARK: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn.round()
        backBtn.backgroundColor = AppColors.themeBlueColor
        loadingProgressBar.tintColor = AppColors.themeBlueColor

        /*
         let jscript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, viewport-fit=cover, shrink-to-fit=no');document.getElementsByTagName('head')[0].appendChild(meta);"
         let userScript = WKUserScript(source: jscript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
         let wkUController = WKUserContentController()
         wkUController.addUserScript(userScript)
         let wkWebConfig = WKWebViewConfiguration()
         wkWebConfig.userContentController = wkUController
         webView = WKWebView(frame: .zero, configuration: wkWebConfig)
         */

//        if #available(iOS 11.0, *) {
//            let previousInsets = webView.safeAreaInsets
//            webView.safeAreaInsets = UIEdgeInsets(top: previousInsets.top,
//                                                  left: (previousInsets.left + 10),
//                                                  bottom: previousInsets.bottom,
//                                                  right: (previousInsets.right + 10))
//        }

        webServer.delegate = self
        webView.scrollView.delegate = self
        addWebViewConstraint()

        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        // Unzip
        if let zipPath = Bundle.main.path(forResource: "winfie", ofType: "zip") {

            // let zipFileUrl = URL(fileURLWithPath: zipPath)
            let supportDirectories = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)

            if let unzipPath = supportDirectories.first {
                let modifiedPath = unzipPath.appending("games")

                webServer.addGETHandler(forBasePath: "/games/", directoryPath: modifiedPath, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)

                SSZipArchive.unzipFile(atPath: zipPath, toDestination: modifiedPath, overwrite: false, password: nil, progressHandler: { [weak self] (strPath, fileInfo, currentFileNumber, number_entry) in

                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.loadingProgressBar.progress = Float(currentFileNumber/number_entry)

                }, completionHandler: { [weak self] (path, success, unzippingError) in

                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.loadingProgressBar.progress = 1
                    strongSelf.hideLoadingProgressBar()
                    strongSelf.webServer.start()
                })
            }
        }
    }

    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

     webServer.start()
     }
     */

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webServer.stop()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    deinit {
        webServer.delegate = nil
        webView.scrollView.delegate = nil
    }

    // MARK: Private Methods
    private func addWebViewConstraint() {

        view.insertSubview(webView, at: 0)
        webView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            let topAnchorConstraint = webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            let bottomAnchorConstraint = webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            let leadingAnchorConstraint = webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailingAnchorConstraint = webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            let allConstraint = [topAnchorConstraint, bottomAnchorConstraint, leadingAnchorConstraint, trailingAnchorConstraint]
            NSLayoutConstraint.activate(allConstraint)

        } else {
            let topAnchorConstraint = webView.topAnchor.constraint(equalTo: view.topAnchor)
            let bottomAnchorConstraint = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let leadingAnchorConstraint = webView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailingAnchorConstraint = webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let allConstraint = [topAnchorConstraint, bottomAnchorConstraint, leadingAnchorConstraint, trailingAnchorConstraint]
            NSLayoutConstraint.activate(allConstraint)
        }
    }

    private func hideLoadingProgressBar() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingProgressBar.alpha = 0
        }, completion: { _ in
            self.loadingProgressBar.isHidden = true
            self.loadingProgressBar.removeFromSuperview()
        })
    }

    // MARK: IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        pop()
    }
}

// MARK: GCD WebServer Delegate Methods
extension GamesVC: GCDWebServerDelegate {

    func webServerDidStart(_ server: GCDWebServer) {

    }

    func webServerDidCompleteBonjourRegistration(_ server: GCDWebServer) {
        if let serverURL = server.bonjourServerURL {
            let gamesURLString = serverURL.absoluteString.appending("games/winfie/index.html")
            if let gamesURL = URL(string: gamesURLString) {
                let request = URLRequest(url: gamesURL)
                webView.load(request)
            }
        }
    }

    func webServerDidUpdateNATPortMapping(_ server: GCDWebServer) {

    }

    func webServerDidConnect(_ server: GCDWebServer) {

    }

    func webServerDidDisconnect(_ server: GCDWebServer) {

    }

    func webServerDidStop(_ server: GCDWebServer) {

    }
}

// MARK: ScrollView Delegate Methods
extension GamesVC: UIScrollViewDelegate {

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
