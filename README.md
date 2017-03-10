# LocalSearchManager

A MKLocalSearchCompleter and MKLocalSearch manage writen in Swift.

LocalSearchManager uses Carthage for distribution.

LocalSearchManager is available on iOS and requires 9.3

## To install this framework

Add Carthage files to .gitignore #Carthage Carthage/Build

Check your Carthage Version to make sure Carthage is installed locally: Carthage version

Create a CartFile to manage your dependencies: Touch CartFile

Open the Cartfile and add this as a dependency. (in OGDL): github "sevenapps/LocalSearchManager" "master"

Update your project to include the framework: Carthage update --platform iOS

Add the framework to 'Linked Frameworks and Libraries' in the Xcode Project by dragging and dropping the framework created in Carthage/Build/iOS/LocalSearchManager.framework

Add this run Script /usr/local/bin/carthage copy-frameworks

Add this input file to the run script $(SRCROOT)/Carthage/Build/iOS/LocalSearchManager.framework

If Xcode has issues finding your framework Add $(SRCROOT)/Carthage/Build/iOS To 'Framework Search Paths' in Build Settings

## To use this framework

Initilize this manager by conforming to its delegate, and setting a searchSpan the center coordinate of the search region is set when starting the search request.

*UpdateSearchRequest* will callBack *searchCompleter(returnedResults)* with a list of the found results matching a query fragement in real time.
    
 Once you have a result you'd like to grab the exact location of, call *findExactLocation* which will call back *localSearch(ReturnedMapItems)* 
