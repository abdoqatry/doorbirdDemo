//
//  AudioVC.swift
//  doorbirdDemo
//
//  Created by Admin on 30/01/2023.
//

import UIKit
import AVFoundation

class AudioVC : UIViewController {
 
    let engine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
     playRecord()
    }
    
    
    func playRecord(){
        let input = engine.inputNode
        let player = AVAudioPlayerNode()
        engine.attach(player)
    
        let bus = 0
        let inputFormat = input.inputFormat(forBus: bus)
      
        var streamDescription = AudioStreamBasicDescription()
        streamDescription.mSampleRate = 8000.0
        streamDescription.mFormatID = kAudioFormatLinearPCM
        streamDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger // no endian flag means little endian
        streamDescription.mBytesPerPacket = 2
        streamDescription.mFramesPerPacket = 1
        streamDescription.mBytesPerFrame = 2
        streamDescription.mChannelsPerFrame = 1
        streamDescription.mBitsPerChannel = 16
        streamDescription.mReserved = 0
        
        let outputFormat = AVAudioFormat(streamDescription: &streamDescription)!
        
        guard let converter: AVAudioConverter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
            print("Can't convert in to this format")
            return
        }

        engine.connect(player, to: engine.mainMixerNode, format: inputFormat)
        
        input.installTap(onBus: bus, bufferSize: 640, format: inputFormat) { (buffer, time) -> Void in
            // play buffer
            
            
            var newBufferAvailable = true
            
            let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                if newBufferAvailable {
                    outStatus.pointee = .haveData
                    newBufferAvailable = false
                    return buffer
                } else {
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }
            
            let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate))!
            
            var error: NSError?
            let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
            assert(status != .error)
            
            print("Converted buffer format:", convertedBuffer.format)
            
            print("buffer is \(buffer.format)")
            let bufferData = self.audioBufferToNSData(PCMBuffer: buffer)
            let originalValues = Array(bufferData)
            print("uint8 = \(originalValues)")
            let Buffer = self.dataToPCMBuffer(format: inputFormat, data: bufferData)
//            let Buffer16  =  self.dataToAudioBuffer(data: bufferData)
            print("buffer 16 is \(Buffer.format)")
            player.scheduleBuffer(Buffer)
        }

        try! engine.start()
        player.play()
        
    }
    
    func audioBufferToNSData(PCMBuffer: AVAudioPCMBuffer) -> NSData {
        let channelCount = 1  // given PCMBuffer channel count is 1
        let channels = UnsafeBufferPointer(start: PCMBuffer.int16ChannelData, count: channelCount)
        let data = NSData(bytes: channels[0], length:Int(PCMBuffer.frameLength * PCMBuffer.format.streamDescription.pointee.mBytesPerFrame))

        return data
    }

    func dataToPCMBuffer(format: AVAudioFormat, data: NSData) -> AVAudioPCMBuffer {
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: format,
                                           frameCapacity: UInt32(data.length) / format.streamDescription.pointee.mBytesPerFrame)

        audioBuffer!.frameLength = audioBuffer!.frameCapacity
        let channels = UnsafeBufferPointer(start: audioBuffer!.floatChannelData, count: Int(audioBuffer!.format.channelCount))
        data.getBytes(UnsafeMutableRawPointer(channels[0]) , length: data.length)
        return audioBuffer!
    }
   
    func dataToAudioBuffer(data: NSData) -> AVAudioPCMBuffer {
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false)!
            let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(data.count)/2)
        audioBuffer!.frameLength = audioBuffer!.frameCapacity
            for i in 0..<data.count/2 {
                // transform two bytes into a float (-1.0 - 1.0), required by the audio buffer
                audioBuffer?.floatChannelData?.pointee[i] = Float(Int16(data[i*2+1]) << 8 | Int16(data[i*2]))/Float(INT16_MAX)
            }
            
            print("\(#file) > \(#function) > Values: data: \(data)")
        return audioBuffer!
        }
    
}


