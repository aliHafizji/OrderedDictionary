//
//  OrderedDictionaryTests.swift
//  OrderedDictionaryTests
//
//  Created by Lukas Kubanek on 29/08/15.
//  Copyright © 2015 Lukas Kubanek. All rights reserved.
//

import XCTest
import OrderedDictionary

class OrderedDictionaryTests: XCTestCase {
    
    var orderedDictionary: OrderedDictionary<String, Int>!
    
    override func setUp() {
        orderedDictionary = [
            ("A", 1),
            ("B", 2),
            ("C", 3)
        ]
    }
    
    // ======================================================= //
    // MARK: - Content
    // ======================================================= //
    
    func testInitializedContent() {
        XCTAssertEqual(self.orderedDictionary.count, 3)
        
        XCTAssertEqual(self.orderedDictionary["A"], 1)
        XCTAssertEqual(self.orderedDictionary.indexForKey("A"), 0)
        XCTAssertTrue(self.orderedDictionary.containsKey("A"))
        
        XCTAssertEqual(self.orderedDictionary["B"], 2)
        XCTAssertEqual(self.orderedDictionary.indexForKey("B"), 1)
        XCTAssertTrue(self.orderedDictionary.containsKey("B"))
        
        XCTAssertEqual(self.orderedDictionary["C"], 3)
        XCTAssertEqual(self.orderedDictionary.indexForKey("C"), 2)
        XCTAssertTrue(self.orderedDictionary.containsKey("C"))
    }
    
    func testInitializationUsingPairs() {
        let elements = [
            ("A", 1),
            ("B", 2),
            ("C", 3)
        ]
        
        XCTAssertTrue(OrderedDictionary(elements: elements) == self.orderedDictionary)
    }
    
    func testElementsGenerator() {
        for entry in self.orderedDictionary.enumerate() {
            XCTAssertEqual(self.orderedDictionary[entry.index].0, entry.element.0)
            XCTAssertEqual(self.orderedDictionary[entry.index].1, entry.element.1)
        }
    }
    
    func testOrderedKeysAndValues() {
        XCTAssertEqual(self.orderedDictionary.orderedKeys, ["A", "B", "C"])
        XCTAssertEqual(self.orderedDictionary.orderedValues, [1, 2, 3])
    }
    
    // ======================================================= //
    // MARK: - Key-based Modifications
    // ======================================================= //
    
    func testKeyBasedSubscript() {
        self.orderedDictionary["A"] = 5
        self.orderedDictionary["D"] = 10
        self.orderedDictionary["B"] = nil
        
        XCTAssertEqual(self.orderedDictionary.count, 3)
        
        XCTAssertEqual(self.orderedDictionary["A"], 5)
        XCTAssertEqual(self.orderedDictionary.indexForKey("A"), 0)
        XCTAssertTrue(self.orderedDictionary.containsKey("A"))
        
        XCTAssertNil(self.orderedDictionary["B"])
        XCTAssertNil(self.orderedDictionary.indexForKey("B"))
        XCTAssertFalse(self.orderedDictionary.containsKey("B"))
        
        XCTAssertEqual(self.orderedDictionary["C"], 3)
        XCTAssertEqual(self.orderedDictionary.indexForKey("C"), 1)
        XCTAssertTrue(self.orderedDictionary.containsKey("C"))
        
        XCTAssertEqual(self.orderedDictionary["D"], 10)
        XCTAssertEqual(self.orderedDictionary.indexForKey("D"), 2)
        XCTAssertTrue(self.orderedDictionary.containsKey("D"))
    }
    
    // ======================================================= //
    // MARK: - Index-based Modifications
    // ======================================================= //
    
    func testIndexBasedSubscriptForRetrievingValues() {
        let elementAtIndex0 = self.orderedDictionary[0]
        XCTAssertEqual(elementAtIndex0.0, "A")
        XCTAssertEqual(elementAtIndex0.1, 1)
        
        let elementAtIndex1 = self.orderedDictionary[1]
        XCTAssertEqual(elementAtIndex1.0, "B")
        XCTAssertEqual(elementAtIndex1.1, 2)
        
        let elementAtIndex2 = self.orderedDictionary[2]
        XCTAssertEqual(elementAtIndex2.0, "C")
        XCTAssertEqual(elementAtIndex2.1, 3)
    }
    
    func testIndexBasedSubscriptForSettingValues() {
        self.orderedDictionary[0] = ("F", 10)
        self.orderedDictionary[1] = ("B", 5)
        
        let elementAtIndex0 = self.orderedDictionary[0]
        XCTAssertEqual(elementAtIndex0.0, "F")
        XCTAssertEqual(elementAtIndex0.1, 10)
        
        let elementAtIndex1 = self.orderedDictionary[1]
        XCTAssertEqual(elementAtIndex1.0, "B")
        XCTAssertEqual(elementAtIndex1.1, 5)
        
        let elementAtIndex2 = self.orderedDictionary[2]
        XCTAssertEqual(elementAtIndex2.0, "C")
        XCTAssertEqual(elementAtIndex2.1, 3)
    }
    
