//
//  ViewController.swift
//  iProntuário
//
//  Created by Narlei A Moreira on 05/03/20.
//  Copyright © 2020 NarleiMoreira. All rights reserved.
//

import Speech
import UIKit

class ViewController: UIViewController {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @IBOutlet var textView: UITextView!
    @IBOutlet var microphoneButton: UIButton!

    @IBAction func pressRecord(sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        microphoneButton.isEnabled = false

        speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { authStatus in

            var isButtonEnabled = false

            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                print("A")
            }

            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }

    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in

            var isFinal = false

            if let result = result {
                self.textView.text = self.processText(text: result.bestTranscription.formattedString)

                print("Reconhecido: \(result.bestTranscription.formattedString)")
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.microphoneButton.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        textView.text = "Say something, I'm listening!"
    }

    func processText(text: String) -> String {
        let arrayWeight = ["peso", "quilos", "quilograma", "kg"]
        let currentWeight: Double? = getValueFromSufix(arraySufix: arrayWeight, text: text)
        
        let arrayHeightMeter = ["metros","m"]
        let currentHeightMeter: Double? = getValueFromSufix(arraySufix: arrayHeightMeter, text: text)
        
        let arrayHeightCm = ["centimetros","cm"]
        let currentHeightCm: Double? = getValueFromSufix(arraySufix: arrayHeightCm, text: text)
        
        let arraySymptoms = ["sintomas","sintoma"]
        let currentSymptoms: String? = getValueFromPrefix(arraySufix: arraySymptoms, text: text)

        return "Achamos o peso = \(currentWeight ?? 0)\nAchamos a altura = \(currentHeightMeter ?? 0),\(currentHeightCm ?? 0)\nAchamos os sintomas = \(currentSymptoms ?? "")"
    }

    func getValueFromSufix<T>(arraySufix: [String], text: String) -> T? {
        let arrayWords = text.components(separatedBy: " ")
        for i in 0 ..< arrayWords.count {
            let word = arrayWords[i]
            let clearWord = word.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            if arraySufix.contains(clearWord) { // Achou o peso
                let index = i - 1 // Descarta a palavra atual
                for j in (0 ... index).reversed() {
                    let jWord = arrayWords[j]
                    if T.self is Double.Type {
                        if let intWeight = Double(jWord) {
                            return intWeight as? T
                        }
                    }
                    if T.self is String.Type {
                        return jWord as? T
                    }
                }
            }
        }
        return nil
    }
    
    func getValueFromPrefix<T>(arraySufix: [String], text: String) -> T? {
        let arrayWords = text.components(separatedBy: " ")
        for i in 0 ..< arrayWords.count {
            let word = arrayWords[i]
            let clearWord = word.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            if arraySufix.contains(clearWord) { // Achou o peso
                let index = i + 1 // Descarta a palavra atual
                for j in (index ..< arrayWords.count) {
                    let jWord = arrayWords[j]
                    if T.self is Double.Type {
                        if let intWeight = Double(jWord) {
                            return intWeight as? T
                        }
                    }
                    if T.self is String.Type {
                        return jWord as? T
                    }
                }
            }
        }
        return nil
    }
}

extension ViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
}



