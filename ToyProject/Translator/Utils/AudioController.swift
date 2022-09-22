//
//  AudioController.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/16.
//

import Foundation
import UIKit
import AVFoundation

protocol AudioControllerDelegate: AnyObject {
    func processSampleData(_ data:Data) -> Void
}

class AudioController {
    var remoteIOUnit: AudioComponentInstance? // optional to allow it to be an inout argument - 오디오 구성 요소 인스턴스
    var delegate : AudioControllerDelegate!
    
    static var sharedInstance = AudioController()
    
    deinit {
        AudioComponentInstanceDispose(remoteIOUnit!);
    }
    
    func prepare(specifiedSampleRate: Int) -> OSStatus {
        
        var status = noErr  // noErr = 오류없음을 나타내는 OSStatus
        
        let session = AVAudioSession.sharedInstance() // 오디오 세션 싱글톤
        do {
            try session.setCategory(AVAudioSession.Category.record) // 세션을 녹음으로 설정
            try session.setPreferredIOBufferDuration(10) // I/O 버퍼 지속시간 10초로 설정.
        } catch {
            return -1     // 오류 발생했을경우 OSSStaus -1로 리턴
        }
        
        var sampleRate = session.sampleRate // 현재 오디오 샘플 속도(헤르츠)
        print("hardware sample rate = \(sampleRate), using specified rate = \(specifiedSampleRate)")
        sampleRate = Double(specifiedSampleRate)    // 현재 오디오 샘플 속도를 나타내는 sampleRate에 specifiedSampleRate로 교체
        
        // Describe the RemoteIO unit
        var audioComponentDescription = AudioComponentDescription() // 오디오 구성 요소에 대한 식별 정보
        audioComponentDescription.componentType = kAudioUnitType_Output; // componentType : 구성 요소의 인터페이스를 식별하는 고유한 4바이트 코드를
        audioComponentDescription.componentSubType = kAudioUnitSubType_RemoteIO; // componentSubType - 구성 요소의 목적을 나타내는 데 사용할 수 있는 4바이트 코드
        audioComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple; // componentManufacturer - 오디오 구성 요소에 대해 Apple에 등록된 고유한 공급업체 식별자
        audioComponentDescription.componentFlags = 0; // compoentFlags - 0으로 설정하라고 문서에서 나와있음
        audioComponentDescription.componentFlagsMask = 0; // componentFlagsMask - 0으로 설정하라고 문서에서 나와있음
        
        // Get the RemoteIO unit
        let remoteIOComponent = AudioComponentFindNext(nil, &audioComponentDescription) // 지정된 오디오 구성 요소 다음에 지정된 구조와 일차하는 다음 구성 요소를 찾는다. nil은 검색을 시작하려는 오디오 구성 요소부분, &audioComponentDescription은 찾으려는 오디오 구성 요소에 대한 설명
        status = AudioComponentInstanceNew(remoteIOComponent!, &remoteIOUnit)  // 오디오 구성 요소의 새 인스턴스를 만든다. remoteIOComponent는 새 인스턴스를 만드려는 오디오 구성 요소, &remoteIOUnit는 출력 시 새 오디오 구성 요소 인스턴스
        if (status != noErr) { // status가 에러없음이 아닐경우 즉시 status 반환
            return status
        }
        
        let bus1 : AudioUnitElement = 1 // AudioUnitElement는 오디오 단위 요소 식별자의 데이터 유형인데 0일경우 OutputElement, 1일경우 InputElement
        var oneFlag : UInt32 = 1
        
        // Configure the RemoteIO unit for input - 입력용 RemoteIO 장치 구성
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Input,
                                      bus1,
                                      &oneFlag,
                                      UInt32(MemoryLayout<UInt32>.size)); // AudioUnitSetProperty - 오디오 장치 설정 속성, remoteIOUnit : 속성 값을 설정하려는 오디오 장치, kAudioOutputUnitProperty_EnableIO : 오디오 장치 속성 식별자, kAudioUnitScope_Input : 속성의 오디오 장치 범위, bus1 : 속성의 오디오 단위 요소, &oneFlag : 속성에 적용할 값,  UInt32(MemoryLayout<UInt32>.size) : 매개변수 에서 제공하는 데이터의 크기
        if (status != noErr) {  // status가 에러없음이 아닐경우 즉시 status 반환
            return status
        }
        
