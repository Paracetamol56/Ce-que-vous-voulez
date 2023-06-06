//
//  MapView.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation
import SwiftUI
import MapKit

extension MKPointAnnotation: Identifiable { }

struct TheaterMapView: View {
    @State private var locationManager: LocationManager = .init()
    @State private var mapRegion: MKCoordinateRegion =
        .init(center: .init(latitude: 0, longitude: 0),
          latitudinalMeters: 600,
          longitudinalMeters: 600
        )
    @State private var movieTheaterAnnotations: [MKPointAnnotation] = []
    
    var body: some View {
        Map(
            coordinateRegion: $mapRegion,
            showsUserLocation: true,
            annotationItems: movieTheaterAnnotations
        ) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                ZStack {
                    Image(systemName: "film.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                        .shadow(radius: 4)
                    
                    Text(annotation.title ?? "")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .offset(y: 30)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            locationManager.authorize()
        }
        .onReceive(locationManager.$currentPosition) { newLocation in
            guard let newLocation else { return }
            withAnimation {
                mapRegion.center = newLocation.coordinate
            }
            searchForMovieTheaters(region: mapRegion) { annotations in
                movieTheaterAnnotations = annotations
            }
        }
    }
    
    func searchForMovieTheaters(region: MKCoordinateRegion, completion: @escaping ([MKPointAnnotation]) -> Void) {
        let searchRequest = MKLocalPointsOfInterestRequest(coordinateRegion: region)
        // searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory.movieTheater])
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let mapItems = response?.mapItems else {
                completion([])
                return
            }
            
            let annotations = mapItems.map { mapItem -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                return annotation
            }
            
            completion(annotations)
        }
    }
}

struct TheaterMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TheaterMapView()
        }
        .environment(\.sizeCategory, .large)
    }
}


class LocationManager: NSObject, ObservableObject {
    private var manager: CLLocationManager
    @Published var currentPosition: CLLocation?
    
    override init() {
        manager = .init()
        super.init()
        manager.delegate = self
        
    }
    
    func authorize() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = 10
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentPosition = locations.first
    }
}
