//
//  AddParticipantVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift
import Firebase
import SwiftyJSON

class AddParticipantVC: BaseVc {

    enum FlowType {
        case createOneToOneChat
        case createGroupChat
        case addGroupMember(ChatRoomInfo)
    }

    var flowType: FlowType = .createGroupChat
    var groupMembers = [String]()

    fileprivate var budfieFriends = ContactsController.shared.fetchBudfieContacts()
    fileprivate var searchedFriends = [PhoneContact]()

    fileprivate var selectedFriends = Set<PhoneContact>() {
        didSet {

            let indexPath = IndexPath(row: 0, section: 0)

            if oldValue.isEmpty {
                if !selectedFriends.isEmpty {
                    participantListTableView.insertRows(at: [indexPath], with: .fade)
                }
            } else {

                if selectedFriends.isEmpty {
                    participantListTableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    participantListTableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }

    fileprivate var apiState: ApiState = .noData {
        didSet {
            if oldValue != apiState {
                participantListTableView.reloadEmptyDataSet()
            }
        }
    }

    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var participantListTableView: UITableView!

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var nextBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    private func setupSubviews() {
        registerNibs()

        status.backgroundColor = AppColors.themeBlueColor
        navigationView.backgroundColor = UIColor.clear

        searchBarView.roundCornerWith(radius: 17.5)
        searchBarView.backgroundColor = AppColors.friendListBottom

        searchBar.font = AppFonts.Comfortaa_Light_0.withSize(12.5)
        searchBar.placeholder = StringConstants.Search.localized
        searchBar.textColor = AppColors.blackColor
        searchBar.backgroundColor = UIColor.clear
        searchBar.addTarget(self, action: #selector(searchBarEditingChanged), for: .editingChanged)

        switch flowType {
        case .createOneToOneChat:
            participantListTableView.allowsMultipleSelection = false
            nextBtn.alpha = 0
            navigationTitle.text = "New Chat"
        case .createGroupChat:
            participantListTableView.allowsMultipleSelection = true
        case .addGroupMember(_):
            budfieFriends = budfieFriends.filter({!groupMembers.contains($0.id)})
            nextBtn.setTitle("Add", for: .normal)
        }
        searchedFriends = budfieFriends

        participantListTableView.dataSource = self
        participantListTableView.delegate = self
        participantListTableView.tableFooterView = UIView()

        participantListTableView.emptyDataSetSource = self
        participantListTableView.emptyDataSetDelegate = self
    }

    private func registerNibs() {
        let selectedParticipantCellNibName = ChatSelectedParticipantCell.defaultReuseIdentifier
        let selectedParticipantCellNib = UINib(nibName: selectedParticipantCellNibName, bundle: nil)
        participantListTableView.register(selectedParticipantCellNib, forCellReuseIdentifier: selectedParticipantCellNibName)

        let ChatListNibName = ChatListCell.defaultReuseIdentifier
        let ChatListNib = UINib(nibName: ChatListNibName, bundle: nil)
        participantListTableView.register(ChatListNib, forCellReuseIdentifier: ChatListNibName)
    }

    @objc private func searchBarEditingChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            searchedFriends = budfieFriends.filter({$0.name.lowercased().contains(s: text.lowercased())})
        } else {
            searchedFriends = budfieFriends
        }
        participantListTableView.reloadData()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func nextBtnTapped(_ sender: UIButton) {
        let selectedFriendsArray = Array(selectedFriends)

        guard !selectedFriendsArray.isEmpty else {
            CommonClass.showToast(msg: "Please select one or more friends")
            return
        }

        switch flowType {
        case .createGroupChat, .createOneToOneChat:
            if selectedFriendsArray.count == 1 {
                moveToChat(with: selectedFriendsArray)

            } else {
                let createNewGroupScene = CreateNewGroupVC.instantiate(fromAppStoryboard: .Chat)
                createNewGroupScene.selectedFriends = selectedFriendsArray
                navigationController?.pushViewController(createNewGroupScene, animated: true)
            }

        case .addGroupMember(let roomInfo):
            let chatMembers = selectedFriends.map({ friend -> ChatMember in
                return ChatMember(with: friend)
            })
            FirebaseHelper.addNewMembers(newMembers: chatMembers, to: roomInfo.roomId)
            sendMemberAddedMessage(chatMembers, room: roomInfo)
            navigationController?.popViewController(animated: true)
        }
    }

    private func sendMemberAddedMessage(_ members: [ChatMember], room: ChatRoomInfo) {

        let userUpdates = members.map({ member -> UserUpdates in
            let update = UserUpdates(id: member.userId, updatedAt: 0)
            return update
        })
        room.lastUpdates.append(contentsOf: userUpdates)
        
        let currentUserName: String
        
        let currentUserFirstName = AppDelegate.shared.currentuser.first_name
        let currentUserLastName = AppDelegate.shared.currentuser.last_name
        
        if currentUserLastName.isEmpty {
            currentUserName = currentUserFirstName
        } else {
            currentUserName = "\(currentUserFirstName) \(currentUserLastName)"
        }

        for member in members {
            let name: String
            if member.lastName.isEmpty {
                name = member.firstName
            } else {
                name = "\(member.firstName) \(member.lastName)"
            }
            
            if let chatMessage = ChatHelper.composeHeaderMessage(message: "\(currentUserName) added member \(name)", roomId: room.roomId) {
                sendMessage(chatMessage, room: room)
            }
        }

        for userUpdate in userUpdates {
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userUpdate.id).child(room.roomId).setValue(room.roomId)
        }
    }

    fileprivate func sendMessage(_ message: ChatMessage, room: ChatRoomInfo) {
        
        FirebaseHelper.sendMessage(message, room.roomId, .messages)
        FirebaseHelper.sendMessage(message, room.roomId, .lastMessage)
        FirebaseHelper.setLastUpdates(roomId: room.roomId, userId: AppDelegate.shared.currentuser.user_id)

        let userUpdates = room.lastUpdates
        FirebaseHelper.createMessageInfo(messageId: message.messageId, users: userUpdates)
        hitSentMessageApi(message, room: room)
    }

    private func hitSentMessageApi(_ message: ChatMessage, room: ChatRoomInfo) {

        var parameters: JSONDictionary = ["method": "chat_notification",
                                          "access_token": AppDelegate.shared.currentuser.access_token,
                                          "message": message.message,
                                          "room_id": room.roomId]

        switch room.chatType {
        case .single, .none:
            return

        case .group:
            parameters["title"] = room.chatTitle
            parameters["image"] = room.chatPic
            parameters["type"] = 2

            let userDict = room.lastUpdates.map({ user in
                return ["id": user.id]
            })

            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(userDict) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    parameters["user_ids"] = jsonString
                }
            }
        }
        WebServices.chatPush(parameters: parameters)
    }
}

