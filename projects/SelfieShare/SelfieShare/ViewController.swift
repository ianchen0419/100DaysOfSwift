//
//  ViewController.swift
//  SelfieShare
//
//  Created by 陳怡安 on 2022/6/21.
//

import MultipeerConnectivity
import UIKit


class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let bookButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showPeerList))
        navigationItem.leftBarButtonItems = [addButton, bookButton]
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let textButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(importText))
        
        navigationItem.rightBarButtonItems = [cameraButton, textButton]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func startHosting(action: UIAlertAction) {
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()
        
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {

        invitationHandler(true, mcSession)

        let ac = UIAlertController(title: "Connection Request", message: "User: \(peerID.displayName) is requesting to join the network.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Allow", style: .default) {[weak self] action in
            invitationHandler(true, self?.mcSession)
            })
        ac.addAction(UIAlertAction(title: "Deny", style: .cancel) {[weak self] action in
            invitationHandler(false, self?.mcSession)
            })
        present(ac, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func importText() {
        let ac = UIAlertController(title: "Message", message: "Write down the important message", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "send", style: .default) { [weak self, weak ac] _ in
            guard let message = ac?.textFields?[0].text else { return }
            self?.submit(message: message)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func showPeerList() {
        guard let mcSession = mcSession else { return }
        let userList = mcSession.connectedPeers.map { $0.displayName }.joined(separator: ",")
        
        let ac = UIAlertController(title: "Connecting peers", message: userList, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    func submit(message: String) {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            let messageData = Data(message.utf8)
            
            do {
                try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }

    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("NotConnected: \(peerID.displayName)")
            
            DispatchQueue.main.async { [weak self] in
                let ac = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
            
        @unknown default:
            print("Unknown state recieved: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let message = String(decoding: data, as: UTF8.self)

                let ac = UIAlertController(title: "Message recieved!", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
            
        }
        
    }

}

