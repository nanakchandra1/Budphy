//
//  CreateNewGroupVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Firebase
import SwiftyJSON
import UIKit

class CreateNewGroupVC: BaseVc {

    enum VCType {
        case createGroup
        case groupDetail(ChatRoomInfo)
    }

    var selectedFriends = [PhoneContact]()
    var groupMembers = Set<ChatMember>()

    var type: VCType = .createGroup
    var unusedChatColors: [String] = []

    var randomColor: UIColor {
        if unusedChatColors.isEmpty {
            unusedChatColors = FirebaseHelper.chatColors
        }
        let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
        let color = unusedChatColors[randomIndex]
        unusedChatColors.remove(at: randomIndex)
        return UIColor(hexString: color)
    }

    fileprivate var isAdmin = false {
        didSet {
            groupImageView.isUserInteractionEnabled = isAdmin
            groupNameTextField.isUserInteractionEnabled = isAdmin
            addMemberBtn.alpha = isAdmin ? 1:0

            let tableIndexPath = IndexPath(row: 0, section: 0)
            guard let chatMemberCell = participantListTableView.cellForRow(at: tableIndexPath) as? ChatSelectedParticipantCell else {
                return
            }
            chatMemberCell.participantListCollectionView.reloadData()
        }
    }
    fileprivate var groupImage: UIImage?

    @IBOutlet weak var participantListTableView: UITableView!

    @IBOutlet weak var groupMemberCountLbl: UILabel!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupImageView: UIImageView!

    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var addMemberBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        status.backgroundColor = AppColors.themeBlueColor
        navigationView.backgroundColor = UIColor.clear