// MARK: TableView DataSource Methods
extension AddParticipantVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let budfieFriendsCount = searchedFriends.count
        if selectedFriends.isEmpty {
            return budfieFriendsCount
        }
        return (budfieFriendsCount + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if selectedFriends.isEmpty || indexPath.row != 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.defaultReuseIdentifier, for: indexPath) as? ChatListCell else {
                fatalError("ChatListCell not found")
            }
            cell.type = .addParticipant

            switch flowType {
            case .createOneToOneChat:
                cell.checkboxImageView.isHidden = true
            default:
                break
            }

            if selectedFriends.isEmpty {
                cell.populate(with: searchedFriends[indexPath.row])
            } else {
                cell.populate(with: searchedFriends[indexPath.row - 1])
            }
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatSelectedParticipantCell.defaultReuseIdentifier, for: indexPath) as? ChatSelectedParticipantCell else {
            fatalError("ChatSelectedParticipantCell not found")
        }

        cell.participantListCollectionView.dataSource = self
        cell.participantListCollectionView.delegate = self
        cell.participantListCollectionView.reloadData()
        return cell
    }
}

// MARK: TableView Delegate Methods
extension AddParticipantVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedFriends.isEmpty || indexPath.row != 0 {
            return 70
        }
        return 62.5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedFriends.isEmpty || indexPath.row != 0 {
            return 70
        }
        return 62.5
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedFriends.isEmpty || indexPath.row != 0 {
            return indexPath
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedFriends.isEmpty || indexPath.row != 0 {
            return indexPath
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let friend: PhoneContact
        switch flowType {

        case .createOneToOneChat:
            friend = searchedFriends[indexPath.row]
            moveToChat(with: [friend])

        default:
            if selectedFriends.isEmpty {
                friend = searchedFriends[indexPath.row]
            } else {
                friend = searchedFriends[indexPath.row - 1]
            }
            selectedFriends.insert(friend)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedFriends.isEmpty {
            selectedFriends.remove(searchedFriends[indexPath.row])
        } else {
            selectedFriends.remove(searchedFriends[indexPath.row - 1])
        }
    }

    private func moveToChat(with friends: [PhoneContact]) {
        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)

        let chatMembers = friends.map({ friend -> ChatMember in
            return ChatMember(with: friend)
        })
        chatScene.chatMembers = chatMembers

        let member = chatMembers[0]
        let chatTitle = "\(member.firstName) \(member.lastName)"

        let json = JSON([DatabaseNode.RoomInfo.chatTitle.rawValue: chatTitle,
                         DatabaseNode.RoomInfo.chatPic.rawValue: member.profilePic])
        let roomInfo = ChatRoomInfo(with: json)

        chatScene.chatRoomInfo = roomInfo
        navigationController?.pushViewController(chatScene, animated: true)
    }
}

