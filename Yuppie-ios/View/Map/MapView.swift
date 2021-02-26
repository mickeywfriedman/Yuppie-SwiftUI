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
        self.title = ""
        self.coordinate = coordinate
    }
}


struct MapView: UIViewRepresentable {
    @State var annotations: [MGLPointAnnotation]
    @Binding var buildings: [Building]
    @Binding var index: Int
    @State var newIndex: Int = 0
    @State var mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/leonyuppie/ckfysprwo0l3n19qpi7hm8m8p"))
    
    // MARK: - Configuring UIViewRepresentable protocol
    
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
        Coordinator(self)
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
        updateAnnotations()
        mapView.centerCoordinate =  coordinates(latitude: buildings[index].latitude, longitude: buildings[index].longitude)
        if ((index != newIndex)){
            moveToCoordinate(mapView, to: CLLocationCoordinate2D(latitude: Double(buildings[index].latitude), longitude: Double(buildings[index].longitude)))
        }
    }
    func moveToCoordinate(_ mapView: MGLMapView, to point: CLLocationCoordinate2D) {
        print(point)
        print("hello")
        let camera = MGLMapCamera(lookingAtCenter: point, fromDistance: 4500, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 4,
                    peakAltitude: 3000, completionHandler: nil)
        self.newIndex = index
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
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        init(_ control: MapView) {
            self.control = control
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
        
        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
        peakAltitude: 300, completionHandler: nil)
        }
        
        
        
    }
    class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
    super.layoutSubviews()
     
    // Use CALayer’s corner radius to turn this view into a circle.
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
    layer.borderWidth = selected ? bounds.width / 10 : 2
    layer.add(animation, forKey: "borderWidth")
    }
    
    
    
}
}

