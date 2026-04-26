//
//  CanadaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let canada = Country(id: 1, name: "Canada", regions: [
    Region(id: 1, name: "Ontario", cities: [
        City(id: 1, name: "Toronto", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Ottawa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Mississauga", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Brampton", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Hamilton", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "London", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Markham", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 8, name: "Vaughan", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 9, name: "Kitchener", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 10, name: "Windsor", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Quebec", cities: [
        City(id: 1, name: "Montreal", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Quebec City", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Laval", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Gatineau", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Longueuil", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Sherbrooke", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Lévis", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 8, name: "Saguenay", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 9, name: "Trois-Rivières", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 10, name: "Terrebonne", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "British Columbia", cities: [
        City(id: 1, name: "Vancouver", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Surrey", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Burnaby", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Richmond", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Abbotsford", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Coquitlam", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Kelowna", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 8, name: "Langley", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 9, name: "Saanich", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 10, name: "Delta", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Alberta", cities: [
        City(id: 1, name: "Calgary", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Edmonton", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Red Deer", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Lethbridge", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Airdrie", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "St. Albert", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Medicine Hat", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 8, name: "Grande Prairie", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 9, name: "Spruce Grove", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 10, name: "Leduc", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Manitoba", cities: [
        City(id: 1, name: "Winnipeg", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Brandon", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Steinbach", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Thompson", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Portage la Prairie", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "Saskatchewan", cities: [
        City(id: 1, name: "Saskatoon", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Regina", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Prince Albert", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Moose Jaw", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Swift Current", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Nova Scotia", cities: [
        City(id: 1, name: "Halifax", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Dartmouth", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Sydney", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Truro", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "New Glasgow", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 8, name: "New Brunswick", cities: [
        City(id: 1, name: "Moncton", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Saint John", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Fredericton", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Dieppe", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Miramichi", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 9, name: "Newfoundland and Labrador", cities: [
        City(id: 1, name: "St. John's", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Mount Pearl", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Corner Brook", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Conception Bay South", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Paradise", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 10, name: "Prince Edward Island", cities: [
        City(id: 1, name: "Charlottetown", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Summerside", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Stratford", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Cornwall", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Montague", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
