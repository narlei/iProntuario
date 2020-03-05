//
//  MachineLearning.swift
//  iProntuario
//
//  Created by Narlei A Moreira on 05/03/20.
//  Copyright © 2020 NarleiMoreira. All rights reserved.
//

import Foundation

class MachineLearning {
    
    let arrayIgnoredExpressions = ["de","e","o","a","os","as",""," "]
    
    func processText(text: String) -> [String: Any?] {
        var cleanText = text.replacingOccurrences(of: ".", with: " . ")
        cleanText = cleanText.replacingOccurrences(of: ",", with: " . ")
        
        let arrayWeight = ["peso", "quilos", "quilograma", "kg"]
        let currentWeight: Double? = getValueFromSufix(arraySufix: arrayWeight, text: cleanText)

        let arrayHeightMeter = ["metros", "m", "metro"]
        let currentHeightMeter: Double? = getValueFromSufix(arraySufix: arrayHeightMeter, text: cleanText)

        let arrayHeightCm = ["centimetros", "cm"]
        let currentHeightCm: Double? = getValueFromSufix(arraySufix: arrayHeightCm, text: cleanText)

        let arraySymptoms = ["sintomas", "sintoma"]
        let currentSymptoms: [String]? = getValueFromPrefix(type: String.self, arraySufix: arraySymptoms, text: cleanText, delimiter: ".")
        
        let arrayLeft = ["liberado", "alta"]
        let currentLeft: [String]? = getValueFromPrefix(type: String.self, arraySufix: arrayLeft, text: cleanText, delimiter: nil)
        
        
        let dicReturn = [
            "weight": ["value": currentWeight ?? 0, "unit": "kg"],
            "height": ["value": ((currentHeightMeter ?? 0) * 100) + (currentHeightCm ?? 0), "unit": "cm"],
            "symptoms": currentSymptoms,
            "full_text": text,
            "left_day": currentLeft
        ] as [String: Any?]
        
        return dicReturn
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

    func getValueFromPrefix<T>(type: T.Type, arraySufix: [String], text: String, delimiter: String?) -> [T]? {
        var returnValues = [T]()

        let arrayWords = text.components(separatedBy: " ")
        for i in 0 ..< arrayWords.count {
            let word = arrayWords[i]
            let clearWord = word.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            if arraySufix.contains(clearWord) { // Achou o peso
                let index = i + 1 // Descarta a palavra atual
                for j in index ..< arrayWords.count {
                    let jWord = arrayWords[j]
                    if T.self is Double.Type {
                        if let intWeight = Double(jWord) {
                            return [intWeight as! T]
                        }
                    }
                    if T.self is String.Type {
                        if arrayIgnoredExpressions.contains(jWord) {
                            continue
                        }
                        if let delimiter = delimiter {
                            if delimiter.trim() == jWord.trim() {
                                return returnValues
                            }
                            returnValues.append(jWord as! T)
                        } else {
                            return [jWord as! T]
                        }
                    }
                }
            }
        }
        return nil
    }
}

extension String {
    func trim() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
}
