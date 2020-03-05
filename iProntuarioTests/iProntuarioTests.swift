//
//  iProntuarioTests.swift
//  iProntuarioTests
//
//  Created by Narlei A Moreira on 05/03/20.
//  Copyright © 2020 NarleiMoreira. All rights reserved.
//

import XCTest
@testable import iProntuario

class iProntuarioTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let ml = MachineLearning()
        let text = "O paciente tem 1 metro e 90 cm. Pesa aprox 98 kg. Apresenta os sintomas febre e alergia. Acredito que terá alta hoje"
        let arraySymptoms = ["sintomas","sintoma"]
        let currentSymptoms: [String]? = ml.getValueFromPrefix(type: String.self, arraySufix: arraySymptoms, text: text, delimiter: nil)
        print(currentSymptoms)
        let processed = ml.processText(text: text)
        print(processed)
    }
}
