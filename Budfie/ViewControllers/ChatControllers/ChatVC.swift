//
//  ChatVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import AVFoundation
import FreeStreamer
import IQKeyboardManagerSwift
import SwiftyJSON

class ChatVC: BaseVc {

    // MARK: Enums
    private enum KeyboardType {
        case text
        case emoji
        case sticker
    }

    // MARK: Public Properties
    var chatRoomInfo: ChatRoomInfo!
    var chatMembers = [ChatMember]()
    var senderId: String?
    var eventId: String?
    private var myChatColor = AppColors.sentMessageColor.hexString

    // MARK: Private Properties
    private var chatMessages: [ChatMessage] = []
    private var chat: Chat = .none
    private var keyboardType: KeyboardType = .text
    fileprivate var safeAreaBottomInset: CGFloat = 0
    fileprivate var isMemberRemoved = false

    fileprivate lazy var refreshControl = UIRefreshControl()
    fileprivate var stickerInputView: StickerInputView!

    fileprivate lazy var audioPlayer = FSAudioStream()
    fileprivate var isPlayingAudioMessage = false
    fileprivate var playedAudioMessageId: String?
    fileprivate var playedAudioMessageProgress: Float = 0
    fileprivate var audioProgressTrackingTimer: Timer?

    // MARK: IBOutlets
    @IBOutlet weak var chatMessageTableView: UITableView!
    @IBOutlet weak var chatBackgroundImageView: UIImageView!
    @IBOutlet weak var chooseChatBackgroundImageBtn: UIButton!

    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatImageContainerView: UIView!

    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottom: NSLayoutConstraint!

    @IBOutlet weak var optionContainerView: UIView!
    @IBOutlet weak var optionContainerStackView: UIStackView!
    @IBOutlet weak var optionContainerViewBottom: NSLayoutConstraint!

    @IBOutlet weak var emojiBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!

    @IBOutlet weak var innerEmojiBtn: UIButton!
    @IBOutlet weak var innerStickerBtn: UIButton!
    @IBOutlet weak var innerCameraBtn: UIButton!
    @IBOutlet weak var innerAudioBtn: UIButton!

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var moreOptionBtn: UIButton!

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var textView: IQTextView!

    @IBOutlet weak var blockedLbl: UILabel!

