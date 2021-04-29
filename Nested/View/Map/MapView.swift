//
//  MapView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import SwiftUI
import Mapbox

extension MGLPointAnnotation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
}


struct MapView: UIViewRepresentable {
    @Binding var buildings: [Building]
    @Binding var index: Int
    @State var newIndex: Int = 0
    @Binding var user: User
    @Binding var first : Bool
    @State var mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/leonyuppie/ckfysprwo0l3n19qpi7hm8m8p"))
    // MARK: - Configuring UIViewRepresentable protocol
    func annotations () -> [MGLPointAnnotation]{
        var result = [MGLPointAnnotation(coordinate: .init(latitude: 40.761295318603516, longitude: -73.99922180175781))]
        var favorites = [MGLPointAnnotation(coordinate: .init(latitude: 40.761295318603516, longitude: -73.99922180175781))]
        for building in filteredBuildings() {
            result.append(MGLPointAnnotation(coordinate: .init(latitude: Double(building.latitude), longitude: Double(building.longitude))))
            if user.favorites.contains(building.id){
                favorites.append(MGLPointAnnotation(coordinate: .init(latitude: Double(building.latitude), longitude: Double(building.longitude))))
            }
        }
        result.removeFirst(1)
        favorites.removeFirst(1)
        return result
        return favorites
    }
    
    func filter(units: [Unit], buildingAmenities: [String]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms-1 >= user.preferences.bathrooms && Int(unit.price) <= Int(user.preferences.price) && date_avail ?? Date() < dateFormat(string: user.preferences.latestMoveInDate)){
                for amenity in user.preferences.amenities {
                    if (!buildingAmenities.contains(amenity)){
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    func filteredBuildings() -> [Building]{
        return buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)})
    }
    
    func favoritedBuildings() -> [String]{
        return user.favorites
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.compassView.isHidden = true
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        return mapView
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self, index: $index, buildings: filteredBuildings())
    }
    

    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate =  centerCoordinate
        return self
    }
    func zoomLevel(_ zoomLevel: Double) -> MapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        makeCoordinator()
        updateAnnotations()
        if (index < filteredBuildings().count && (first == false)) {
            moveToCoordinate(mapView, to: CLLocationCoordinate2D(latitude: Double(filteredBuildings()[index].latitude), longitude: Double(filteredBuildings()[index].longitude)))
        }
    }
    func moveToCoordinate(_ mapView: MGLMapView, to point: CLLocationCoordinate2D) {
        let camera = MGLMapCamera(lookingAtCenter: point, fromDistance: 4500, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 4,
                    peakAltitude: 3000, completionHandler: nil)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = point
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        //mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        
    }
    func coordinates(latitude: Float, longitude: Float) -> CLLocationCoordinate2D {
        let lat = Double(latitude) as! CLLocationDegrees
        let lon = Double(longitude) as! CLLocationDegrees
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations())
        
    }
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        var index: Binding<Int>
        var buildings: [Building]
        init(_ control: MapView, index : Binding<Int>, buildings: [Building]) {
            self.control = control
            self.index = index
            self.buildings = buildings
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            let coordinates = [
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
            ]
            
            let buildingFeature = MGLPolygonFeature(coordinates: coordinates, count: 5)
            let shapeSource = MGLShapeSource(identifier: "buildingSource", features: [buildingFeature], options: nil)
            mapView.style?.addSource(shapeSource)
          

        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            // This example is only concerned with point annotations.
            guard annotation is MGLPointAnnotation else {
            return nil
            }
             
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
             
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
             
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
                annotationView!.backgroundColor = UIColor(red: 0.7882, green: 0.498, blue: 0.8784, alpha: 1.0)
            }
             
            return annotationView
        }
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        func getCurrentIndex(latitude: Double, longitude: Double) -> Int {
            var currentIndex = 0
            var index = 0
            for building in buildings {
                if Double(building.latitude) != latitude || Double(building.longitude) != longitude{
                    currentIndex += 1
                } else{
                    index = currentIndex
                    print(index)
                }
            }
            return index
        }
        
        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
            self.index.wrappedValue = getCurrentIndex(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 0)
            mapView.fly(to: camera, withDuration: 4,
            peakAltitude: 3000, completionHandler: nil)
            mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        }
        
        
        
    }
    class CustomAnnotationView: MGLAnnotationView {
        
    override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = bounds.width / 2
    layer.borderWidth = 6
   
    layer.borderColor = UIColor.white.cgColor
        layer.addPulse { builder in
            builder.repeatCount = 10
        }
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        
    super.setSelected(selected, animated: animated)
    
    // Animate the border width in/out, creating an iris effect.
    let animation = CABasicAnimation(keyPath: "borderWidth")
    animation.duration = 0.1
        layer.backgroundColor = selected ? UIColor(red: 0.498, green: 0.8588, blue: 0.8235, alpha: 1.0).cgColor: UIColor(red: 0.7882, green: 0.498, blue: 0.8784, alpha: 1.0).cgColor
   // layer.borderWidth = selected ? bounds.width / 100 : 2
   // layer.add(animation, forKey: "borderWidth")
    }
    
    
    
}
}

