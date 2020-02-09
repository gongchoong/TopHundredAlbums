//
//  TopHundredAlbumsTests.swift
//  TopHundredAlbumsTests
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import XCTest
@testable import TopHundredAlbums

class TopHundredAlbumsTests: XCTestCase {
    
    var sut: MainViewModel?
    var mockApiService: MockApiService?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        //inject MockApiService into MainViewModel for testing
        mockApiService = MockApiService()
        guard let mockApi = mockApiService else {return}
        sut = MainViewModel(mockApi)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockApiService = nil
        super.tearDown()
    }

    func testFetchAlbum() {
        //check whether MainViewModel.fetch is called or not
        guard let sut = sut, let mockApi = mockApiService else {return}
        //Given
        mockApi.albums = [Album]()
        //When
        sut.fetch()
        //Assert
        XCTAssert(mockApi.isFetchCalled)
    }
    
    func testFetchAlbumFailure(){
        //test when MainViewModel.fetch failed
        guard let sut = sut, let mockApi = mockApiService else {return}
        //Given
        let error = ApiServiceError.dataFetchError
        
        //When
        sut.fetch()
        mockApi.fail(error)
        
        //Assert
        XCTAssertEqual(error.localizedDescription, sut.errorMessage)
    }
    
    func testIfTableviewIsRefreshed(){
        //test whether tableview is reloaded when data loading is finished
        guard let sut = sut, let mockApi = mockApiService, let url = URL(string: RSSURL) else {return}
        let expection = XCTestExpectation(description: "tableview is refreshed")
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let dataResponse = data else {
                fatalError("download error")
            }
            do {
                //Given
                let downloadedAlbum = try JSONDecoder().decode(TopHundredAlbums.self, from: dataResponse)
                let albums = downloadedAlbum.feed.albums
                mockApi.albums = albums
                sut.tableViewReloadClosure = { () in
                    expection.fulfill()
                }
                
                //When
                sut.fetch()
                mockApi.successful()
                
            }catch let error{
                fatalError(error.localizedDescription)
            }
            
        }
        task.resume()
        
        wait(for: [expection], timeout: 5.0)
    }
    
    func testIfAlbumCellViewModelsAreGenerated(){
        //test whether album cell view models are generated when data loading is finisehd
        guard let sut = sut, let mockApi = mockApiService, let url = URL(string: RSSURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let dataResponse = data else {
                fatalError("download error")
            }
            do {
                //Given
                let downloadedAlbum = try JSONDecoder().decode(TopHundredAlbums.self, from: dataResponse)
                let albums = downloadedAlbum.feed.albums
                mockApi.albums = albums
                
                //When
                sut.fetch()
                mockApi.successful()
                
                //Assert
                XCTAssertEqual(albums.count, sut.numberOfCells)
                
            }catch let error{
                fatalError(error.localizedDescription)
            }
            
        }
        task.resume()
    }

}

class MockApiService: ApiServiceProtocol {
    var isFetchCalled = false
    
    var albums = [Album]()
    var completeClosure: ((Bool, [Album], ApiServiceError?)->())?
    
    func fetchTopHundredAlbums(_ completion: @escaping (_ fetchSuccess: Bool, _ albums: [Album], _ error: ApiServiceError?) -> ()) {
        isFetchCalled = true
        completeClosure = completion
    }
    
    func successful(){
        completeClosure?(true, albums, nil)
    }
    
    func fail(_ error: ApiServiceError?){
        completeClosure?(false, albums, error)
    }
}
