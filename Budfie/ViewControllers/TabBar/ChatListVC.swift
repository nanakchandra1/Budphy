//
//  ChatListVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Dwifft
import EmptyDataSet_Swift
import Firebase
import SwiftyJSON

//MARK: ChatListVC class
//======================
class ChatListVC: BaseVc {

    // MARK:- Public Properties
    var toOpenChatRoomId: String?

    // MARK:- Private Properties
    private var observingMessageStatusIds: Set<String> = []
    private var chats: Set<Inbox> = []
    private var searchedChats: Set<Inbox> = [] {
        didSet {
            let chatArray = Array(searchedChats)

            let sectionedValues = SectionedValues<TimeInterval, Inbox>(values: chatArray, valueToSection: { (chat) -> TimeInterval in

                return 0
                /*
                 if let timeStamp = chat.lastMessage?.timeStamp {
                 let date = Date(timeIntervalSince1970: timeStamp)
                 return date.timeIntervalSince1970

                 } else {
                 return dateAtMidnight.timeIntervalSince1970
                 }
                 */

            }, sortSections: { $0 < $1 }, sortValues: { (prevChat, nextChat) -> Bool in

                let prevChatTime = (prevChat.lastMessage?.timeStamp ?? Date().timeIntervalSince1970)
                let nextChatTime = (nextChat.lastMessage?.timeStamp ?? Date().timeIntervalSince1970)

                let isSorted = (prevChatTime > nextChatTime)
                return isSorted
            })
            diffCalculator?.sectionedValues = sectionedValues
        }
    }

    fileprivate var diffCalculator: TableViewDiffCalculator<TimeInterval, Inbox>?
    fileprivate var parentNavCont: UINavigationController? {
        if let parent = self.parent,
            let parentNavCont = parent.navigationController {
            return parentNavCont
        }
        return nil
    }

    fileprivate var apiState: ApiState = .noData {
        didSet {
            if oldValue != apiState {
                chatListTableView.reloadEmptyDataSet()
            }
        }
    }

    /*
     private var inboxObservers: [String: UInt] = [:]
     private var userDet: JSONDictionary = [:]
     private var messageCount: [String: UInt] = [:]
     private var readReceipt: [String: Bool] = [:]
     private var allMembers: JSONDictionary = [:]
     */

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var chatListTableView: UITableView!

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBarView: UIView!

    @IBOutlet weak var editBtn: UIButton!
    //@IBOutlet weak var backBtnName: UIButton!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        toOpenChatRoomId = AppUserDefaults.value(forKey: .toMoveTochatRoomId).string
        AppUserDefaults.removeValue(forKey: .toMoveTochatRoomId)

        setUpInitial()
        observeInbox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: @IBActions
    //================
    @IBAction func landingPageBtnTapped(_ sender: UIButton) {
        parentNavCont?.popViewController(animated: true)
    }

    @IBAction func addParticipantBtnTapped(_ sender: UIButton) {
        let addParticipantScene = AddParticipantVC.instantiate(fromAppStoryboard: .Chat)
        addParticipantScene.flowType = .createGroupChat
        parentNavCont?.pushViewController(addParticipantScene, animated: true)
    }

    @IBAction func editBtnTapped(_ sender: UIButton) {
        let addParticipantScene = AddParticipantVC.instantiate(fromAppStoryboard: .Chat)
        addParticipantScene.flowType = .createOneToOneChat
        parentNavCont?.pushViewController(addParticipantScene, animated: true)
    }
    
    func setUpInitial() {

        diffCalculator = TableViewDiffCalculator(tableView: chatListTableView)

        diffCalculator?.insertionAnimation = .fade
        diffCalculator?.deletionAnimation = .fade

        self.status.backgroundColor         = AppColors.themeBlueColor
        self.navigationView.backgroundColor = UIColor.clear
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)

        self.searchBarView.roundCornerWith(radius: 17.5)
        self.searchBarView.backgroundColor = AppColors.friendListBottom

