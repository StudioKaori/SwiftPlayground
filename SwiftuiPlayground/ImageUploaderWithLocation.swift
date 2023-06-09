//
//  ImageUploaderWithLocation.swift
//  SwiftuiPlayground
//
//  Created by Kaori Persson on 2023-04-10.
//https://www.felixlarsen.com/blog/photo-metadata-phpickerview
import SwiftUI
import MapKit


struct ImageUploaderWithLocation: View {
  static let dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
  }()
  
  @State var showSheet = false
  @State var selectedImage: UIImage?
  @State var date: Date?
  @State var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 20.0,
      longitude: 20.0),
    latitudinalMeters: .init(10000),
    longitudinalMeters: .init(10000))
  @State var locationName: String = ""
  
  
  
  func getLocationName(for coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      guard let placemark = placemarks?.first else {
        completion(nil)
        return
      }
      var locationName = ""
      if let name = placemark.name {
        locationName += name
      }
      if let locality = placemark.locality {
        locationName += locationName.isEmpty ? locality : ", " + locality
      }
      if let country = placemark.country {
        locationName += locationName.isEmpty ? country : ", " + country
      }
      completion(locationName)
    }
  }
  
  
  var body: some View {
    let regionWithOffset = Binding<MKCoordinateRegion>(
      get: {
        let offsetCenter = CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta * 0.30, longitude: region.center.longitude)
        return MKCoordinateRegion(
          center: offsetCenter,
          span: region.span)
      },
      set: {
        $0
      }
    )
    return ZStack {
      Map(coordinateRegion: regionWithOffset,
          interactionModes: MapInteractionModes.all,
          showsUserLocation: false,
          annotationItems: [region.center]) {
        l in
        MapPin(coordinate: l)
      }
      VStack {
        if let date = date {
          Text("\(date, formatter: Self.dateFormat)")
            .padding(8)
            .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10.0)
            .foregroundColor(.white)
            .padding(8)
          
        }
        if let image = selectedImage {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .padding(8)
          
          Text(self.locationName)
        }
        Spacer()
        Button(action: {
          showSheet.toggle()
        }) {
          Image(systemName: "photo")
          
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .clipShape(Circle())
        .shadow(radius: 10)
        .padding()
      }
      
      
    }.sheet(isPresented: $showSheet) {
      CustomPhotoPickerView(selectedImage: $selectedImage, date: $date, location: $region.center)
    }
    .onChange(of: self.selectedImage) { _ in
      let coordinate = CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta * 0.30, longitude: region.center.longitude)
      getLocationName(for: coordinate) { locationName in
        if let photoLocationName = locationName {
          self.locationName = photoLocationName
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ImageUploaderWithLocation(showSheet: false, selectedImage: image(), date: Date(), region: MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: 20.0,
        longitude: 20.0),
      latitudinalMeters: .init(10000),
      longitudinalMeters: .init(10000)))
  }
  static func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      UIColor.orange.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}

extension CLLocationCoordinate2D: Identifiable, Hashable, Equatable {
  public var id: Int {
    return hashValue
  }
  
  public func hash(into hasher: inout Hasher)  {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }
  
  public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
  }
  
  public static func <(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.longitude < rhs.longitude
  }
}