        // Set format for mic input (bus 1) on RemoteIO's output scope : RemoteIO의 출력 범위에서 마이크 입력(bus 1) 형식 설정
        var asbd = AudioStreamBasicDescription() // 오디오 스트림에 대한 형식 사양을 제공하는 구조 - 입력,출력 장치는 하드웨어에서 강제한 입출력 스트림 포맷을 사용한다. 하드웨어와 연결되는 부분을 제외한 input element의 output과 output elementdml input 연결의 경우 스트림 포맷을 정의해 주어야 한다. 해당 포맷을 지정하지 않으면 콜백에서 렌더시에 데이터가 전달되지 않음.
        asbd.mSampleRate = sampleRate // mSampleRate : 스트림을 정상 속도로 재생할 때 스트림에 있는 데이터의 초당 프레임 수
        asbd.mFormatID = kAudioFormatLinearPCM // mFormatID : 스트림의 일반 오디오 데이터 형식을 지정하는 식별자
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked // mFormatFlags : 형식의 세부 사항을 지정하는 형식별 플래그
        asbd.mBytesPerPacket = 2 // mBytesPerPacket : 오디오 데이터 패킷의 바이트 수
        asbd.mFramesPerPacket = 1 // mFramesPerPackeet : 오디오 데이터 패킷의 프레임 수
        asbd.mBytesPerFrame = 2 // mBytesPerPrame : 오디오 데이터 패킷의 바이트 수
        asbd.mChannelsPerFrame = 1 // mChannelsPerFrame : 오디오 데이터의 각 프레임에 있는 채널 수
        asbd.mBitsPerChannel = 16 // mBitsPerChannel : 하나의 오디오 샘플에 대한 비트 수
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioUnitProperty_StreamFormat,
                                      kAudioUnitScope_Output,
                                      bus1,
                                      &asbd,
                                      UInt32(MemoryLayout<AudioStreamBasicDescription>.size)) // AudioUnitSetProperty - 오디오 장치 설정 속성
        if (status != noErr) {
            return status
        }
        
        // Set the recording callback
        var callbackStruct = AURenderCallbackStruct() // AURenderCallbackStruct : 오디오 장치에 입력 콜백 기능을 등록할 때 사용
        callbackStruct.inputProc = recordingCallback // inputProc : 입력프로세서 콜백 recordingCallback - 주의점 글로벌 scpoe 사용
        callbackStruct.inputProcRefCon = nil        // inputProcRefCon : 입력 프로세서 참조 콘
        status = AudioUnitSetProperty(remoteIOUnit!,    // 오디오 장치 설정 속성
                                      kAudioOutputUnitProperty_SetInputCallback,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &callbackStruct,
                                      UInt32(MemoryLayout<AURenderCallbackStruct>.size));
        if (status != noErr) {
            return status
        }
        
        // Initialize the RemoteIO unit
        return AudioUnitInitialize(remoteIOUnit!) // AudioUnitInitialize : 오디오 장치를 초기화 한다 - remoteIOUnit으로 초기화
    }
    
    func start() -> OSStatus {
        return AudioOutputUnitStart(remoteIOUnit!) // AudioOutputUnitStart : I/O 오디오 장치를 시작하고 연결된 오디오 장치 처리 그래프를 차례로 시작한다.
    }
    
    func stop() -> OSStatus {
        return AudioOutputUnitStop(remoteIOUnit!) // AudioOutputUnitStop : I/O 오디오 장치를 중지하고 차례로 연결된 오디오 장치 처리 그래프를 중지한다.
    }
}

