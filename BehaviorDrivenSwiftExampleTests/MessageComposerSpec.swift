//
//  MessageComposerSpec.swift
//  BehaviorDrivenSwiftExample
//
//  Created by Colden Prime on 7/25/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

@testable import BehaviorDrivenSwiftExample

import Quick
import Nimble
import Intrepid

class MessageComposerSpec: QuickSpec {
    override func spec() {
        describe("MessageComposer") {
            var sut: MessageComposer!
            var apiClient: MockAPIClient!

            beforeEach {
                apiClient = MockAPIClient()
                sut = MessageComposer(apiClient: apiClient)
            }

            describe("sendTextMessage") {
                var localMessage: Message!
                var capturedResult: Result<Message>?
                beforeEach {
                    localMessage = Message(text: "Hello, World!")
                    capturedResult = nil
                }
                context("when uploading succeeds but sending fails") {
                    beforeEach {
                        apiClient.stubbedCreateMessageError = MockAPIClientError.postError
                        sut.sendTextMessage(localMessage, completion: { result in capturedResult = result })
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds and sending succeeds") {
                    var remoteMessage: Message!
                    beforeEach {
                        remoteMessage = Message(text: "Hello, World!")
                        apiClient.stubbedRemoteMessage = remoteMessage
                        sut.sendTextMessage(localMessage, completion: { result in capturedResult = result })
                    }
                    it("should complete with a success") {
                        expect(capturedResult?.isSuccess).toEventually(beTrue())
                    }
                    it("should complete with a message with the remote identifier") {
                        expect(capturedResult?.value?.identifier).toEventually(equal(remoteMessage.identifier))
                    }
                }
            }

            describe("sendVoiceMessage") {
                let localData = "hello".ip_utf8Data!
                let cloudURL = URL(string: "looks.affoa.org/cloud")!
                var localMessage: Message!
                var capturedResult: Result<Message>?
                beforeEach {
                    localMessage = Message(text: "Hello, World!")
                    capturedResult = nil
                }
                context("when uploading fails") {
                    beforeEach {
                        apiClient.stubbedUploadAudioError = MockAPIClientError.fileError
                        sut.sendVoiceMessage(localMessage, data: localData, completion: { result in capturedResult = result })
                    }
                    it ("should upload the audio data") {
                        expect(apiClient.capturedFileData).to(equal(localData))
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds but sending fails") {
                    beforeEach {
                        apiClient.stubbedCloudFileURL = cloudURL
                        apiClient.stubbedCreateMessageError = MockAPIClientError.postError
                        sut.sendVoiceMessage(localMessage, data: localData, completion: { result in capturedResult = result })
                    }
                    it ("should upload the audio data") {
                        expect(apiClient.capturedFileData).to(equal(localData))
                    }
                    it("should create a message with the remote audio url") {
                        expect(apiClient.capturedCreateMessage?.audioURL).toEventually(equal(cloudURL))
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds and sending succeeds") {
                    var remoteMessage: Message!
                    beforeEach {
                        remoteMessage = Message(text: "Hello, World!")
                        remoteMessage.audioURL = cloudURL
                        apiClient.stubbedCloudFileURL = cloudURL
                        apiClient.stubbedRemoteMessage = remoteMessage
                        sut.sendVoiceMessage(localMessage, data: localData, completion: { result in capturedResult = result })
                    }
                    it ("should upload the audio data") {
                        expect(apiClient.capturedFileData).to(equal(localData))
                    }
                    it("should complete with a success") {
                        expect(capturedResult?.isSuccess).toEventually(beTrue())
                    }
                    it("should complete with a message with the remote identifier") {
                        expect(capturedResult?.value?.identifier).toEventually(equal(remoteMessage.identifier))
                    }
                    it("should complete with a message with the remote audio url") {
                        expect(capturedResult?.value?.audioURL).toEventually(equal(cloudURL))
                    }
                }
            }
        }
    }
}
