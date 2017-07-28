//
//  MockMessageService.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/25/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

@testable import BehaviorDrivenSwiftExample
import Intrepid

enum MockAPIClientError: Error {
    case fileError
    case postError
}

class MockAPIClient: APIClient {
    var capturedCreateMessage: Message?
    var stubbedRemoteMessage: Message?
    var stubbedCreateMessageError: Error?
    func create(_ message: Message, completion: @escaping (Result<Message>) -> Void) {
        capturedCreateMessage = message
        DispatchQueue.main.async {
            if let error = self.stubbedCreateMessageError {
                completion(.failure(error))
            } else {
                completion(.success(self.stubbedRemoteMessage ?? message))
            }
        }
    }

    var capturedFileData: Data?
    var stubbedCloudFileURL: URL?
    var stubbedUploadAudioError: Error?
    func uploadFile(_ data: Data, completion: @escaping (Result<URL>) -> Void) {
        capturedFileData = data
        DispatchQueue.main.async {
            if let error = self.stubbedUploadAudioError {
                completion(.failure(error))
            } else {
                completion(.success(self.stubbedCloudFileURL!))
            }
        }
    }
}
