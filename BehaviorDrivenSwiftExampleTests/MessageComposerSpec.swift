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
            var cloudService: MockCloudFileService!
            var messageService: MockMessageService!

            beforeEach {
                cloudService = MockCloudFileService()
                messageService = MockMessageService()
                sut = MessageComposer(cloudService: cloudService, messageService: messageService)
            }

            describe("sendTextMessage") {
                var localMessage: Message!
                var capturedResult: Result<Message>?
                beforeEach {
                    localMessage = Message()
                    capturedResult = nil
                }
                context("when uploading succeeds but sending fails") {
                    beforeEach {
                        messageService.stubbedCreateMessageError = MessageComposerError.unknown
                        sut.sendTextMessage(localMessage, completion: { result in capturedResult = result })
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds and sending succeeds") {
                    var remoteMessage: Message!
                    beforeEach {
                        remoteMessage = Message()
                        remoteMessage.identifier = UUID().uuidString
                        messageService.stubbedRemoteMessage = remoteMessage
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
                let localURL = URL(string: "looks.affoa.org/local")!
                let cloudURL = URL(string: "looks.affoa.org/cloud")!
                var localMessage: Message!
                var capturedResult: Result<Message>?
                beforeEach {
                    localMessage = Message()
                    capturedResult = nil
                }
                context("when uploading fails") {
                    beforeEach {
                        cloudService.stubbedUploadAudioError = CloudFileServiceError.unknown
                        sut.sendVoiceMessage(localMessage, localURL: localURL, completion: { result in capturedResult = result })
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds but sending fails") {
                    beforeEach {
                        cloudService.stubbedCloudFileURL = cloudURL
                        messageService.stubbedCreateMessageError = MessageComposerError.unknown
                        sut.sendVoiceMessage(localMessage, localURL: localURL, completion: { result in capturedResult = result })
                    }
                    it("should create a message with the remote audio url") {
                        expect(messageService.capturedCreateMessage?.audioURL).toEventually(equal(cloudURL))
                    }
                    it("should complete with a failure") {
                        expect(capturedResult?.isFailure).toEventually(beTrue())
                    }
                }
                context("when uploading succeeds and sending succeeds") {
                    var remoteMessage: Message!
                    beforeEach {
                        remoteMessage = Message()
                        remoteMessage.identifier = UUID().uuidString
                        remoteMessage.audioURL = cloudURL
                        cloudService.stubbedCloudFileURL = cloudURL
                        messageService.stubbedRemoteMessage = remoteMessage
                        sut.sendVoiceMessage(localMessage, localURL: localURL, completion: { result in capturedResult = result })
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
