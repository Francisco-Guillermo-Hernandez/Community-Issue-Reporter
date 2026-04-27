//
//  CanadaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let canada = Country(id: 1, name: "Canada", regions: [
    Region(id: 1, name: "Ontario", cities: [
        City(id: 1, name: "Toronto", legalName: "Toronto county", isCapital: false, coordinates: .init(lat: 43.60019, lng: -79.50527)),
        City(id: 2, name: "Ottawa", legalName: "", isCapital: false, coordinates: .init(lat: 45.41117, lng: -75.69812)),
        City(id: 3, name: "Mississauga", legalName: "Peel", isCapital: false, coordinates: .init(lat: 43.5789, lng: -79.6583)),
        City(id: 4, name: "Brampton", legalName: "Peel", isCapital: false, coordinates: .init(lat: 43.68341, lng: -79.76633)),
        City(id: 5, name: "Hamilton", legalName: "", isCapital: false, coordinates: .init(lat: 43.25011, lng: -79.84963)),
        City(id: 6, name: "London", legalName: "Middlesex County", isCapital: false, coordinates: .init(lat: 42.98339, lng: -81.23304)),
        City(id: 7, name: "Markham", legalName: "York", isCapital: false, coordinates: .init(lat: 43.86682, lng: -79.2663)),
        City(id: 8, name: "Vaughan", legalName: "York", isCapital: false, coordinates: .init(lat: 43.8361, lng: -79.49827)),
        City(id: 9, name: "Kitchener", legalName: "Regional Municipality of Waterloo", isCapital: false, coordinates: .init(lat: 43.42537, lng: -80.5112)),
        City(id: 10, name: "Windsor", legalName: "Essex County", isCapital: false, coordinates: .init(lat: 42.30008, lng: -83.01654)),
    ]),
    Region(id: 2, name: "Quebec", cities: [
        City(id: 1, name: "Montreal", legalName: "Montréal", isCapital: false, coordinates: .init(lat: 45.45286, lng: -73.64918)),
        City(id: 2, name: "Quebec City", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Laval", legalName: "", isCapital: false, coordinates: .init(lat: 45.56995, lng: -73.692)),
        City(id: 4, name: "Gatineau", legalName: "Outaouais", isCapital: false, coordinates: .init(lat: 45.47723, lng: -75.70164)),
        City(id: 5, name: "Longueuil", legalName: "Montérégie", isCapital: false, coordinates: .init(lat: 45.5152, lng: -73.46818)),
        City(id: 6, name: "Sherbrooke", legalName: "Estrie", isCapital: false, coordinates: .init(lat: 45.40008, lng: -71.89908)),
        City(id: 7, name: "Lévis", legalName: "Chaudière-Appalaches", isCapital: false, coordinates: .init(lat: 46.80326, lng: -71.17793)),
        City(id: 8, name: "Saguenay", legalName: "Saguenay/Lac-Saint-Jean", isCapital: false, coordinates: .init(lat: 48.41675, lng: -71.06573)),
        City(id: 9, name: "Trois-Rivières", legalName: "Mauricie", isCapital: false, coordinates: .init(lat: 46.34515, lng: -72.5477)),
        City(id: 10, name: "Terrebonne", legalName: "Lanaudière", isCapital: false, coordinates: .init(lat: 45.70004, lng: -73.64732)),
    ]),
    Region(id: 3, name: "British Columbia", cities: [
        City(id: 1, name: "Vancouver", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.31636, lng: -123.06934)),
        City(id: 2, name: "Surrey", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.10635, lng: -122.82509)),
        City(id: 3, name: "Burnaby", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.26636, lng: -122.95263)),
        City(id: 4, name: "Richmond", legalName: "York", isCapital: false, coordinates: .init(lat: 43.87111, lng: -79.43725)),
        City(id: 5, name: "Abbotsford", legalName: "Fraser Valley Regional District", isCapital: false, coordinates: .init(lat: 49.05798, lng: -122.25257)),
        City(id: 6, name: "Coquitlam", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.26637, lng: -122.76932)),
        City(id: 7, name: "Kelowna", legalName: "Regional District of Central Okanagan", isCapital: false, coordinates: .init(lat: 49.8625, lng: -119.58333)),
        City(id: 8, name: "Langley", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.10107, lng: -122.65883)),
        City(id: 9, name: "Saanich", legalName: "Capital Regional District", isCapital: false, coordinates: .init(lat: 48.6, lng: -123.41667)),
        City(id: 10, name: "Delta", legalName: "Metro Vancouver Regional District", isCapital: false, coordinates: .init(lat: 49.14399, lng: -122.9068)),
    ]),
    Region(id: 4, name: "Alberta", cities: [
        City(id: 1, name: "Calgary", legalName: "", isCapital: false, coordinates: .init(lat: 51.05011, lng: -114.08529)),
        City(id: 2, name: "Edmonton", legalName: "", isCapital: false, coordinates: .init(lat: 53.55014, lng: -113.46871)),
        City(id: 3, name: "Red Deer", legalName: "", isCapital: false, coordinates: .init(lat: 52.26682, lng: -113.802)),
        City(id: 4, name: "Lethbridge", legalName: "", isCapital: false, coordinates: .init(lat: 49.69999, lng: -112.81856)),
        City(id: 5, name: "Airdrie", legalName: "", isCapital: false, coordinates: .init(lat: 51.30011, lng: -114.03528)),
        City(id: 6, name: "St. Albert", legalName: "", isCapital: false, coordinates: .init(lat: 53.63344, lng: -113.63533)),
        City(id: 7, name: "Medicine Hat", legalName: "", isCapital: false, coordinates: .init(lat: 50.03928, lng: -110.67661)),
        City(id: 8, name: "Grande Prairie", legalName: "", isCapital: false, coordinates: .init(lat: 55.16667, lng: -118.80271)),
        City(id: 9, name: "Spruce Grove", legalName: "", isCapital: false, coordinates: .init(lat: 53.53344, lng: -113.91874)),
        City(id: 10, name: "Leduc", legalName: "", isCapital: false, coordinates: .init(lat: 53.26682, lng: -113.55201)),
    ]),
    Region(id: 5, name: "Manitoba", cities: [
        City(id: 1, name: "Winnipeg", legalName: "", isCapital: false, coordinates: .init(lat: 49.8844, lng: -97.14704)),
        City(id: 2, name: "Brandon", legalName: "", isCapital: false, coordinates: .init(lat: 49.84692, lng: -99.95306)),
        City(id: 3, name: "Steinbach", legalName: "", isCapital: false, coordinates: .init(lat: 49.52579, lng: -96.68451)),
        City(id: 4, name: "Thompson", legalName: "", isCapital: false, coordinates: .init(lat: 55.7435, lng: -97.85579)),
        City(id: 5, name: "Portage la Prairie", legalName: "", isCapital: false, coordinates: .init(lat: 49.97282, lng: -98.29263)),
    ]),
    Region(id: 6, name: "Saskatchewan", cities: [
        City(id: 1, name: "Saskatoon", legalName: "", isCapital: false, coordinates: .init(lat: 52.13238, lng: -106.66892)),
        City(id: 2, name: "Regina", legalName: "", isCapital: false, coordinates: .init(lat: 50.79146, lng: -104.98006)),
        City(id: 3, name: "Prince Albert", legalName: "", isCapital: false, coordinates: .init(lat: 53.20008, lng: -105.76772)),
        City(id: 4, name: "Moose Jaw", legalName: "", isCapital: false, coordinates: .init(lat: 50.40005, lng: -105.53445)),
        City(id: 5, name: "Swift Current", legalName: "", isCapital: false, coordinates: .init(lat: 50.28337, lng: -107.80135)),
    ]),
    Region(id: 7, name: "Nova Scotia", cities: [
        City(id: 1, name: "Halifax", legalName: "Halifax Regional Municipality", isCapital: false, coordinates: .init(lat: 44.64269, lng: -63.57688)),
        City(id: 2, name: "Dartmouth", legalName: "Halifax Regional Municipality", isCapital: false, coordinates: .init(lat: 44.67134, lng: -63.57719)),
        City(id: 3, name: "Sydney", legalName: "Cape Breton County", isCapital: false, coordinates: .init(lat: 46.1351, lng: -60.1831)),
        City(id: 4, name: "Truro", legalName: "Colchester", isCapital: false, coordinates: .init(lat: 45.36685, lng: -63.26538)),
        City(id: 5, name: "New Glasgow", legalName: "Pictou County", isCapital: false, coordinates: .init(lat: 45.58344, lng: -62.64863)),
    ]),
    Region(id: 8, name: "New Brunswick", cities: [
        City(id: 1, name: "Moncton", legalName: "Westmorland County", isCapital: false, coordinates: .init(lat: 46.09454, lng: -64.7965)),
        City(id: 2, name: "Saint John", legalName: "Saint John County", isCapital: false, coordinates: .init(lat: 45.27076, lng: -66.05616)),
        City(id: 3, name: "Fredericton", legalName: "York County", isCapital: false, coordinates: .init(lat: 45.94541, lng: -66.66558)),
        City(id: 4, name: "Dieppe", legalName: "Westmorland County", isCapital: false, coordinates: .init(lat: 46.07844, lng: -64.68735)),
        City(id: 5, name: "Miramichi", legalName: "Northumberland County", isCapital: false, coordinates: .init(lat: 47.02895, lng: -65.50186)),
    ]),
    Region(id: 9, name: "Newfoundland and Labrador", cities: [
        City(id: 1, name: "St. John's", legalName: "", isCapital: false, coordinates: .init(lat: 47.56494, lng: -52.70931)),
        City(id: 2, name: "Mount Pearl", legalName: "St. John's", isCapital: false, coordinates: .init(lat: 47.51659, lng: -52.78135)),
        City(id: 3, name: "Corner Brook", legalName: "", isCapital: false, coordinates: .init(lat: 48.95001, lng: -57.95202)),
        City(id: 4, name: "Conception Bay South", legalName: "", isCapital: false, coordinates: .init(lat: 47.49989, lng: -52.99806)),
        City(id: 5, name: "Paradise", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 10, name: "Prince Edward Island", cities: [
        City(id: 1, name: "Charlottetown", legalName: "Queens County", isCapital: false, coordinates: .init(lat: 46.23459, lng: -63.1256)),
        City(id: 2, name: "Summerside", legalName: "Prince County", isCapital: false, coordinates: .init(lat: 46.3912, lng: -63.78869)),
        City(id: 3, name: "Stratford", legalName: "Perth County", isCapital: false, coordinates: .init(lat: 43.36679, lng: -80.94972)),
        City(id: 4, name: "Cornwall", legalName: "United Counties of Stormont, Dundas and Glengarry", isCapital: false, coordinates: .init(lat: 45.01809, lng: -74.72815)),
        City(id: 5, name: "Montague", legalName: "Kings County", isCapital: false, coordinates: .init(lat: 46.16681, lng: -62.64866)),
    ]),
])