    // MARK: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        stickerInputView = Bundle.loadView(fromNib: "\(StickerInputView.self)", withType: StickerInputView.self)
        if screenHeight > 800 {
            stickerInputView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 291)
        } else {
            stickerInputView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 216)
        }
        stickerInputView.delegate = self
        stickerInputView.autoresizingMask = [.flexibleWidth]

        status.backgroundColor = AppColors.themeBlueColor
        navigationView.backgroundColor = UIColor.clear
        chatImageView.round()

        chatMessageTableView.addSubview(refreshControl)
        chatMessageTableView.dataSource = self
        chatMessageTableView.delegate = self
        chatMessageTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)

        registerNibs()
        addBtnTargets()
        addTapGestures()

        textView.delegate = self
        refreshControl.addTarget(self, action: #selector(getOldMessages), for: .valueChanged)

        if !chatMembers.isEmpty {
            navigationTitle.text = chatRoomInfo?.chatTitle

            if chatMembers.count == 1 {
                chatRoomInfo.chatType = .single
                checkIfChatRoomExists(for: chatMembers[0])

            } else {
                chat = .new
                chatRoomInfo.chatType = .group
                sendGroupCreationMessage()
            }

        } else {
            chat = .existing
            setupChat()
        }

        optionContainerView.alpha = 0
        optionContainerStackView.alpha = 0
        optionContainerViewBottom.constant = -50

        borderView.layer.cornerRadius = textView.height/2
        borderView.border(width: 0.8, borderColor: .gray)

        containerView.addShadow(ofColor: .gray, radius: 3, offset: .zero, opacity: 0.5)
        containerView.layer.masksToBounds = false

        optionContainerView.addShadow(ofColor: .gray, radius: 3, offset: .zero, opacity: 0.5)
        optionContainerView.layer.masksToBounds = false

        sendBtn.isHidden = true
        moreOptionBtn.isHidden = true

        audioPlayer.strictContentTypeChecking = false
    }

    private func addTapGestures() {

        let chatImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(chatImageTapped))
        chatImageTapGesture.cancelsTouchesInView = false
        chatImageContainerView.addGestureRecognizer(chatImageTapGesture)

        let tableBackgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(tableBackgroundTapped))
        tableBackgroundTapGesture.cancelsTouchesInView = false
        chatMessageTableView.addGestureRecognizer(tableBackgroundTapGesture)

        let textViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        textViewTapGesture.cancelsTouchesInView = false
        textView.addGestureRecognizer(textViewTapGesture)
    }

    private func addBtnTargets() {

        emojiBtn.addTarget(self, action: #selector(emojiBtnTapped), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(stickerBtnTapped), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        audioBtn.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)

        innerEmojiBtn.addTarget(self, action: #selector(emojiBtnTapped), for: .touchUpInside)
        innerStickerBtn.addTarget(self, action: #selector(stickerBtnTapped), for: .touchUpInside)
        innerCameraBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        innerAudioBtn.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)

        sendBtn.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
        moreOptionBtn.addTarget(self, action: #selector(moreOptionBtnTapped), for: .touchUpInside)
    }

    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            safeAreaBottomInset = view.safeAreaInsets.bottom

            if screenHeight > 800 {
                stickerInputView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (291 + safeAreaBottomInset))
            } else {
                stickerInputView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (216 + safeAreaBottomInset))
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        optionContainerView.alpha = 1
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
        audioPlayer.stop()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.resignFirstResponder()
    }

    // MARK: Private Methods
    private func registerNibs() {
        var nibName = ChatHeaderTableCell.defaultReuseIdentifier
        var nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = ReceivedChatMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = SentChatMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = SentImageVideoMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = ReceivedImageVideoMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = SentVoiceMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)

        nibName = ReceivedVoiceMessageCell.defaultReuseIdentifier
        nib = UINib(nibName: nibName, bundle: nil)
        chatMessageTableView.register(nib, forCellReuseIdentifier: nibName)
    }

    private func setupChat() {
        observeRoomInfo()
        observeChatColor()
        observerChatMessages()
        observerBlockStatus()

        let chatBackgroundInfo = AppUserDefaults.value(forKey: .chatBackgroundInfo)
        let roomInfo = chatRoomInfo.roomId
        if let imgStr = chatBackgroundInfo[roomInfo].string {
            chatBackgroundImageView.image = UIImage(named: imgStr)
        }
    }

    private func observerBlockStatus() {
        DatabaseReference.child(DatabaseNode.Root.userBlockStatus.rawValue).child(chatRoomInfo.roomId).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.blockedLbl.isHidden = !snapshot.exists()
            strongSelf.containerView.isUserInteractionEnabled = !snapshot.exists()
        }
    }

    @objc private func textViewTapped(_ gesture: UITapGestureRecognizer) {
        if keyboardType != .text {
            setNormalKeyboard()
        }
        textView.becomeFirstResponder()
    }

    @objc private func chatImageTapped(_ gesture: UITapGestureRecognizer) {
        hideOptions()
        switch chatRoomInfo.chatType {
        case .none:
            break
        case .single:
            if let id = senderId {
                moveToOtherUserProfile(id)
            }
        case .group:
            moveToGroupInfo()
        }
    }

    private func moveToOtherUserProfile(_ friendId: String) {
        let profileScene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        profileScene.state = .otherProfile
        profileScene.friendId = friendId
        navigationController?.pushViewController(profileScene, animated: true)
    }

    private func moveToGroupInfo() {
        let createNewGroupScene = CreateNewGroupVC.instantiate(fromAppStoryboard: .Chat)
        createNewGroupScene.type = CreateNewGroupVC.VCType.groupDetail(chatRoomInfo)
        navigationController?.pushViewController(createNewGroupScene, animated: true)
    }

    @objc private func tableBackgroundTapped() {
        textView.resignFirstResponder()
        hideOptions()
    }

    @objc private func emojiBtnTapped() {
        hideOptions()
        showStickerInputView(type: .emoji)
    }

    private func setNormalKeyboard() {
        keyboardType = .text
        //emojiBtn.setImage(#imageLiteral(resourceName: "icChatSmiley1"), for: .normal)
        textView.inputView = nil
        textView.reloadInputViews()
    }

    @objc private func stickerBtnTapped(_ sender: UIButton) {
        hideOptions()
        showStickerInputView(type: .sticker)
    }

    private func showStickerInputView(type: KeyboardType) {
        keyboardType = type
        switch type {
        case .emoji:
            stickerInputView.type = .emoji
        case .sticker:
            stickerInputView.type = .sticker
        case .text:
            break
        }
        stickerInputView.stickerCollectionView.reloadData()
        textView.inputView = stickerInputView
        textView.reloadInputViews()
        textView.becomeFirstResponder()
    }

    @objc private func cameraBtnTapped(_ sender: UIButton) {
        /*
         #if !DEBUG
         CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
         return
         #endif
         */
        
        hideOptions()

        let vc = SNVideoRecorderViewController()
        vc.delegate = self

        // flashlight icons
        vc.flashLightOnIcon = UIImage(named: "flash_light_50")
        vc.flashLightOffIcon = UIImage(named: "flash_light_off_50")

        // switch camera icon
        vc.switchCameraOption.setImage(UIImage(named: "switch_camera_50")?.withRenderingMode(.alwaysTemplate), for: .normal)

        // close options
        vc.closeOption.isHidden = false
        vc.closeOption.setImage(UIImage(named: "delete_50")?.withRenderingMode(.alwaysTemplate), for: .normal)

        // preview text
        vc.agreeText = "OK"
        vc.discardText = "Discard"

        // max seconds able to record
        vc.maxSecondsToRecord = 30

        // start camera position
        vc.initCameraPosition = .back

        // show up
        present(vc, animated: true, completion: nil)
    }

    // Method to check and create room if room does not exists
    private func checkAndCreateRoom() {
        switch chat {
        case .new:
            createChat()
        case .existing, .none:
            break
        }
    }

    private func sendGroupCreationMessage() {
        hideOptions()
        checkAndCreateRoom()

        let name: String
        if AppDelegate.shared.currentuser.last_name.isEmpty {
            name = AppDelegate.shared.currentuser.first_name
        } else {
            name = "\(AppDelegate.shared.currentuser.first_name) \(AppDelegate.shared.currentuser.last_name)"
        }

        if let chatMessage = ChatHelper.composeHeaderMessage(message: "\(name) created group \(chatRoomInfo.chatTitle)", roomId: chatRoomInfo.roomId) {
            sendMessage(chatMessage)
            setInbox()
        }
    }

    @objc private func sendBtnTapped(_ sender: UIButton) {
        hideOptions()
        checkAndCreateRoom()

        guard let chatText = textView.text,
            !chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let chatMessage = ChatHelper.composeTextMessage(chatText, chatRoomInfo.roomId, false) else {
                return
        }

        sendMessage(chatMessage)
        setInbox()

        textView.text = nil
        textViewDidChange(textView)
    }

    private func setInbox() {
        let roomId = chatRoomInfo.roomId

        switch chatRoomInfo.chatType {
        case .none:
            break

        case .single:
            if let friendId = senderId {
                let userId = AppDelegate.shared.currentuser.user_id
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).setValue(roomId)
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(friendId).child(userId).setValue(roomId)
            }

        case .group:
            for userUpdate in chatRoomInfo.lastUpdates {
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userUpdate.id).child(roomId).setValue(roomId)
            }
        }
    }

    @objc private func audioBtnTapped(_ sender: UIButton) {
        /*
         #if !DEBUG
         CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
         return
         #endif
         */
        
        hideOptions()
        checkForMicrophonePermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.showRecordView()
                } else {
                    self.showMicrophonePermissonRequestAlert()
                }
            }
        }
    }

    private func checkForMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission(completion)
        }
    }

    private func showRecordView() {
        let recordVoiceScene = RecordVoiceVC.instantiate(fromAppStoryboard: .Chat)
        recordVoiceScene.modalPresentationStyle = .overCurrentContext
        recordVoiceScene.delegate = self
        present(recordVoiceScene, animated: false, completion: nil)
    }

    private func showMicrophonePermissonRequestAlert() {
        let title = "Microphone Access Denied"
        let message = "Please enable microphone access in your privacy settings";
        CommonClass.showPermissionAlert(title: title, message: message)
    }

    @objc private func moreOptionBtnTapped(_ sender: UIButton) {
        guard optionContainerViewBottom.constant != 0 else {
            hideOptions()
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.optionContainerStackView.alpha = 1
            self.optionContainerViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    fileprivate func hideOptions() {
        guard optionContainerViewBottom.constant != -50 else {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.optionContainerStackView.alpha = 0
            self.optionContainerViewBottom.constant = -50
            self.view.layoutIfNeeded()
        }
    }

    @objc func getOldMessages() {

        guard let oldestMessage = chatMessages.first else {
            return
        }
        let roomId = chatRoomInfo.roomId
        let lastKey = oldestMessage.messageId

        FirebaseHelper.getPaginatedData(roomId, lastKey, 0, { [weak self] (messages) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshControl.endRefreshing()

            if messages.isEmpty || messages.count < 25 {
                strongSelf.refreshControl.removeFromSuperview()
            }

            strongSelf.chatMessages.append(contentsOf: messages)
            //strongSelf.chatMessages.removeDuplicates()

            strongSelf.chatMessages.sort(by: { (msg1, msg2) -> Bool in
                return msg1.timeStamp < msg2.timeStamp
            })

            DispatchQueue.main.async {
                strongSelf.chatMessageTableView.reloadData()
            }
        })
    }

    private func checkIfChatRoomExists(for member: ChatMember) {

        let friendId = member.userId
        senderId = friendId

        guard !friendId.isEmpty else {
            return
        }
        let userId = AppDelegate.shared.currentuser.user_id

        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }

            if let roomId = snapshot.value as? String {
                strongSelf.chat = .existing
                strongSelf.chatRoomInfo.roomId = roomId
                strongSelf.setupChat()

            } else {

                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(friendId).child(userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

                    guard let strongSelf = self else {
                        return
                    }

                    if let roomId = snapshot.value as? String {
                        strongSelf.chat = .existing
                        strongSelf.chatRoomInfo.roomId = roomId
                        strongSelf.setupChat()

                    } else {
                        strongSelf.chat = .new
                        strongSelf.getSenderDetails()
                    }
                }
            }
        }
    }

    private func createChat() {
        chatRoomInfo.roomId = FirebaseHelper.startNewChat(chatMembers, info: chatRoomInfo)
        chat = .existing
        setupChat()
    }

    private func observeRoomInfo() {

        let roomId = chatRoomInfo.roomId
        if let eId = eventId {
            DatabaseReference.child(DatabaseNode.Root.event.rawValue).child(eId).setValue(roomId)
        }

        FirebaseHelper.getRoomInfo(roomId) { [weak self] roomInfo in
            guard let strongSelf = self else {
                return
            }
            let roomId = strongSelf.chatRoomInfo.roomId
            roomInfo.roomId = roomId

            strongSelf.chatRoomInfo = roomInfo

            switch strongSelf.chatRoomInfo.chatType {
            case .single:
                strongSelf.getSenderDetails()
            case .group:
                strongSelf.navigationTitle.text = roomInfo.chatTitle
                strongSelf.chatImageView.setImage(withSDWeb: roomInfo.chatPic, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
            case .none:
                break
            }
            strongSelf.observeRemovedStatus(room: roomInfo)
        }
    }

    private func observeRemovedStatus(room: ChatRoomInfo) {
        guard let user = AppDelegate.shared.currentuser else {
            return
        }

        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(room.roomId).child(user.user_id).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value as? JSONDictionary else {
                    return
            }
            let json = JSON(value)

            let memberJoin = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
            let memberLeave = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue

            if memberJoin < memberLeave {
                strongSelf.blockedLbl.text = "You are not a member of this group anymore"
                strongSelf.blockedLbl.isHidden = !snapshot.exists()
                strongSelf.containerView.isUserInteractionEnabled = !snapshot.exists()
            }
        }
    }

    private func observeChatColor() {
        let userId = AppDelegate.shared.currentuser.user_id
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(chatRoomInfo.roomId).child(userId).child(DatabaseNode.Rooms.memberColor.rawValue).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.myChatColor = snapshot.value as? String
        }
    }

    func getSenderDetails() {

        guard let id = senderId,
            !id.isEmpty else {
                return
        }

        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(id).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }

            var name = ""
            let json = JSON(value)
            let imgString = json[DatabaseNode.Users.profilePic.rawValue].string

            if let firstName = json[DatabaseNode.Users.firstName.rawValue].string {
                name = firstName
            }

            if let lastName = json[DatabaseNode.Users.lastName.rawValue].string {
                name.append(" \(lastName)")
            }

            strongSelf.navigationTitle.text = name
            strongSelf.chatImageView.setImage(withSDWeb: imgString, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
        }
    }

    private func observerChatMessages() {

        guard !chatRoomInfo.roomId.isEmpty else {
            return
        }

        let userId = AppDelegate.shared.currentuser.user_id
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(chatRoomInfo.roomId).child(userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            let json = JSON(value)

            let memberJoin = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
            let memberLeave = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue
            let chatDelete = json[DatabaseNode.Rooms.memberDelete.rawValue].doubleValue

            strongSelf.isMemberRemoved = (memberJoin < memberLeave)
            strongSelf.observeMessageAfterDeleteEvent(at: chatDelete)
        }
    }

    private func observeMessageAfterDeleteEvent(at value: TimeInterval) {

        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(chatRoomInfo.roomId).queryOrdered(byChild: DatabaseNode.Messages.timestamp.rawValue).queryStarting(atValue: value).queryLimited(toLast: 25).observe(.childAdded, with: { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }

            print_debug(value)

            let json = JSON(value)
            let msg = ChatMessage(with: json)

            FirebaseHelper.setMessageInfoStatus(msg, status: .read)
            strongSelf.observeMessageStatus(msg, of: strongSelf.chatRoomInfo.roomId)

            let indexPathToInsert = IndexPath(row: strongSelf.chatMessages.count, section: 0)
            strongSelf.chatMessages.append(msg)
            strongSelf.chatMessageTableView.insertRows(at: [indexPathToInsert], with: .fade)

            NSObject.cancelPreviousPerformRequests(withTarget: strongSelf)
            strongSelf.perform(#selector(strongSelf.scrollToBottom), with: nil, afterDelay: 0.2)
        })
    }

    @objc private func scrollToBottom() {
        let messageCount = chatMessages.count
        guard messageCount > 0 else {
            return
        }
        let lastMessageIndexPath = IndexPath(row: (messageCount - 1), section: 0)
        chatMessageTableView.scrollToRow(at: lastMessageIndexPath, at: .bottom, animated: true)
    }

    private func observeMessageStatus(_ message: ChatMessage, of roomId: String) {

        guard !message.messageId.isEmpty,
            !roomId.isEmpty else {
                return
        }

        DatabaseReference.child(DatabaseNode.Root.messageInfo.rawValue).child(message.messageId).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let statusDict = snapshot.value as? JSONDictionary else {
                    return
            }

            let sentCount = statusDict.count
            var deliveredCount = 0
            var readCount = 0

            for (_, value) in statusDict {

                guard let intValue = value as? Int,
                    let status = DeliveryStatus(rawValue: intValue) else {
                        continue
                }

                switch status {
                case .sent:
                    break
                case .delivered:
                    deliveredCount += 1
                case .read:
                    readCount += 1
                }
            }

            if readCount >= sentCount {
                strongSelf.refreshMessage(message)
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .read)
            } else if deliveredCount >= sentCount {
                strongSelf.refreshMessage(message)
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .delivered)
            }
        }
    }

    private func refreshMessage(_ message: ChatMessage) {
        if let index = chatMessages.index(of: message) {
            let indexPath = IndexPath(row: index, section: 0)
            chatMessageTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func refreshMessage(with id: String?) {
        guard let unwrappedId = id else {
            return
        }
        if let index = chatMessages.index(where: { (iteratedMessage) -> Bool in
            return (iteratedMessage.messageId == unwrappedId)
        }) {
            let indexPath = IndexPath(row: index, section: 0)
            chatMessageTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func updateAudioMessageProgress(with id: String?, progress: Float, isPlaying: Bool) {

        guard let unwrappedId = id else {
            return
        }

        if let index = chatMessages.index(where: { (iteratedMessage) -> Bool in
            return (iteratedMessage.messageId == unwrappedId)

        }) {
            let indexPath = IndexPath(row: index, section: 0)

            if let cell = chatMessageTableView.cellForRow(at: indexPath) as? SentVoiceMessageCell {
                cell.updateAudioPlayer(progress, isPlaying)
            } else if let cell = chatMessageTableView.cellForRow(at: indexPath) as? ReceivedVoiceMessageCell {
                cell.updateAudioPlayer(progress, isPlaying)
            }
        }
    }

    // MARK: IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if !popToController(EditEventVC.self, animated: true) {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func changeBackgroundBtnTapped(_ sender: UIButton) {
        hideOptions()
        let chooseChatBackgroundScene = ChooseChatBackgroundVC.instantiate(fromAppStoryboard: .Chat)
        chooseChatBackgroundScene.modalPresentationStyle = .overCurrentContext
        chooseChatBackgroundScene.delegate = self
        chooseChatBackgroundScene.roomInfo = chatRoomInfo.roomId
        present(chooseChatBackgroundScene, animated: false, completion: nil)
    }
}

// MARK: SNVideoRecorder Delegate Methods
extension ChatVC: ChatBackgroundDelegate {

    func didChooseChatBackground(_ name: String) {
        chatBackgroundImageView.image = UIImage(named: name)
        let roomId = chatRoomInfo.roomId
        let chatBackgroundInfo = AppUserDefaults.value(forKey: .chatBackgroundInfo)
        guard !roomId.isEmpty else {
            return
        }
        var chatBackgroundInfoDict = JSONDictionary()
        if let dict = chatBackgroundInfo.dictionaryObject {
            chatBackgroundInfoDict = dict
        }
        chatBackgroundInfoDict[roomId] = name
        AppUserDefaults.save(value: chatBackgroundInfoDict, forKey: .chatBackgroundInfo)
    }
}

// MARK: SNVideoRecorder Delegate Methods
extension ChatVC: SNVideoRecorderDelegate {

    func videoRecorder(withImage image: UIImage) {

        //let roomId = chatRoomInfo.roomId
        AppNetworking.showLoader()

        image.uploadImageToS3(success: { [weak self] (success, url) in
            AppNetworking.hideLoader()

            guard let strongSelf = self else {
                return
            }
            strongSelf.checkAndCreateRoom()

            guard let message = ChatHelper.composeStickerMessage(type: .image, url, strongSelf.chatRoomInfo.roomId, false, nil) else {
                return
            }
            strongSelf.sendMessage(message)

        }, progress: { _ in

        }, failure: { error in
            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    func videoRecorder(withVideo url: URL) {
        AppNetworking.showLoader()

        guard let thumbnail = getVideoThumbnail(from: url) else {
            AppNetworking.hideLoader()
            return
        }

        thumbnail.uploadImageToS3(success: { [weak self] (success, thumbnailUrl) in

            guard let strongSelf = self else {
                AppNetworking.hideLoader()
                return
            }
            strongSelf.uploadVideo(with: url, thumbnail: thumbnailUrl)

            }, progress: { _ in

        }, failure: { error in
            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func getVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)

        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print_debug(error.localizedDescription)
            return nil
        }
    }

    private func uploadVideo(with url: URL, thumbnail: String) {

        /*
         let roomId = chatRoomInfo.roomId
         let lastUpdates = chatRoomInfo.lastUpdates
         let members = chatMembers
         */

        url.uploadToS3(success: { [weak self] (success, url) in
            AppNetworking.hideLoader()

            guard let strongSelf = self else {
                return
            }
            strongSelf.checkAndCreateRoom()

            guard let message = ChatHelper.composeVideoMessage(url, thumbnail: thumbnail, strongSelf.chatRoomInfo.roomId, false, nil) else {
                return
            }
            strongSelf.sendMessage(message)

        }, progress: { _ in

        }, failure: { error in
            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
}

// MARK: Keyboard handling methods
extension ChatVC {

    // MARK: - Register / Unregister Observers

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillChangeFrame, object: nil)
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
    }

    @objc private func keyboardNotification(_ notification: Notification) {

        guard let userInfo = notification.userInfo else {
            return
        }

        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)

        if (endFrame?.origin.y)! >= screenHeight {
            containerViewBottom?.constant = 0.0
        } else {
            containerViewBottom?.constant = ((endFrame?.size.height ?? 0.0) - safeAreaBottomInset)
        }

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: { _ in self.scrollToBottom() })
    }
}

// MARK: TableView DataSource Methods
extension ChatVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = chatMessages[indexPath.row]
        if message.senderId == AppDelegate.shared.currentuser.user_id {

            switch message.type {

            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatHeaderTableCell.defaultReuseIdentifier, for: indexPath) as? ChatHeaderTableCell else {
                    fatalError("ChatHeaderTableCell not found")
                }

                cell.populate(with: message)
                return cell

            case .image, .video, .sticker, .emoji:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SentImageVideoMessageCell.defaultReuseIdentifier, for: indexPath) as? SentImageVideoMessageCell else {
                    fatalError("SentImageVideoMessageCell not found")
                }

                let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
                cell.msgImageView.isUserInteractionEnabled = true
                cell.msgImageView.addGestureRecognizer(imageViewTapGesture)

                cell.populate(with: message)
                return cell

            case .audio:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SentVoiceMessageCell.defaultReuseIdentifier, for: indexPath) as? SentVoiceMessageCell else {
                    fatalError("SentVoiceMessageCell not found")
                }

                let seekPanGesture = UIPanGestureRecognizer(target: self, action: #selector(audioMessageSeeked))
                seekPanGesture.delegate = self
                cell.audioThumbHandleView.addGestureRecognizer(seekPanGesture)

                cell.populate(with: message, playedMessageId: playedAudioMessageId, progress: playedAudioMessageProgress, isPlaying: isPlayingAudioMessage)
                cell.audioPlayPauseBtn.addTarget(self, action: #selector(playAudioMessageBtnTapped), for: .touchUpInside)
                return cell

            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SentChatMessageCell.defaultReuseIdentifier, for: indexPath) as? SentChatMessageCell else {
                    fatalError("SentChatMessageCell not found")
                }

                cell.populate(with: message)
                return cell
            }
        }

        switch message.type {

        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatHeaderTableCell.defaultReuseIdentifier, for: indexPath) as? ChatHeaderTableCell else {
                fatalError("ChatHeaderTableCell not found")
            }

            cell.populate(with: message)
            return cell

        case .image, .video, .sticker, .emoji:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedImageVideoMessageCell.defaultReuseIdentifier, for: indexPath) as? ReceivedImageVideoMessageCell else {
                fatalError("ReceivedImageVideoMessageCell not found")
            }

            let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            cell.msgImageView.isUserInteractionEnabled = true
            cell.msgImageView.addGestureRecognizer(imageViewTapGesture)

            cell.populate(with: message, chatType: chatRoomInfo.chatType)
            return cell

        case .audio:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedVoiceMessageCell.defaultReuseIdentifier, for: indexPath) as? ReceivedVoiceMessageCell else {
                fatalError("ReceivedVoiceMessageCell not found")
            }

            let seekPanGesture = UIPanGestureRecognizer(target: self, action: #selector(audioMessageSeeked))
            seekPanGesture.delegate = self
            cell.audioThumbHandleView.addGestureRecognizer(seekPanGesture)

            cell.populate(with: message, playedMessageId: playedAudioMessageId, progress: playedAudioMessageProgress, isPlaying: isPlayingAudioMessage, chatType: chatRoomInfo.chatType)
            cell.audioPlayPauseBtn.addTarget(self, action: #selector(playAudioMessageBtnTapped), for: .touchUpInside)
            return cell

        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedChatMessageCell.defaultReuseIdentifier, for: indexPath) as? ReceivedChatMessageCell else {
                fatalError("ReceivedChatMessageCell not found")
            }

            cell.populate(with: message, chatType: chatRoomInfo.chatType)
            return cell
        }
    }

    @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {

        guard let imageView = gesture.view as? UIImageView,
            let indexPath = imageView.tableViewIndexPath(chatMessageTableView) else {
                return
        }

        guard let image = imageView.image else {
            CommonClass.showToast(msg: "Loading image...")
            return
        }

        let message = chatMessages[indexPath.row]

        switch message.type {
        case .image, .sticker:
            let chatImagePreviewScene = ChatImagePreviewVC.instantiate(fromAppStoryboard: .Chat)
            chatImagePreviewScene.image = image
            if message.type == .sticker {
                chatImagePreviewScene.sticker = message.mediaUrl
            }
            chatImagePreviewScene.modalPresentationStyle = .overCurrentContext
            present(chatImagePreviewScene, animated: true, completion: nil)

        case .video:
            let trailerPlayerScene = TrailersPlayerVC.instantiate(fromAppStoryboard: .Events)
            trailerPlayerScene.url = message.mediaUrl
            present(trailerPlayerScene, animated: false, completion: nil)

        default:
            break
        }
    }

    @objc private func playAudioMessageBtnTapped(_ sender: UIButton) {

        guard let indexPath = sender.tableViewIndexPath(chatMessageTableView) else {
            return
        }

        let message = chatMessages[indexPath.row]
        let prevPlayedMessageId = playedAudioMessageId
        playedAudioMessageId = message.messageId

        if message.messageId == prevPlayedMessageId {
            audioPlayer.pause()

        } else {
            audioPlayer.stop()
            playedAudioMessageProgress = 0
            isPlayingAudioMessage = false
            updateAudioMessageProgress(with: prevPlayedMessageId, progress: 0, isPlaying: false)

            if let audioUrl = URL(string: message.mediaUrl) {
                audioPlayer.play(from: audioUrl)
                isPlayingAudioMessage = true
            }
        }

        audioPlayer.onStateChange = { [weak self] state in

            guard let strongSelf = self else {
                return
            }

            switch state {
            case .fsAudioStreamPlaying:
                strongSelf.isPlayingAudioMessage = true
                strongSelf.setupAudioProgressTrackingTimer()

            case .fsAudioStreamStopped, .fsAudioStreamPaused,
                 .fsAudioStreamPlaybackCompleted, .fsAudioStreamFailed:
                strongSelf.isPlayingAudioMessage = false
                strongSelf.stopAudioProgressTrackingTimer()

            default:
                break
            }
            strongSelf.refreshPlayedAudioMessage()
        }

        audioPlayer.onCompletion = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.stopAudioProgressTrackingTimer()
            strongSelf.refreshPlayedAudioMessage()
            strongSelf.isPlayingAudioMessage = false
            strongSelf.playedAudioMessageId = nil
        }
    }

    private func setupAudioProgressTrackingTimer() {
        stopAudioProgressTrackingTimer()
        audioProgressTrackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshPlayedAudioMessage), userInfo: nil, repeats: true)
    }

    private func stopAudioProgressTrackingTimer() {
        audioProgressTrackingTimer?.invalidate()
        audioProgressTrackingTimer = nil
    }

    @objc private func refreshPlayedAudioMessage() {

        let playbackTime = audioPlayer.currentTimePlayed.playbackTimeInSeconds
        let duration = audioPlayer.duration.playbackTimeInSeconds
        playedAudioMessageProgress = playbackTime/duration

        print_debug("playbackTime: \(playbackTime), duration: \(duration), playedAudioMessageProgress: \(playedAudioMessageProgress)")

        updateAudioMessageProgress(with: playedAudioMessageId, progress: playedAudioMessageProgress, isPlaying: isPlayingAudioMessage)
    }

    @objc private func audioMessageSeeked(_ gesture: UIPanGestureRecognizer) {

        guard let seekThumbnailView = gesture.view,
            let indexPath = seekThumbnailView.tableViewIndexPath(chatMessageTableView) else {
                return
        }
        let message = chatMessages[indexPath.row]

        let seekView: UIView
        let seekedWidthConstraint: NSLayoutConstraint

        if let cell = seekThumbnailView.getTableViewCell as? ReceivedVoiceMessageCell {
            seekView                = cell.audioLengthIndicatorView
            seekedWidthConstraint   = cell.playedAudioLengthIndicatorViewWidth
        } else if let cell = seekThumbnailView.getTableViewCell as? SentVoiceMessageCell {
            seekView                = cell.audioLengthIndicatorView
            seekedWidthConstraint   = cell.playedAudioLengthIndicatorViewWidth
        } else {
            return
        }

        switch gesture.state {
        case .began:
            break

        case .changed:
            let translation = gesture.translation(in: seekView)
            seekedWidthConstraint.constant = max(0, min(133, (133 * translation.x)))

        case .ended:
            let minute = UInt32(message.duration / 60)
            let second = UInt32(message.duration.truncatingRemainder(dividingBy: 60))
            let position = Float(seekedWidthConstraint.constant / 133)
            let streamPosition = FSStreamPosition(minute: minute, second: second, playbackTimeInSeconds: message.duration, position: position)
            audioPlayer.seek(to: streamPosition)

            if isPlayingAudioMessage {

            }

        default:
            break
        }
        gesture.setTranslation(.zero, in: seekView)
    }
}