        let groupImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(groupImageTapped))
        groupImageView.addGestureRecognizer(groupImageTapGesture)

        groupNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        let nibName = ChatSelectedParticipantCell.defaultReuseIdentifier
        let nib = UINib(nibName: nibName, bundle: nil)
        participantListTableView.register(nib, forCellReuseIdentifier: nibName)

        participantListTableView.separatorStyle = .none
        participantListTableView.allowsSelection = false

        participantListTableView.estimatedRowHeight = participantListTableView.height
        participantListTableView.rowHeight = participantListTableView.height

        participantListTableView.dataSource = self
        participantListTableView.delegate = self

        groupImageView.round()
        addMemberBtn.alpha = 0

        switch type {
        case .createGroup:
            updateMemberCountLbl()

        case .groupDetail(let roomInfo):
            createBtn.alpha = 0
            createBtn.setTitle("Save", for: .normal)
            navigationTitle.text = "Group Info"
            groupImageView.isUserInteractionEnabled = false

            observeGroupUsers(of: roomInfo)
            checkIfIsAdmin(of: roomInfo)

            groupImageView.contentMode = .scaleAspectFill
            groupImageView.setImage(withSDWeb: roomInfo.chatPic, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
            groupNameTextField.text = roomInfo.chatTitle
        }
    }

    private func checkIfIsAdmin(of room: ChatRoomInfo) {
        let userId = AppDelegate.shared.currentuser.user_id
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(room.roomId).child(userId).child(DatabaseNode.Rooms.roomAdmin.rawValue).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value as? Int else {
                    return
            }
            strongSelf.isAdmin = (value == 0) ? false:true
        }
    }

    private func observeGroupUsers(of room: ChatRoomInfo) {
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(room.roomId).observe(.childAdded) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            let json = JSON(value)
            strongSelf.observeUser(snapshot.key, memberInfo: json, room: room)
        }

        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(room.roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).observe(.childRemoved) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }

            let json = JSON(["userId": snapshot.key])
            let chatMember = ChatMember(with: json)
            strongSelf.groupMembers.remove(chatMember)

            strongSelf.updateMemberCountLbl()
            strongSelf.updateMemberList()
        }

        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(room.roomId).observe(.childChanged) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }
            let json = JSON(value)

            let memberJoin = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
            let memberLeave = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue

            let memberJSON = JSON(["userId": snapshot.key])
            let chatMember = ChatMember(with: memberJSON)

            if memberJoin < memberLeave {
                strongSelf.groupMembers.remove(chatMember)
                strongSelf.updateMemberCountLbl()
                strongSelf.updateMemberList()

            } else if let index = strongSelf.groupMembers.index(of: chatMember) {
                let member = strongSelf.groupMembers[index]
                member.isAdmin = json[DatabaseNode.Rooms.roomAdmin.rawValue].boolValue
                strongSelf.groupMembers.remove(member)
            }
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {

        switch type {
        case .createGroup:
            break

        case .groupDetail(let roomInfo):
            guard groupImage == nil else {
                return
            }
            createBtn.alpha = (textField.text != roomInfo.chatTitle) ? 1:0
        }
    }

    private func observeUser(_ id: String, memberInfo: JSON, room: ChatRoomInfo) {

        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(id).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                var value = snapshot.value as? JSONDictionary else {
                    return
            }
            print_debug("\(#function) \(value)")

            value["userId"] = id
            let json = JSON(value)
            let chatMember = ChatMember(with: json)
            chatMember.isAdmin = memberInfo[DatabaseNode.Rooms.roomAdmin.rawValue].boolValue
            strongSelf.observeUserStatus(chatMember, room: room)
        }
    }

    private func observeUserStatus(_ member: ChatMember, room: ChatRoomInfo) {

        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(room.roomId).child(member.userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

            guard let strongSelf = self,
                let value = snapshot.value as? JSONDictionary else {
                    return
            }
            let json = JSON(value)

            let memberJoin = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
            let memberLeave = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue

            if memberJoin > memberLeave {
                strongSelf.groupMembers.insert(member)
            }

            strongSelf.updateMemberCountLbl()
            strongSelf.updateMemberList()
        }
    }

    fileprivate func updateMemberCountLbl() {
        let memberCount: Int
        switch type {
        case .createGroup:
            memberCount = selectedFriends.count
        case .groupDetail(_):
            memberCount = groupMembers.count
        }
        groupMemberCountLbl.text = "Group Members: \(memberCount)"
    }

    private func updateMemberList() {
        let tableIndexPath = IndexPath(row: 0, section: 0)
        guard let chatSelectedParticipantCell = participantListTableView.cellForRow(at: tableIndexPath) as? ChatSelectedParticipantCell else {
            return
        }
        chatSelectedParticipantCell.participantListCollectionView.reloadData()
    }

    @objc private func groupImageTapped(_ gesture: UITapGestureRecognizer) {
        AppImagePicker.showImagePicker(delegateVC: self)
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addMemberBtnTapped(_ sender: UIButton) {
        switch type {
        case .createGroup:
            break

        case .groupDetail(let roomInfo):
            let addParticipantScene = AddParticipantVC.instantiate(fromAppStoryboard: .Chat)
            addParticipantScene.flowType = .addGroupMember(roomInfo)
            addParticipantScene.groupMembers = roomInfo.lastUpdates.map({$0.id})
            navigationController?.pushViewController(addParticipantScene, animated: true)
        }
    }

    @IBAction func createBtnTapped(_ sender: UIButton) {

        guard let text = groupNameTextField.text, !text.isEmpty else {
            CommonClass.showToast(msg: "Please give a name to the group")
            return
        }

        if let image = groupImage {
            AppNetworking.showLoader()
            uploadImage(image)
        } else {
            createSaveGroup(image: nil, name: text)
        }
    }

    private func uploadImage(_ image: UIImage) {
        image.uploadImageToS3(success: { [weak self] (success, urlString) in

            guard let strongSelf = self else {
                AppNetworking.hideLoader()
                return
            }
            strongSelf.createSaveGroup(image: urlString, name: strongSelf.groupNameTextField.text)

        }, progress: { progress in

        }, failure: { error in
            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func createSaveGroup(image: String?, name: String?) {

        switch type {

        case .createGroup:

            var dict = JSONDictionary()
            if let img = image {
                dict[DatabaseNode.RoomInfo.chatPic.rawValue] = img
            }

            if let nm = name {
                dict[DatabaseNode.RoomInfo.chatTitle.rawValue] = nm
            }

            let json = JSON(dict)
            let roomInfo = ChatRoomInfo(with: json)
            moveToChat(with: roomInfo)

        case .groupDetail(let roomInfo):

            guard !roomInfo.roomId.isEmpty else {
                return
            }

            if let nm = name {
                DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomInfo.roomId).child(DatabaseNode.RoomInfo.chatTitle.rawValue).setValue(nm)
            }

            if let img = image {
                DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomInfo.roomId).child(DatabaseNode.RoomInfo.chatPic.rawValue).setValue(img)
            }

            CommonClass.showToast(msg: "Group updated successfully")
        }
    }

    private func moveToChat(with roomInfo: ChatRoomInfo) {
        AppNetworking.hideLoader()

        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)
        let chatMembers = selectedFriends.map({ friend -> ChatMember in
            return ChatMember(with: friend)
        })
        chatScene.chatMembers = chatMembers
        chatScene.chatRoomInfo = roomInfo
        navigationController?.pushViewController(chatScene, animated: true)
    }

}

