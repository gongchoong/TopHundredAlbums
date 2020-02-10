//
//  ApiServiceTests.swift
//  TopHundredAlbumsTests
//
//  Created by chris davis on 2/9/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import XCTest
@testable import TopHundredAlbums

class ApiServiceTests: XCTestCase {
    
    var sut: ApiService?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ApiService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testFetchTopHundredAlbums(){
        //Given
        guard let sut = sut else {return}
        //When
        let expect = XCTestExpectation(description: "succeefully fetched data")
        sut.fetchTopHundredAlbums { (success, albums, error) in
            expect.fulfill()
            //Assert
            for album in albums{
                XCTAssertNotNil(album.albumName)
                XCTAssertNotNil(album.albumArt)
                XCTAssertNotNil(album.artistName)
                XCTAssertNotNil(album.copyright)
                XCTAssertNotNil(album.genres)
                XCTAssertNotNil(album.releaseDate)
            }
            XCTAssertEqual(albums.count, 100)
        }
        wait(for: [expect], timeout: 5.0)
    }
}