// MARK: TableView Delegate Methods
extension ChatVC: UITableViewDelegate {


}

// MARK: ScrollView Delegate Methods
extension ChatVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideOptions()
    }
}

// MARK: UITextView Delegate Methods
extension ChatVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            toggleOnTypeBtns(hidden: !trimmedText.isEmpty)
        } else {
            toggleOnTypeBtns(hidden: false)
        }
    }

    private func toggleOnTypeBtns(hidden: Bool) {

        guard innerEmojiBtn.isHidden != hidden else {
            return
        }

        UIView.animate(withDuration: 0.2) {

            let visibleAlpha: CGFloat = !hidden ? 1:0
            let hiddenAlpha: CGFloat = hidden ? 1:0

            self.innerEmojiBtn.isHidden = hidden
            self.innerStickerBtn.isHidden = hidden
            self.innerCameraBtn.isHidden = hidden
            self.innerAudioBtn.isHidden = hidden

            self.sendBtn.isHidden = !hidden
            self.moreOptionBtn.isHidden = !hidden

            self.innerEmojiBtn.alpha = visibleAlpha
            self.innerStickerBtn.alpha = visibleAlpha
            self.innerCameraBtn.alpha = visibleAlpha
            self.innerAudioBtn.alpha = visibleAlpha

            self.sendBtn.alpha = hiddenAlpha
            self.moreOptionBtn.alpha = hiddenAlpha

            self.view.layoutIfNeeded()
        }
    }
}

