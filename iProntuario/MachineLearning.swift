//
//  MachineLearning.swift
//  iProntuario
//
//  Created by Narlei A Moreira on 05/03/20.
//  Copyright © 2020 NarleiMoreira. All rights reserved.
//

import Foundation

class MachineLearning {
    
    let arrayIgnoredExpressions = ["de","e","o","a","os","as"]
    
    func processText(text: String) -> String {
        let arrayWeight = ["peso", "quilos", "quilograma", "kg"]
        let currentWeight: Double? = getValueFromSufix(arraySufix: arrayWeight, text: text)

        let arrayHeightMeter = ["metros", "m"]
        let currentHeightMeter: Double? = getValueFromSufix(arraySufix: arrayHeightMeter, text: text)

        let arrayHeightCm = ["centimetros", "cm"]
        let currentHeightCm: Double? = getValueFromSufix(arraySufix: arrayHeightCm, text: text)

        let arraySymptoms = ["sintomas", "sintoma"]
        let currentSymptoms: [String]? = getValueFromPrefix(type: String.self, arraySufix: arraySymptoms, text: text, delimiter: ".")

        return "Achamos o peso = \(currentWeight ?? 0)\nAchamos a altura = \(currentHeightMeter ?? 0),\(currentHeightCm ?? 0)\nAchamos os sintomas = \(currentSymptoms ?? [""])"
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
