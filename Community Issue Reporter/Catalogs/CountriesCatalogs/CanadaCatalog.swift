//
//  CanadaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let canada = Country(id: 1, name: "Canada", regions: [
    Region(id: 1, name: "Ontario", cities: [
        City(id: 1, name: "Toronto"),
        City(id: 2, name: "Ottawa"),
        City(id: 3, name: "Mississauga"),
        City(id: 4, name: "Brampton"),
        City(id: 5, name: "Hamilton"),
        City(id: 6, name: "London"),
        City(id: 7, name: "Markham"),
        City(id: 8, name: "Vaughan"),
        City(id: 9, name: "Kitchener"),
        City(id: 10, name: "Windsor"),
    ]),
    Region(id: 2, name: "Quebec", cities: [
        City(id: 1, name: "Montreal"),
        City(id: 2, name: "Quebec City"),
        City(id: 3, name: "Laval"),
        City(id: 4, name: "Gatineau"),
        City(id: 5, name: "Longueuil"),
        City(id: 6, name: "Sherbrooke"),
        City(id: 7, name: "Lévis"),
        City(id: 8, name: "Saguenay"),
        City(id: 9, name: "Trois-Rivières"),
        City(id: 10, name: "Terrebonne"),
    ]),
    Region(id: 3, name: "British Columbia", cities: [
        City(id: 1, name: "Vancouver"),
        City(id: 2, name: "Surrey"),
        City(id: 3, name: "Burnaby"),
        City(id: 4, name: "Richmond"),
        City(id: 5, name: "Abbotsford"),
        City(id: 6, name: "Coquitlam"),
        City(id: 7, name: "Kelowna"),
        City(id: 8, name: "Langley"),
        City(id: 9, name: "Saanich"),
        City(id: 10, name: "Delta"),
    ]),
    Region(id: 4, name: "Alberta", cities: [
        City(id: 1, name: "Calgary"),
        City(id: 2, name: "Edmonton"),
        City(id: 3, name: "Red Deer"),
        City(id: 4, name: "Lethbridge"),
        City(id: 5, name: "Airdrie"),
        City(id: 6, name: "St. Albert"),
        City(id: 7, name: "Medicine Hat"),
        City(id: 8, name: "Grande Prairie"),
        City(id: 9, name: "Spruce Grove"),
        City(id: 10, name: "Leduc"),
    ]),
    Region(id: 5, name: "Manitoba", cities: [
        City(id: 1, name: "Winnipeg"),
        City(id: 2, name: "Brandon"),
        City(id: 3, name: "Steinbach"),
        City(id: 4, name: "Thompson"),
        City(id: 5, name: "Portage la Prairie"),
    ]),
    Region(id: 6, name: "Saskatchewan", cities: [
        City(id: 1, name: "Saskatoon"),
        City(id: 2, name: "Regina"),
        City(id: 3, name: "Prince Albert"),
        City(id: 4, name: "Moose Jaw"),
        City(id: 5, name: "Swift Current"),
    ]),
    Region(id: 7, name: "Nova Scotia", cities: [
        City(id: 1, name: "Halifax"),
        City(id: 2, name: "Dartmouth"),
        City(id: 3, name: "Sydney"),
        City(id: 4, name: "Truro"),
        City(id: 5, name: "New Glasgow"),
    ]),
    Region(id: 8, name: "New Brunswick", cities: [
        City(id: 1, name: "Moncton"),
        City(id: 2, name: "Saint John"),
        City(id: 3, name: "Fredericton"),
        City(id: 4, name: "Dieppe"),
        City(id: 5, name: "Miramichi"),
    ]),
    Region(id: 9, name: "Newfoundland and Labrador", cities: [
        City(id: 1, name: "St. John's"),
        City(id: 2, name: "Mount Pearl"),
        City(id: 3, name: "Corner Brook"),
        City(id: 4, name: "Conception Bay South"),
        City(id: 5, name: "Paradise"),
    ]),
    Region(id: 10, name: "Prince Edward Island", cities: [
        City(id: 1, name: "Charlottetown"),
        City(id: 2, name: "Summerside"),
        City(id: 3, name: "Stratford"),
        City(id: 4, name: "Cornwall"),
        City(id: 5, name: "Montague"),
    ]),
])