// MARK: VoiceRecording Delegate Methods
extension ChatVC: VoiceRecordingDelegate {

    func didRecordVoice(_ url: URL) {

        //let roomId = chatRoomInfo.roomId
        AppNetworking.showLoader()

        let asset = AVURLAsset(url: url)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)

        url.uploadToS3(success: { [weak self] (success, url) in
            AppNetworking.hideLoader()

            guard let strongSelf = self else {
                return
            }
            strongSelf.checkAndCreateRoom()

            guard let message = ChatHelper.composeAudioMessage(url, duration: audioDurationSeconds, strongSelf.chatRoomInfo.roomId, false, nil) else {
                return
            }
            strongSelf.sendMessage(message)

            }, progress: { _ in

        }, failure: { error in
            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
}

// MARK: StickerInputView Delegate Methods
extension ChatVC: StickerInputViewDelegate {

    func didSelectEmoji(_ name: String) {
        checkAndCreateRoom()
        if let chatMessage = ChatHelper.composeStickerMessage(type: .emoji, name, chatRoomInfo.roomId, false, nil) {
            sendMessage(chatMessage)
        }
    }

    func didSelectSticker(_ sticker: String) {
        checkAndCreateRoom()
        if let chatMessage = ChatHelper.composeStickerMessage(type: .sticker, sticker, chatRoomInfo.roomId, false, nil) {
            sendMessage(chatMessage)
        }
    }

    func didLongPressEmoji(_ name: String) {
        if presentedViewController == nil,
            let image = UIImage(named: name) {
            CommonClass.imageShare(textURL: "", shareImage: image, viewController: self)
        }
    }

    func didLongPressSticker(_ name: String) {
        guard presentedViewController == nil else {
            return
        }
        if let asset = NSDataAsset(name: name),
            let stickerGif = UIImage.sd_animatedGIF(with: asset.data) {
            let shareController = UIActivityViewController(activityItems: [stickerGif], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = view
            present(shareController, animated: true, completion: nil)
        } else {
            didLongPressEmoji(name)
        }
    }

    fileprivate func sendMessage(_ message: ChatMessage) {
        message.color = (myChatColor ?? "")
        FirebaseHelper.sendMessage(message, chatRoomInfo.roomId, .messages)
        FirebaseHelper.sendMessage(message, chatRoomInfo.roomId, .lastMessage)
        FirebaseHelper.setLastUpdates(roomId: chatRoomInfo.roomId, userId: AppDelegate.shared.currentuser.user_id)

        if chatMembers.isEmpty {
            let userUpdates = chatRoomInfo.lastUpdates
            FirebaseHelper.createMessageInfo(messageId: message.messageId, users: userUpdates)
            hitSentMessageApi(message, users: userUpdates)

        } else {
            var userUpdates = [UserUpdates]()
            for member in chatMembers {
                let update = UserUpdates(id: member.userId, updatedAt: 0)
                userUpdates.append(update)
            }
            FirebaseHelper.createMessageInfo(messageId: message.messageId, users: userUpdates)
            hitSentMessageApi(message, users: userUpdates)
        }
    }

    private func hitSentMessageApi(_ message: ChatMessage, users: [UserUpdates]) {

        var parameters: JSONDictionary = ["method": "chat_notification",
                                          "access_token": AppDelegate.shared.currentuser.access_token,
                                          "message": message.message,
                                          "room_id": chatRoomInfo.roomId]

        switch chatRoomInfo.chatType {
        case .single:
            if let id = senderId {
                parameters["friend_id"] = id
            }
            parameters["type"] = 1

        case .group:
            parameters["title"] = chatRoomInfo.chatTitle
            parameters["image"] = chatRoomInfo.chatPic
            parameters["type"] = 2

            let userDict = users.filter({ user in
                let currentUserId = AppDelegate.shared.currentuser.user_id
                return (currentUserId != user.id)

            }).map({ user in
                return ["id": user.id]
            })

            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(userDict) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    parameters["user_ids"] = jsonString
                }
            }

        case .none:
            return
        }
        WebServices.chatPush(parameters: parameters)
    }
}

// MARK: StickerInputView Delegate Methods
extension ChatVC: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let seekThumbnailView = gestureRecognizer.view,
           let indexPath = seekThumbnailView.tableViewIndexPath(chatMessageTableView) else {
            return false
        }

        let message = chatMessages[indexPath.row]
        return message.messageId == playedAudioMessageId
    }
}

