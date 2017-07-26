//
//  MockCloudFileService.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/25/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

@testable import BehaviorDrivenSwiftExample
import Intrepid

enum CloudFileServiceError: Error {
    case unknown
}

class MockCloudFileService: CloudFileService {
    var stubbedCloudFileURL: URL?
    var stubbedUploadAudioError: Error?
    func uploadLocalAudioFile(_ url: URL, completion: @escaping (Result<URL>) -> Void) {
        DispatchQueue.main.async {
            if let error = self.stubbedUploadAudioError {
                completion(.failure(error))
            } else {
                completion(.success(self.stubbedCloudFileURL!))
            }
        }
    }
}