        self.searchBar.font = AppFonts.Comfortaa_Light_0.withSize(12.5)
        self.searchBar.placeholder = StringConstants.Search.localized
        self.searchBar.textColor = AppColors.blackColor
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.addTarget(self, action: #selector(searchBarEditingChanged), for: .editingChanged)

        editBtn.roundCornerWith(radius: 25)
        editBtn.backgroundColor = AppColors.themeBlueColor
        editBtn.addQualityShadow(ofColor: AppColors.themeBlueColor, radius: 2, offset: .zero, opacity: 0.5, shadowPath: nil)

        let nibName = ChatListCell.defaultReuseIdentifier
        let nib = UINib(nibName: nibName, bundle: nil)
        chatListTableView.register(nib, forCellReuseIdentifier: nibName)

        chatListTableView.estimatedRowHeight = 70
        chatListTableView.rowHeight = 70

        chatListTableView.dataSource = self
        chatListTableView.delegate = self
        chatListTableView.tableFooterView = UIView()

        chatListTableView.emptyDataSetSource = self
        chatListTableView.emptyDataSetDelegate = self
    }

    @objc private func searchBarEditingChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            searchedChats = chats.filter({$0.name.lowercased().hasPrefix(text.lowercased())})
        } else {
            searchedChats = chats
        }
        chatListTableView.reloadData()
    }

}

// MARK: Database Methods
private extension ChatListVC {

    func observeInbox() {

        DispatchQueue.global(qos: .background).async {

            guard let currentUserId = AppDelegate.shared.currentuser?.user_id else {
                return
            }

            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(currentUserId).observe(.childAdded, with: { [weak self] (snapshot) in

                guard let strongSelf = self,
                    let value = snapshot.value as? String else {
                        return
                }

                let chat = Inbox(with: value)
                strongSelf.chats.insert(chat)
                strongSelf.searchBarEditingChanged(strongSelf.searchBar)

                /*
                 if let index = Array(strongSelf.chats).index(of: chat) {
                 let indexToBeInserted = IndexPath(row: index, section: 0)
                 strongSelf.chatListTableView.insertRows(at: [indexToBeInserted], with: .fade)

                 if index == 0 {
                 strongSelf.chatListTableView.reloadEmptyDataSet()
                 }
                 }
                 */

                print_debug("\(snapshot.key) \(value)")
                strongSelf.getLastMessage(value)

                if snapshot.key == value {

                    print_debug("\(value) is group")
                    strongSelf.getGroupDetails(value)

                } else {

                    print_debug("\(value) is single")
                    strongSelf.getUserDetails(snapshot.key, roomId: value)
                }

                }, withCancel: { [weak self] (error) in

                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.chatListTableView.reloadData()
            })
        }

        /*
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(currentUserId).observe(.childRemoved, with: { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value as? String else {
                    return
            }

        }
        */
    }