extension CreateNewGroupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            groupImageView.image = image
            groupImage = image
            groupImageView.contentMode = .scaleAspectFill
            createBtn.alpha = 1
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: TableView DataSource Methods
extension CreateNewGroupVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatSelectedParticipantCell.defaultReuseIdentifier, for: indexPath) as? ChatSelectedParticipantCell else {
            fatalError("ChatSelectedParticipantCell not found")
        }

        cell.participantListCollectionView.dataSource = self
        cell.participantListCollectionView.delegate = self
        cell.participantListCollectionView.reloadData()
        cell.setCollectionViewScrollDirection(.vertical)
        return cell
    }
}

// MARK: TableView Delegate Methods
extension CreateNewGroupVC: UITableViewDelegate {


}

// MARK: CollectionView DataSource Methods
extension CreateNewGroupVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memberCount: Int
        switch type {
        case .createGroup:
            memberCount = selectedFriends.count
        case .groupDetail(_):
            memberCount = groupMembers.count
        }
        return memberCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCollectionCell.defaultReuseIdentifier, for: indexPath) as? ParticipantCollectionCell else {
            fatalError("ParticipantCollectionCell not found")
        }

        let name: String
        let image: String

        switch type {
        case .createGroup:
            let friend = selectedFriends[indexPath.item]
            name = friend.name
            image = friend.image

        case .groupDetail(_):
            let member = Array(groupMembers)[indexPath.item]
            name = "\(member.firstName) \(member.lastName)"
            image = member.profilePic
            cell.removeBtn.isHidden = true //!isAdmin
        }

        if image.isEmpty {
            cell.nameInitialsLbl.isHidden = false
            cell.nameInitialsLbl.text = name.initials
            cell.nameInitialsLbl.backgroundColor = randomColor
        } else {
            cell.participantImageView.setImage(withSDWeb: image, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
        }

        cell.removeBtn.addTarget(self, action: #selector(removeUserTapped), for: .touchUpInside)
        return cell
    }

    @objc private func removeUserTapped(_ sender: UIButton) {

        guard selectedFriends.count > 2 else {
            CommonClass.showToast(msg: "Group must have at least 2 members")
            return
        }

        let tableIndexPath = IndexPath(row: 0, section: 0)
        guard let chatSelectedParticipantCell = participantListTableView.cellForRow(at: tableIndexPath) as? ChatSelectedParticipantCell else {
            return
        }

        guard let indexPath = sender.collectionViewIndexPath(chatSelectedParticipantCell.participantListCollectionView) else {
            return
        }

        switch type {
        case .createGroup:
            selectedFriends.remove(at: indexPath.item)
            participantListTableView.reloadRows(at: [tableIndexPath], with: .none)
            updateMemberCountLbl()

        case .groupDetail(let roomInfo):
            let member = Array(groupMembers)[indexPath.row]
            let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
            DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomInfo.roomId).child(member.userId).child(DatabaseNode.Rooms.memberLeave.rawValue).setValue(timeStamp)
        }
    }
}

