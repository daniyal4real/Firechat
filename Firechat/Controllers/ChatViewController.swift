//
//  ChatViewController.swift
//  Firechat
//
//  Created by Daniyal Ganiuly on 27.02.2023.
//

import UIKit
import MessageKit



struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String 
    var senderId: String
    var displayName: String
}


class ChatViewController: MessagesViewController {
    private var messages = [Message]()
    
    private let selfSender = Sender(
        photoURL: "",
        senderId: "1",
        displayName: "Mike Landin")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        
        messages.append(Message(
            sender: selfSender,
            messageId: "1",
            sentDate: Date(),
            kind: .text("Hello world")))
        
        messages.append(Message(
            sender: selfSender,
            messageId: "1",
            sentDate: Date(),
            kind: .text("How are you")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    

}


extension ChatViewController: MessagesDataSource,
                              MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: SenderType {
        return selfSender
    }
    

    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