    func getUserDetails(_ userId: String, roomId: String) {
        let node: DatabaseNode.Root = .users

        DatabaseReference.child(node.rawValue).child(userId).observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parseRoomInfo(from: snapshot, for: roomId, userId: userId, of: node)
        }
    }

    func getLastMessage(_ roomId: String) {
        fetchDetails(from: .lastMessage, for: roomId)
    }

    func getGroupDetails(_ roomId: String) {
        fetchDetails(from: .roomInfo, for: roomId)
    }

    func fetchDetails(from node: DatabaseNode.Root, for id: String) {
        
        DatabaseReference.child(node.rawValue).child(id).observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parseRoomInfo(from: snapshot, for: id, userId: nil, of: node)
        }
    }

    func parseRoomInfo(from snapshot: DataSnapshot, for roomId: String, userId: String?, of node: DatabaseNode.Root) {

        guard let value = snapshot.value else {
            return
        }
        print_debug("value: \(value)")

        let json = JSON(value)

        guard let chat = chats.filter({$0.roomId == roomId}).first else {
            return
        }

        if let name = json[DatabaseNode.RoomInfo.chatTitle.rawValue].string {
            chat.name = name
        }

        if let firstName = json[DatabaseNode.Users.firstName.rawValue].string {
            chat.name = firstName
        }

        if let lastName = json[DatabaseNode.Users.lastName.rawValue].string {
            chat.name.append(" \(lastName)")
        }

        if let typeStr = json[DatabaseNode.RoomInfo.chatType.rawValue].string {
            chat.type = ChatType(rawValue: typeStr.capitalized) ?? .none
        }

        if let id = userId {
            chat.senderId = id
            chat.type = .single
        }

        if let imgStr = json[DatabaseNode.Users.profilePic.rawValue].string,
            let url = URL(string: imgStr) {
            chat.pic = url
        }

        if let imgStr = json[DatabaseNode.RoomInfo.chatPic.rawValue].string,
            let url = URL(string: imgStr) {
            chat.pic = url
        }

        if node == .lastMessage {
            let lastMessage = ChatMessage(with: json)
            FirebaseHelper.setMessageInfoStatus(lastMessage, status: .delivered)
            observeMessageStatus(lastMessage, of: roomId)
            chat.lastMessage = lastMessage
        }

        /*
         if let timeStamp = json[DatabaseNode.RoomInfo.lastUpdate.rawValue].int,
         let message = json[DatabaseNode.Messages.message.rawValue].string {

         let messageDict: JSONDictionary = [DatabaseNode.Messages.timestamp.rawValue: timeStamp,
         DatabaseNode.Messages.message.rawValue: message]
         let messageJSON = JSON(messageDict)
         let lastMessage = ChatMessage(with: messageJSON)
         chat.lastMessage = lastMessage
         }
         */

        chats.insert(chat)
        //refreshCell(for: chat)
        searchBarEditingChanged(searchBar)
    }

    func observeMessageStatus(_ message: ChatMessage, of roomId: String) {

        let messageId = message.messageId
        guard !messageId.isEmpty,
            !observingMessageStatusIds.contains(messageId) else {
                return
        }
        observingMessageStatusIds.insert(messageId)

        DatabaseReference.child(DatabaseNode.Root.messageInfo.rawValue).child(message.messageId).observe(.value) { (snapshot) in

            guard let statusDict = snapshot.value as? JSONDictionary else {
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
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .read)
            } else if deliveredCount >= sentCount {
                FirebaseHelper.setMessageStatus(message, roomId: roomId, status: .delivered)
            }
        }
    }

    func refreshCell(for chat: Inbox) {

        DispatchQueue.mainQueueAsync { [weak self] in

            guard let strongSelf = self else {
                return
            }
            let chats = Array(strongSelf.chats)

            guard let index = chats.index(of: chat) else {
                return
            }

            if index < strongSelf.chatListTableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: index, section: 0)
                strongSelf.chatListTableView.reloadRows(at: [indexPath], with: .fade)
            }
            /* else {
             strongSelf.chatListTableView.reloadData()
             }*/
        }
    }
}

// MARK: TableView DataSource Methods
extension ChatListVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sectionCount = diffCalculator?.numberOfSections() {
            print_debug("sectionCount: \(sectionCount)")
            return sectionCount
        }
        print_debug("sectionCount: (PRINTED_ZERO)")
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = diffCalculator?.numberOfObjects(inSection: section) {
            print_debug("rowCount: \(rowCount)")
            return rowCount
        }
        print_debug("rowCount: (PRINTED_ZERO)")
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let chat = diffCalculator?.value(atIndexPath: indexPath) else {
            fatalError("Message not found")
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.defaultReuseIdentifier, for: indexPath) as? ChatListCell else {
            fatalError("ChatListCell not found")
        }

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showChatActions))
        cell.addGestureRecognizer(longPressGesture)

        cell.populate(with: chat)
        return cell
    }

    @objc private func showChatActions(_ gesture: UILongPressGestureRecognizer) {
        guard let cell = gesture.view as? UITableViewCell,
            let indexPath = chatListTableView.indexPath(for: cell),
            let chat = diffCalculator?.value(atIndexPath: indexPath),
            chat.senderId != AppDelegate.shared.helpSupport.user_id else {
                return
        }
        showActions(for: chat)
    }
    
    private func showActions(for chat: Inbox) {
        let alert = UIAlertController(title: chat.name, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteChat(chat)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func deleteChat(_ chat: Inbox) {
        let userId = AppDelegate.shared.currentuser.user_id
        switch chat.type {
        case .none:
            return
        case .single:
            if let friendId = chat.senderId {
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).removeValue()
            }
        case .group:
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(chat.roomId).removeValue()
        }
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(chat.roomId).child(userId).child(DatabaseNode.Rooms.memberDelete.rawValue).setValue(timeStamp)

        chats.remove(chat)
        searchedChats.remove(chat)

        /*
         let chatArray = Array(searchedChats)
         if let index = chatArray.index(of: chat) {
         chats.remove(chat)
         searchedChats.remove(chat)
         let indexToBeRemoved = IndexPath(row: index, section: 0)
         chatListTableView.deleteRows(at: [indexToBeRemoved], with: .fade)
         }
         */
    }
}