    func testRetrievingElementAtNonExistentIndex() {
        XCTAssertNil(self.orderedDictionary.elementAtIndex(10))
    }
    
    func testIndexBasedInsertionsOfElementsWithDistinctKeys() {
        self.orderedDictionary.insertElement(("T", 15), atIndex: 0)
        self.orderedDictionary.insertElement(("U", 16), atIndex: 2)
        self.orderedDictionary.insertElement(("V", 17), atIndex: 5)
        self.orderedDictionary.insertElement(("W", 18), atIndex: 2)
        
        let XCTAssertEqualedOrderedDictionary: OrderedDictionary<String, Int> = [
            ("T", 15),
            ("A", 1),
            ("W", 18),
            ("U", 16),
            ("B", 2),
            ("C", 3),
            ("V", 17)
        ]
        
        XCTAssertTrue(self.orderedDictionary == XCTAssertEqualedOrderedDictionary)
    }
    
    func testIndexBasedInsertionOfElementWithSameKeyBeforeItsCurrentIndex() {
        let previousValue = self.orderedDictionary.insertElement(("B", 5), atIndex: 0)
        
        let expectedOrderedDictionary: OrderedDictionary<String, Int> = [
            ("B", 5),
            ("A", 1),
            ("C", 3)
        ]
        
        XCTAssertEqual(self.orderedDictionary.count, 3)
        XCTAssertTrue(self.orderedDictionary == expectedOrderedDictionary)
        XCTAssertEqual(previousValue, 2)
    }
    
    func testIndexBasedInsertionOfElementWithSameKeyAtItsCurrentIndex() {
        let previousValue = self.orderedDictionary.insertElement(("B", 5), atIndex: 1)
        
        let expectedOrderedDictionary: OrderedDictionary<String, Int> = [
            ("A", 1),
            ("B", 5),
            ("C", 3)
        ]
        
        XCTAssertEqual(self.orderedDictionary.count, 3)
        XCTAssertTrue(self.orderedDictionary == expectedOrderedDictionary)
        XCTAssertEqual(previousValue, 2)
    }
    
    func testIndexBasedInsertionOfElementWithSameKeyAfterItsCurrentIndex() {
        let previousValue = self.orderedDictionary.insertElement(("B", 5), atIndex: 3)
        
        let expectedOrderedDictionary: OrderedDictionary<String, Int> = [
            ("A", 1),
            ("C", 3),
            ("B", 5)
        ]
        
        XCTAssertEqual(self.orderedDictionary.count, 3)
        XCTAssertTrue(self.orderedDictionary == expectedOrderedDictionary)
        XCTAssertEqual(previousValue, 2)
    }
    
    // ======================================================= //
    // MARK: - Removal
    // ======================================================= //
    
    func testRemoveAll() {
        self.orderedDictionary.removeAll()
        
        XCTAssertEqual(self.orderedDictionary.count, 0)
    }
    
    func testRemovalForKey() {
        let removedValue1 = self.orderedDictionary.removeValueForKey("A")
        let removedValue2 = self.orderedDictionary.removeValueForKey("K")
        
        XCTAssertEqual(removedValue1, 1)
        XCTAssertNil(removedValue2)
        
        XCTAssertEqual(self.orderedDictionary.count, 2)
        
        XCTAssertNil(self.orderedDictionary["A"])
        XCTAssertNil(self.orderedDictionary.indexForKey("A"))
        
        XCTAssertEqual(self.orderedDictionary["B"], 2)
        XCTAssertEqual(self.orderedDictionary.indexForKey("B"), 0)
        
        XCTAssertEqual(self.orderedDictionary["C"], 3)
        XCTAssertEqual(self.orderedDictionary.indexForKey("C"), 1)

    }
    
    func testRemovalAtIndex() {
        let removedElement1 = self.orderedDictionary.removeAtIndex(1)
        let removedElement2 = self.orderedDictionary.removeAtIndex(0)
        let removedElement3 = self.orderedDictionary.removeAtIndex(5)
        
        XCTAssertEqual(removedElement1?.0, "B")
        XCTAssertEqual(removedElement1?.1, 2)
        
        XCTAssertEqual(removedElement2?.0, "A")
        XCTAssertEqual(removedElement2?.1, 1)
        
        XCTAssertNil(removedElement3)
        
        XCTAssertEqual(self.orderedDictionary.count, 1)
        
        let elementAtIndex0 = self.orderedDictionary[0]
        XCTAssertEqual(elementAtIndex0.0, "C")
        XCTAssertEqual(elementAtIndex0.1, 3)
    }
    
    func testSort() {
        self.orderedDictionary.sort {(item1, item2) in
            return item1.0 > item2.0
        }
        
        let expectedOrderedDictionary: OrderedDictionary<String, Int> = [
            ("C", 3),
            ("B", 2),
            ("A", 1)
        ]
        
        XCTAssertTrue(self.orderedDictionary == expectedOrderedDictionary)
    }
    
    // ======================================================= //
    // MARK: - Description
    // ======================================================= //
    
    func testDescription() {
        XCTAssertEqual(self.orderedDictionary.description, "[A: 1, B: 2, C: 3]")
    }
    
}
