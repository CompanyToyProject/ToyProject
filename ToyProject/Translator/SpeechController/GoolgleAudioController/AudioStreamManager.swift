//
//  AudioStreamManager.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/27.
//

import Foundation
import AVFoundation

enum AudioStreamError: Error {
    case failedToConfigure
    case failedToFindAudioComponent
    case failedToFindMicrophoneUnit
}

protocol StreamDelegate: AnyObject {
    func processAudio(_ data: Data)
}

class AudioStreamManager {
    var microphoneUnit: AudioComponentInstance?
    weak var delegate: StreamDelegate?
    
    static var shared = AudioStreamManager()
    
    // 오디오 유닛 요소에 사용되는 유형입니다. 버스 1은 입력 범위, 요소 1입니다.
    private let bus1: AudioUnitElement = 1
    
    func prepare() throws {
        try self.configureAudioSession()
        
        var audioComponentDescription = self.describeComponent()
        
        guard let remoteIOComponent = AudioComponentFindNext(nil, &audioComponentDescription) else {
            throw AudioStreamError.failedToFindAudioComponent
        }
        
        AudioComponentInstanceNew(remoteIOComponent, &self.microphoneUnit)
        
        try self.configureMicrophoneForInput()
        
        try self.setFormatForMicrophone()
        
        try self.setCallback()
        
        if let microphoneUnit = self.microphoneUnit {
            let status = AudioUnitInitialize(microphoneUnit)
            if status != noErr {
                throw AudioStreamError.failedToConfigure
            }
        }
    }
    
    func start() {
        guard let microphoneUnit = self.microphoneUnit else { return }
        AudioOutputUnitStart(microphoneUnit)
    }
    
    func stop() {
        guard let microphoneUnit = self.microphoneUnit else { return }
        AudioOutputUnitStop(microphoneUnit)
    }
    
    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record)
        try session.setPreferredIOBufferDuration(10)
    }
    
    private func describeComponent() -> AudioComponentDescription {
        var description = AudioComponentDescription()
        description.componentType = kAudioUnitType_Output
        description.componentSubType = kAudioUnitSubType_RemoteIO
        description.componentManufacturer = kAudioUnitManufacturer_Apple
        description.componentFlags = 0
        description.componentFlagsMask = 0
        return description
    }
    
    private func configureMicrophoneForInput() throws {
        guard let microphoneUnit = self.microphoneUnit else {
            throw AudioStreamError.failedToFindMicrophoneUnit
        }
        
        var oneFlag: UInt32 = 1
        
        let status = AudioUnitSetProperty(
            microphoneUnit,
            kAudioOutputUnitProperty_EnableIO,
            kAudioUnitScope_Input,
            self.bus1,
            &oneFlag,
            UInt32(MemoryLayout<UInt32>.size)
        )
        
        if status != noErr {
            throw AudioStreamError.failedToConfigure
        }
    }
    
    private func setFormatForMicrophone() throws {
        guard let microphoneUnit = self.microphoneUnit else {
            throw AudioStreamError.failedToFindMicrophoneUnit
        }
        
        // 양방향 스트림을 통해 전송된 초기 메시지와 일치하도록 오디오 형식을 구성합니다. 구성과 아래가 일치해야 합니다.
        var asbd = AudioStreamBasicDescription()
        asbd.mSampleRate = Double(GoogleCloudModel.sampleRate)
        asbd.mFormatID = kAudioFormatLinearPCM
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        asbd.mBytesPerPacket = 2
        asbd.mFramesPerPacket = 1
        asbd.mBytesPerFrame = 2
        asbd.mChannelsPerFrame = 1
        asbd.mBitsPerChannel = 16
        
        let status = AudioUnitSetProperty(
            microphoneUnit,
            kAudioUnitProperty_StreamFormat,
            kAudioUnitScope_Output,
            self.bus1,
            &asbd,
            UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        )
        
        if status != noErr {
            throw AudioStreamError.failedToConfigure
        }
        
    }
    
    private func setCallback() throws {
        guard let microphoneUnit = self.microphoneUnit else {
            throw AudioStreamError.failedToFindMicrophoneUnit
        }
        
        var callbackStruct = AURenderCallbackStruct()
        callbackStruct.inputProc = audioRecordingCallBack
        callbackStruct.inputProcRefCon = nil
        
        let status = AudioUnitSetProperty(
            microphoneUnit,
            kAudioOutputUnitProperty_SetInputCallback,
            kAudioUnitScope_Global,
            self.bus1,
            &callbackStruct,
            UInt32(MemoryLayout<AURenderCallbackStruct>.size)
        )
        
        if status != noErr {
            throw AudioStreamError.failedToConfigure
        }
        
        log.d("ok")
        
    }
    
    deinit {
        if let microphoneUnit = microphoneUnit {
            AudioComponentInstanceDispose(microphoneUnit)
        }
    }
}

func audioRecordingCallBack(
    inRefCon: UnsafeMutableRawPointer,
    ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
    inTimeStamp: UnsafePointer<AudioTimeStamp>,
    inBusNumber: UInt32,
    inNumberFrames: UInt32,
    ioData: UnsafeMutablePointer<AudioBufferList>?
) -> OSStatus {
    var status = noErr
    
    let channelCount: UInt32 = 1
    
    var bufferList = AudioBufferList()
    bufferList.mNumberBuffers = channelCount
                                                                    // 댕글링 포인터(Dangling Pointer) : 포인터가 여전히 해제된 메모리 영역을 가리키고 있다면, 이러한 포인터를 댕글링 포인터로 칭함. 댕글링 포인터가 가리키는 메모리는 더는 유효하지 않음.
//    let buffers = UnsafeMutableBufferPointer<AudioBuffer>(        // -> 해당 UnsafeMutableBufferPointer 사용시 댕글링 포인터(Dangling Pointer) 발생
//        start: &bufferList.mBuffers,
//        count: Int(bufferList.mNumberBuffers)
//    )
    
    // 그래서 withUnsafePointer함수를 사용하면 값 대신 값에 대한 포인터에 일시적으로 접근할 수 있어서 문제 해결 완료.
    let buffers = withUnsafeMutablePointer(to: &bufferList.mBuffers) {
        UnsafeMutableBufferPointer(start: $0, count: Int(bufferList.mNumberBuffers))
    }
    
    buffers[0].mNumberChannels = 1
    buffers[0].mDataByteSize = inNumberFrames * 2
    buffers[0].mData = nil
    
    // 녹음된 샘플 가져오기
    guard let remoteIOUnit = AudioStreamManager.shared.microphoneUnit else { fatalError() }
    status = AudioUnitRender(
        remoteIOUnit,
        ioActionFlags,
        inTimeStamp,
        inBusNumber,
        inNumberFrames,
        &bufferList
    )
    
    if status != noErr {
        return status
    }
    
    guard let bytes = buffers[0].mData else {
        log.d("버퍼 오디오 데이터에 대한 포인터를 찾을 수 없습니다")
        fatalError("Unable to find pointer to the buffer audio data")
    }
    
    let data = Data(bytes: bytes, count: Int(buffers[0].mDataByteSize))
    
    DispatchQueue.main.async {
        AudioStreamManager.shared.delegate?.processAudio(data)
    }
    
    return noErr
}