// MARK: CollectionView Delegate Methods
extension CreateNewGroupVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .createGroup:
            break

        case .groupDetail(_):
            let member = self.member(at: indexPath)
            if member.userId == AppDelegate.shared.currentuser.user_id {
                return
            } else if isAdmin {
                if member.isAdmin {
                    moveToOtherUserProfile(member.userId)
                } else {
                    showMemberOptions(for: member)
                }
            } else {
                moveToOtherUserProfile(member.userId)
            }
        }
    }

    private func showMemberOptions(for member: ChatMember) {
        let alert = UIAlertController(title: member.fullName, message: nil, preferredStyle: .actionSheet)
        let viewProfileAction = UIAlertAction(title: "View Profile", style: .default) { _ in
            self.moveToOtherUserProfile(member.userId)
        }
        let makeAdminAction = UIAlertAction(title: "Make Admin", style: .default) { _ in
            self.makeAdmin(member)
        }
        let removeMemberAction = UIAlertAction(title: "Remove from Group", style: .default) { _ in
            self.removeFromGroup(member)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(viewProfileAction)
        alert.addAction(removeMemberAction)
        alert.addAction(makeAdminAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    fileprivate func member(at indexPath: IndexPath) -> ChatMember {
        let memberArray = Array(self.groupMembers)
        let member = memberArray[indexPath.item]
        return member
    }

    private func moveToOtherUserProfile(_ friendId: String) {
        let profileScene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        profileScene.state = .otherProfile
        profileScene.friendId = friendId
        navigationController?.pushViewController(profileScene, animated: true)
    }

    private func makeAdmin(_ member: ChatMember) {
        switch type {
        case .createGroup:
            break

        case .groupDetail(let roomInfo):
            DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomInfo.roomId).child(member.userId).child(DatabaseNode.Rooms.roomAdmin.rawValue).setValue(1)

            member.isAdmin = true
            groupMembers.insert(member)
        }
    }

    private func removeFromGroup(_ member: ChatMember) {
        switch type {
        case .createGroup:
            break

        case .groupDetail(let roomInfo):
            sendMemberRemoveMessage(member, room: roomInfo)
            let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
            DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomInfo.roomId).child(member.userId).child(DatabaseNode.Rooms.memberLeave.rawValue).setValue(timeStamp)
        }
    }

    private func sendMemberRemoveMessage(_ member: ChatMember, room: ChatRoomInfo) {

        let name: String
        let currentUserName: String

        let currentUserFirstName = AppDelegate.shared.currentuser.first_name
        let currentUserLastName = AppDelegate.shared.currentuser.last_name

        if currentUserLastName.isEmpty {
            currentUserName = currentUserFirstName
        } else {
            currentUserName = "\(currentUserFirstName) \(currentUserLastName)"
        }

        if member.lastName.isEmpty {
            name = member.firstName
        } else {
            name = "\(member.firstName) \(member.lastName)"
        }

        guard let chatMessage = ChatHelper.composeHeaderMessage(message: "\(currentUserName) removed member \(name)", roomId: room.roomId) else {
            return
        }
        chatMessage.color = (AppColors.sentMessageColor.hexString ?? "")
        sendMessage(chatMessage, room: room)

        for userUpdate in room.lastUpdates {
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

// MARK: CollectionView Delegate FlowLayout Methods
extension CreateNewGroupVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 55, height: 55)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 15, left: 15, bottom: 7.5, right: 15)
        return insets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
