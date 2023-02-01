//
//  HomeVC.swift
//  doorbirdDemo
//
//  Created by Admin on 29/01/2023.
//

import UIKit
import AVFAudio
import AVFoundation

protocol HomeViewProtocol: LoadingViewCapable {
    func passinfos(with infos: [NotificationModel])
    func showError(with message: String)
}

class HomeVC: UIViewController, AVAudioRecorderDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,PresentableAlert {

    
    // MARK: - Properties
    var presenter: HomeProtocol?
    let token = "335a1a50b9a7ce81bd5b0b41d250c3e296bc6b1832fbbf16b07cd49c90c4931e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//     testSound()
        presenter?.fetchInfo(token: token)
        
    }
    
  
    func startRecord() {
       let audioEngine = AVAudioEngine()
        let bus = 0
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: bus)
        
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
        
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { (buffer, time) in
            print("Buffer format: \(buffer.format)")
            
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
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Can't start the engine: \(error)")
        }
        
    }
    
    
    var audioPlayer = AVAudioPlayer()
//    let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Barcode-scanner-beep-sound", ofType: "mp3")!) // If sound not in an assest
     //let alertSound = NSDataAsset(name: "CheckoutScannerBeep") // If sound is in an Asset

  

//    func testSound(){
//
//        do {
//            //     audioPlayer = try AVAudioPlayer(data: (alertSound!.data), fileTypeHint: AVFileTypeMPEGLayer3) //If in asset
//            audioPlayer = try AVAudioPlayer(contentsOf: alertSound as URL) //If not in asset
//            audioPlayer.numberOfLoops = 50
//            audioPlayer.pan = -1.0 //left headphone
//            audioPlayer.pan = 1.0 // right headphone
//            audioPlayer.prepareToPlay() // make sure to add this line so audio will play
//            audioPlayer.play()
//           
//        } catch  {
//            print("error")
//        }
//    }
    

}




extension HomeVC: HomeViewProtocol {
    func passinfos(with infos: [NotificationModel]) {
        print(infos)
    }
    
 
    func showError(with message: String) {
        showAlert(with: message)
    }
    
}