// MARK: TableView Delegate Methods
extension ChatListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chat = diffCalculator?.value(atIndexPath: indexPath) {
            moveToChat(chat)
        }
    }

    fileprivate func moveToChat(_ chat: Inbox) {

        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)
        let dict = [DatabaseNode.RoomInfo.roomId.rawValue: chat.roomId,
                    DatabaseNode.RoomInfo.chatTitle.rawValue: chat.name]

        if let id = chat.senderId {
            chatScene.senderId = id
        }

        let json = JSON(dict)

        let chatRoomInfo = ChatRoomInfo(with: json)
        chatScene.chatRoomInfo = chatRoomInfo

        parentNavCont?.pushViewController(chatScene, animated: true)
    }
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
extension ChatListVC : EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let title: String

        switch apiState {
        case .failed:
            title = "Wake Up Your Connection"
        case .noData:
            title = "Oops..No Chats Found"
        case .loading:
            return nil
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.black,
                                                        .font: AppFonts.AvenirNext_Regular.withSize(17)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let description: String

        switch apiState {
        case .failed:
            description = "Your internet seems too slow to reach our server."
        case .noData:
            description = "There is no chats. Start chatting with your friends."
        case .loading:
            description = StringConstants.K_Loading_Your_Favourites.localized
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.textGrayColor,
                                                        .font: AppFonts.Comfortaa_Regular_0.withSize(15)]
        let attributedString = NSAttributedString(string: description, attributes: attributes)
        return attributedString
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch apiState {
        case .failed:
            return #imageLiteral(resourceName: "icWakeupConnection")
        case .noData:
            return #imageLiteral(resourceName: "icNoResultFound")
        case .loading:
            return nil
        }
    }

    /*
     func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {

     let buttonTitle: String

     switch apiState {
     case .failed:
     buttonTitle = "Try Again"
     case .noData:
     //buttonTitle = "Okay, Thanks"
     return nil
     case .loading:
     return nil
     }

     let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.themeBlueColor,
     .font: AppFonts.AvenirNext_Regular.withSize(17)]
     let attributedString = NSAttributedString(string: buttonTitle, attributes: attributes)
     return attributedString
     }

     func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
     switch apiState {
     case .failed:
     break
     case .noData:
     break
     case .loading:
     break
     }

     }
     */
}

// MARK: ScrollView Delegate Methods
extension ChatListVC: UIScrollViewDelegate {

    /*
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

     let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y

     if yVelocity > 0 {
     showFloatingBtn()
     } else {
     hideFloatingBtn()
     }
     }
     */

    private func hideFloatingBtn() {
        let height = view.height
        let transform = CGAffineTransform(translationX: 0, y: height)
        transformEditBtn(to:transform)
    }

    private func showFloatingBtn() {
        let transform = CGAffineTransform.identity
        transformEditBtn(to: transform)
    }

    private func transformEditBtn(to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4) {
            self.editBtn.transform = transform
        }
    }
}
