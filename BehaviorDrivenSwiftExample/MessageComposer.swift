//
//  MessageComposer.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/24/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

class Message {
    var identifier: String?
    var audioURL: URL?
}

protocol MessageService {
    func create(_ message: Message, completion: @escaping (Result<Message>) -> Void)
}

protocol CloudFileService {
    func uploadLocalAudioFile(_ url: URL, completion: @escaping (Result<URL>) -> Void)
}

class MessageComposer {
    let cloudService: CloudFileService
    let messageService: MessageService

    init(cloudService: CloudFileService, messageService: MessageService) {
        self.cloudService = cloudService
        self.messageService = messageService
    }

    func sendTextMessage(_ message: Message, completion: @escaping (Result<Message>) -> Void) {
        messageService.create(message, completion: { result in
            switch result {
            case .success(let remoteMessage):
                completion(.success(remoteMessage))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func sendVoiceMessage(_ message: Message, localURL: URL, completion: @escaping (Result<Message>) -> Void) {
        cloudService.uploadLocalAudioFile(localURL) { result in
            switch result {
            case .success(let remoteURL):
                message.audioURL = remoteURL
                self.messageService.create(message, completion: { result in
                    switch result {
                    case .success(let remoteMessage):
                        completion(.success(remoteMessage))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

