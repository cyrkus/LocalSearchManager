//
//  LocalSearchManager.swift
//  Pods
//
//  Created by Aaron Dean Bikis on 3/9/17.
//
//

import UIKit
import MapKit
import CoreLocation

public protocol LocalSearchManagerDelegate: class {
    func searchCompleter(returnedResults results:[MKLocalSearchCompletion])
    func localSearch(returnedMapItems mapItems:[MKMapItem])
}
/**
    A MKLocalSearchCompleter and MKLocalSearch manager.
    Initilize this manager by conforming to its delegate, and setting a searchSpan the center coordinate of the search region is set when starting the search request.
    *UpdateSearchRequest* will callBack *searchCompleter(returnedResults)* with a list of the found results matching a query fragement in real time.
    Once you have a result you'd like to grab the exact location of, call *findExactLocation* which will call back *localSearch(ReturnedMapItems)* with an *Array<MKMapItem>*
*/

public final class LocalSearchManager: NSObject, MKLocalSearchCompleterDelegate {
    
    public var searchCompleter: MKLocalSearchCompleter!
    
    weak var delegate: LocalSearchManagerDelegate!
    
    public var searchResults: [MKLocalSearchCompletion]?
    
    public var searchSpan: MKCoordinateSpan
    
    public var searchCenter: CLLocationCoordinate2D!
    
    public init(delegate:LocalSearchManagerDelegate, searchSpan: MKCoordinateSpan){
        self.delegate = delegate
        self.searchSpan = searchSpan
        super.init()
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
    }
    
    /*
    Fetchs local results based of the set searchSpan and the passed in searchCenter. These results will callback in realtime.
    **/
    public func updateSearchRequest(withQuery queryFragment:String, searchCenter: CLLocationCoordinate2D) {
        self.searchCenter = searchCenter
        searchCompleter.region = getRegionForLocalSearch()
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: SearchCompleterDelegate
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        delegate.searchCompleter(returnedResults: completer.results)
    }
    
    //MARK: Searching Updates
    /* 
     Finds an exact location or exact locations of a result. 
     i.e. a result with title "Starbucks" and no subtitle will probably return many mapItems
     whereas a result with title "Starbucks" and a subtitle with an address will probably return one.
    **/
    public func findExactLocation(forResult result: MKLocalSearchCompletion){
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = result.title.appending(result.subtitle)
        searchRequest.region = getRegionForLocalSearch()
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return }
            guard response != nil else { return }
            self.delegate.localSearch(returnedMapItems: response!.mapItems)
        }
    }
    
    private func getRegionForLocalSearch() -> MKCoordinateRegion {
        return MKCoordinateRegionMake(searchCenter, searchSpan)
    }
}