func recordingCallback( // AURenderCallback - 오디오 장치에 입력 샘플이 필요할 떄 또는 렌더링 작업 전후에 시스템에서 호출한다.
    inRefCon:UnsafeMutableRawPointer, // inRefCon : 오디오 장치에 콜백을 등록할 때 제공한 사용자 지정 데이터
    ioActionFlags:UnsafeMutablePointer<AudioUnitRenderActionFlags>, // ioActionFlags : 이 호출의 컨텍스트에 대해 자세히 설명하는 데 사용되는 플래그 (예: 알림 케이스의 사전 또는 사후)
    inTimeStamp:UnsafePointer<AudioTimeStamp>, // inTimeStamp : 이 오디오 장치 렌더링 호출과 연결된 타임스탬프
    inBusNumber:UInt32, // inBusNumber : 이 오디오 장치 렌더링 호출과 연결된 bus 번호
    inNumberFrames:UInt32, // inNumberFrames : 제공된 ioData 매개변수의 오디오 데이터에 표시될 샘플 프레임 수
    ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus { // ioData : 렌더링되거나 제공된 오디오 데이터를 포함하는 데 사용되는 AudioBufferList
        
        var status = noErr
        
        let channelCount : UInt32 = 1
        
        var bufferList = AudioBufferList() // AudioBufferList : 오디오 버퍼의 가변 길이 배열을 저장하는 구조 -
        bufferList.mNumberBuffers = channelCount // mNumberBuffers : 리스트의 오디오 버퍼 수
        
        // 버퍼(buffer)는 연속적인 메모리 공간을 의미. 메모리를 할당해서 구한 포인터는 이 버퍼의 시작 주소를 담고 있다고 볼 수 있다. 버퍼는 메모리 덩어리 그 자체, 하지만 Swift에서는 포인터를 쓸 수 있는 언어가 아니기 떄문에 연속적인 메모리를 액세스 하는 것이 불가능. 그래서 Swift에서는 버퍼를 대체하기위해 배열을 대신 사용
        let buffers = UnsafeMutableBufferPointer<AudioBuffer>(start: &bufferList.mBuffers,
                                                              count: Int(bufferList.mNumberBuffers)) // UnsafeMutableBufferPointer :
        //      let buffers = withUnsafeMutablePointer(to: &bufferList.mBuffers) {
        //          UnsafeMutableBufferPointer(start: $0, count: Int(bufferList.mNumberBuffers))
        //        }
        buffers[0].mNumberChannels = 1 // mNumberChannels : 버퍼의 인터리브된 채널 수
        buffers[0].mDataByteSize = inNumberFrames * 2 // mDataByteSize : 버퍼의 바이트 수
        buffers[0].mData = nil    // mData : 오디오 데이터의 버퍼에 대한 포인터
        
        // get the recorded samples
        status = AudioUnitRender(AudioController.sharedInstance.remoteIOUnit!, // AudioUnitRender : 오디오 장치의 렌더링 주기를 시작, AudioController.sharedInstance.remoteIOUnit : 렌더링을 요청하는 오디오 장치
                                 ioActionFlags, // ioActionFlags : 렌더링 작업을 구성하는 플래그
                                 inTimeStamp, // inTimeStamp : 렌더링 작업의 오디오 타임스탬프
                                 inBusNumber, // inBusNumber : 렌더링할 출력 버스
                                 inNumberFrames, // inNumberFrames : 렌더링할 오디오 샘플 프레임 수
                                 &bufferList) // &bufferList : 입력 시 오디오 장치가 렌더링될 오디오 버퍼 목록. 출력 시 오디오 장치에서 렌더링한 오디오 데이터
        if (status != noErr) {
            return status;
        }
        
        let data = Data(bytes:  buffers[0].mData!, count: Int(buffers[0].mDataByteSize)) // 복사된 메모리 내용으로 데이터를 생성 , buffers[0].mData : 복사할 메모리에 대한 포인터, buffers[0].mDataByteSize : 복사할 바이트 수
        DispatchQueue.main.async {
            AudioController.sharedInstance.delegate.processSampleData(data)
//            AudioController.sharedInstance.delegate.audioSessionToData(data)
        }
        

        return noErr
    }

