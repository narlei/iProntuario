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
        let viewController = MachineLearning()
        let text = "apresenta os sintomas febre e alergia ."
        let arraySymptoms = ["sintomas","sintoma"]
        let currentSymptoms: [String]? = viewController.getValueFromPrefix(type: String.self, arraySufix: arraySymptoms, text: text, delimiter: ".")
        print(currentSymptoms)
    }
}
