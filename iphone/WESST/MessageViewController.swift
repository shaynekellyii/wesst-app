//
//  MessageViewController.swift
//  CommunityChat
//
//  Created by Nathan Tannar on 2016-03-25.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    
    var room:PFObject!
    var incomingUser:PFUser!
    var users = [PFUser]()
    
    var messages = [JSQMessage]()
    var messageObjects = [PFObject]()
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.whiteColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    //var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    //var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    //var outgoingBubbleImage = JSQMessagesBubbleImage()
    //var incomingBubbleImage = JSQMessagesBubbleImage()
    
    //var selfAvatar = JSQMessagesAvatarImage()
    //var incomingAvatar = JSQMessagesAvatarImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        self.senderId = PFUser.currentUser()?.objectId
        self.senderDisplayName = PFUser.currentUser()?.username
        
        loadMessages()
    }


    //MARK: - Load messages
    func loadMessages() {
        
        var lastMessage:JSQMessage? = nil
        
        if messages.last != nil {
            lastMessage = messages.last
        }
        
        let messageQuery = PFQuery(className: "Message")
        messageQuery.whereKey("room", equalTo: room)
        messageQuery.orderByAscending("createdAd")
        messageQuery.limit = 500
        messageQuery.includeKey("user")
        
        if lastMessage != nil {
            messageQuery.whereKey("createdAt", greaterThan: lastMessage!.date)
        }
        
        messageQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil {
                for message in results! {
                    self.messageObjects.append(message)
                    let user = message["user"] as! PFUser
                    self.users.append(user)
                    let chatMessage = JSQMessage(senderId: user.objectId, senderDisplayName: user.username, date: message.createdAt, text: message["content"] as! String)
                    self.messages.append(chatMessage)
                }
                if results!.count != 0 {
                    self.finishReceivingMessage()
                }
            }
        }
    }
    
    //Mark: - Send messages
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = PFObject(className: "Message")
        message["content"] = text
        message["room"] = room
        message["user"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.loadMessages()
                self.room["lastUpdate"] = NSDate()
                self.room.saveInBackgroundWithBlock(nil)
            } else {
                print(error!)
            }
        }
        self.finishSendingMessage()
    }
    
    //Mark: - Delegate methods
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.whiteColor())
        default:
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.whiteColor())
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        /*
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(PFUser.currentUser()?.username!.substringToIndex((PFUser.currentUser()?.username!.endIndex.advancedBy(-1))!
), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        default:
            return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(incomingUser.username!.substringToIndex((incomingUser.username!.endIndex.advancedBy(-1))
                ), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))

        }
        */
        var profilePicture = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://www.google.ca/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwi41KzZ6v3MAhVE5WMKHX4bBpMQjRwIBw&url=http%3A%2F%2Ftech.firstpost.com%2Fnews-analysis%2Ffacebook-wants-to-add-your-profile-picture-to-its-facial-recognition-database-104715.html&bvm=bv.123325700,d.cGc&psig=AFQjCNG534WcMevoi4G-seEKo9uUSwVapQ&ust=1464561448174050")!)!)!
        profilePicture = UIImage(named: "blank.jpg")!
        profilePicture.rounded
        profilePicture.circle
        return JSQMessagesAvatarImageFactory.avatarImageWithImage(profilePicture, diameter: UInt(profilePicture.size.width))
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 5 == 0 {
            let message = messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        } else {
            return nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.blackColor()
        } else {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName: (cell.textView?.textColor)!]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 5 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            return 0
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//UI Image Rounding
extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