// MARK: CollectionView DataSource Methods
extension AddParticipantVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let selectedFriendsArray = Array(selectedFriends)
        return selectedFriendsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCollectionCell.defaultReuseIdentifier, for: indexPath) as? ParticipantCollectionCell else {
            fatalError("ParticipantCollectionCell not found")
        }

        let selectedFriendsArray = Array(selectedFriends)
        let friend = selectedFriendsArray[indexPath.item]
        cell.participantImageView.setImage(withSDWeb: friend.image, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
        cell.removeBtn.addTarget(self, action: #selector(removeUserTapped), for: .touchUpInside)
        return cell
    }

    @objc private func removeUserTapped(_ sender: UIButton) {

        let tableIndexPath = IndexPath(row: 0, section: 0)
        guard let chatSelectedParticipantCell = participantListTableView.cellForRow(at: tableIndexPath) as? ChatSelectedParticipantCell else {
            return
        }

        guard let indexPath = sender.collectionViewIndexPath(chatSelectedParticipantCell.participantListCollectionView) else {
            return
        }

        let selectedFriendsArray = Array(selectedFriends)
        let friend = selectedFriendsArray[indexPath.item]

        if let index = searchedFriends.index(of: friend) {
            let toRemoveIndexPath = IndexPath(row: (index + 1), section: 0)
            participantListTableView.deselectRow(at: toRemoveIndexPath, animated: true)
            tableView(participantListTableView, didDeselectRowAt: toRemoveIndexPath)
        }
        //selectedFriends.remove(friend)
    }
}

// MARK: CollectionView Delegate Methods
extension AddParticipantVC: UICollectionViewDelegate {


}

// MARK: CollectionView Delegate FlowLayout Methods
extension AddParticipantVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 55, height: 55)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 7.5, right: 15)
        return insets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
extension AddParticipantVC : EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let title: String

        switch apiState {
        case .failed:
            title = "Wake Up Your Connection"
        case .noData:
            title = "Oops..No Friends Found"
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
            description = "There is no friends. Share Budfie with your friends to start chatting."
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
