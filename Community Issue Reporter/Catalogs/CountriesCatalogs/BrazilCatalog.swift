//
//  BrazilCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let brazil = Country(id: 3, name: "Brazil", regions: [
    Region(id: 1, name: "São Paulo", cities: [
        City(id: 1, name: "São Paulo", legalName: "", isCapital: false, coordinates: .init(lat: -3.37833, lng: -68.8725)),
        City(id: 2, name: "Guarulhos", legalName: "", isCapital: false, coordinates: .init(lat: -23.46278, lng: -46.53333)),
        City(id: 3, name: "Campinas", legalName: "São José", isCapital: false, coordinates: .init(lat: -27.59444, lng: -48.60694)),
        City(id: 4, name: "São Bernardo do Campo", legalName: "", isCapital: false, coordinates: .init(lat: -23.69389, lng: -46.565)),
        City(id: 5, name: "Santo André", legalName: "", isCapital: false, coordinates: .init(lat: -23.66389, lng: -46.53833)),
        City(id: 6, name: "São José dos Campos", legalName: "", isCapital: false, coordinates: .init(lat: -23.17944, lng: -45.88694)),
        City(id: 7, name: "Osasco", legalName: "", isCapital: false, coordinates: .init(lat: -23.5325, lng: -46.79167)),
        City(id: 8, name: "Ribeirão Preto", legalName: "", isCapital: false, coordinates: .init(lat: -21.1775, lng: -47.81028)),
        City(id: 9, name: "Sorocaba", legalName: "", isCapital: false, coordinates: .init(lat: -23.50167, lng: -47.45806)),
        City(id: 10, name: "Santos", legalName: "", isCapital: false, coordinates: .init(lat: -23.96083, lng: -46.33361)),
    ]),
    Region(id: 2, name: "Minas Gerais", cities: [
        City(id: 1, name: "Belo Horizonte", legalName: "", isCapital: false, coordinates: .init(lat: -19.92083, lng: -43.93778)),
        City(id: 2, name: "Uberlândia", legalName: "", isCapital: false, coordinates: .init(lat: -18.91861, lng: -48.27722)),
        City(id: 3, name: "Contagem", legalName: "", isCapital: false, coordinates: .init(lat: -19.93167, lng: -44.05361)),
        City(id: 4, name: "Juiz de Fora", legalName: "", isCapital: false, coordinates: .init(lat: -21.76417, lng: -43.35028)),
        City(id: 5, name: "Betim", legalName: "", isCapital: false, coordinates: .init(lat: -19.96778, lng: -44.19833)),
        City(id: 6, name: "Montes Claros", legalName: "", isCapital: false, coordinates: .init(lat: -16.735, lng: -43.86167)),
        City(id: 7, name: "Ribeirão das Neves", legalName: "", isCapital: false, coordinates: .init(lat: -19.76694, lng: -44.08667)),
        City(id: 8, name: "Uberaba", legalName: "", isCapital: false, coordinates: .init(lat: -19.74833, lng: -47.93194)),
    ]),
    Region(id: 3, name: "Rio de Janeiro", cities: [
        City(id: 1, name: "Rio de Janeiro", legalName: "", isCapital: false, coordinates: .init(lat: -22.90642, lng: -43.18223)),
        City(id: 2, name: "São Gonçalo", legalName: "", isCapital: false, coordinates: .init(lat: -21.89222, lng: -45.59528)),
        City(id: 3, name: "Duque de Caxias", legalName: "", isCapital: false, coordinates: .init(lat: -22.78556, lng: -43.31167)),
        City(id: 4, name: "Nova Iguaçu", legalName: "", isCapital: false, coordinates: .init(lat: -22.75917, lng: -43.45111)),
        City(id: 5, name: "Niterói", legalName: "", isCapital: false, coordinates: .init(lat: -22.88333, lng: -43.10361)),
        City(id: 6, name: "Belford Roxo", legalName: "", isCapital: false, coordinates: .init(lat: -22.76417, lng: -43.39944)),
        City(id: 7, name: "São João de Meriti", legalName: "", isCapital: false, coordinates: .init(lat: -22.80389, lng: -43.37222)),
        City(id: 8, name: "Campos dos Goytacazes", legalName: "", isCapital: false, coordinates: .init(lat: -21.75227, lng: -41.33044)),
    ]),
    Region(id: 4, name: "Bahia", cities: [
        City(id: 1, name: "Salvador", legalName: "", isCapital: false, coordinates: .init(lat: -12.97563, lng: -38.49096)),
        City(id: 2, name: "Feira de Santana", legalName: "", isCapital: false, coordinates: .init(lat: -12.26667, lng: -38.96667)),
        City(id: 3, name: "Vitória da Conquista", legalName: "", isCapital: false, coordinates: .init(lat: -14.86611, lng: -40.83944)),
        City(id: 4, name: "Camaçari", legalName: "", isCapital: false, coordinates: .init(lat: -12.6975, lng: -38.32417)),
        City(id: 5, name: "Itabuna", legalName: "", isCapital: false, coordinates: .init(lat: -14.78556, lng: -39.28028)),
        City(id: 6, name: "Juazeiro", legalName: "", isCapital: false, coordinates: .init(lat: -7.21306, lng: -39.31528)),
        City(id: 7, name: "Lauro de Freitas", legalName: "", isCapital: false, coordinates: .init(lat: -12.89444, lng: -38.32722)),
    ]),
    Region(id: 5, name: "Paraná", cities: [
        City(id: 1, name: "Curitiba", legalName: "", isCapital: false, coordinates: .init(lat: -27.28278, lng: -50.58444)),
        City(id: 2, name: "Londrina", legalName: "", isCapital: false, coordinates: .init(lat: -22.76583, lng: -52.985)),
        City(id: 3, name: "Maringá", legalName: "", isCapital: false, coordinates: .init(lat: -23.42528, lng: -51.93861)),
        City(id: 4, name: "Ponta Grossa", legalName: "", isCapital: false, coordinates: .init(lat: -25.095, lng: -50.16194)),
        City(id: 5, name: "Cascavel", legalName: "", isCapital: false, coordinates: .init(lat: -24.95583, lng: -53.45528)),
        City(id: 6, name: "São José dos Pinhais", legalName: "", isCapital: false, coordinates: .init(lat: -25.5302, lng: -49.20836)),
        City(id: 7, name: "Foz do Iguaçu", legalName: "", isCapital: false, coordinates: .init(lat: -25.54778, lng: -54.58806)),
    ]),
    Region(id: 6, name: "Rio Grande do Sul", cities: [
        City(id: 1, name: "Porto Alegre", legalName: "", isCapital: false, coordinates: .init(lat: -30.03283, lng: -51.23019)),
        City(id: 2, name: "Caxias do Sul", legalName: "", isCapital: false, coordinates: .init(lat: -29.16806, lng: -51.17944)),
        City(id: 3, name: "Canoas", legalName: "", isCapital: false, coordinates: .init(lat: -29.91778, lng: -51.18361)),
        City(id: 4, name: "Pelotas", legalName: "", isCapital: false, coordinates: .init(lat: -31.76997, lng: -52.34101)),
        City(id: 5, name: "Santa Maria", legalName: "", isCapital: false, coordinates: .init(lat: -29.68417, lng: -53.80694)),
        City(id: 6, name: "Gravataí", legalName: "", isCapital: false, coordinates: .init(lat: -29.94218, lng: -50.99278)),
        City(id: 7, name: "Novo Hamburgo", legalName: "", isCapital: false, coordinates: .init(lat: -29.67833, lng: -51.13056)),
    ]),
    Region(id: 7, name: "Pernambuco", cities: [
        City(id: 1, name: "Recife", legalName: "", isCapital: false, coordinates: .init(lat: -8.05389, lng: -34.88111)),
        City(id: 2, name: "Jaboatão dos Guararapes", legalName: "", isCapital: false, coordinates: .init(lat: -8.11278, lng: -35.01472)),
        City(id: 3, name: "Olinda", legalName: "", isCapital: false, coordinates: .init(lat: -3.89174, lng: -59.09542)),
        City(id: 4, name: "Caruaru", legalName: "", isCapital: false, coordinates: .init(lat: -8.28333, lng: -35.97611)),
        City(id: 5, name: "Petrolina", legalName: "", isCapital: false, coordinates: .init(lat: -16.095, lng: -49.33806)),
        City(id: 6, name: "Paulista", legalName: "", isCapital: false, coordinates: .init(lat: -22.5572, lng: -52.58972)),
    ]),
    Region(id: 8, name: "Ceará", cities: [
        City(id: 1, name: "Fortaleza", legalName: "", isCapital: false, coordinates: .init(lat: -3.71722, lng: -38.54306)),
        City(id: 2, name: "Caucaia", legalName: "", isCapital: false, coordinates: .init(lat: -3.73611, lng: -38.65306)),
        City(id: 3, name: "Juazeiro do Norte", legalName: "", isCapital: false, coordinates: .init(lat: -7.21306, lng: -39.31528)),
        City(id: 4, name: "Maracanaú", legalName: "", isCapital: false, coordinates: .init(lat: -3.87667, lng: -38.62556)),
        City(id: 5, name: "Sobral", legalName: "", isCapital: false, coordinates: .init(lat: -3.68611, lng: -40.34972)),
    ]),
    Region(id: 9, name: "Pará", cities: [
        City(id: 1, name: "Belém", legalName: "", isCapital: false, coordinates: .init(lat: -1.45583, lng: -48.50444)),
        City(id: 2, name: "Ananindeua", legalName: "", isCapital: false, coordinates: .init(lat: -1.36556, lng: -48.37222)),
        City(id: 3, name: "Santarém", legalName: "", isCapital: false, coordinates: .init(lat: -2.44306, lng: -54.70833)),
        City(id: 4, name: "Marabá", legalName: "", isCapital: false, coordinates: .init(lat: -5.38146, lng: -49.13232)),
        City(id: 5, name: "Castanhal", legalName: "", isCapital: false, coordinates: .init(lat: -1.29389, lng: -47.92639)),
    ]),
    Region(id: 10, name: "Santa Catarina", cities: [
        City(id: 1, name: "Joinville", legalName: "", isCapital: false, coordinates: .init(lat: -26.30444, lng: -48.84556)),
        City(id: 2, name: "Florianópolis", legalName: "", isCapital: false, coordinates: .init(lat: -27.59667, lng: -48.54917)),
        City(id: 3, name: "Blumenau", legalName: "", isCapital: false, coordinates: .init(lat: -26.91944, lng: -49.06611)),
        City(id: 4, name: "São José", legalName: "", isCapital: false, coordinates: .init(lat: -29.53857, lng: -51.48468)),
        City(id: 5, name: "Chapecó", legalName: "", isCapital: false, coordinates: .init(lat: -27.09639, lng: -52.61833)),
        City(id: 6, name: "Itajaí", legalName: "", isCapital: false, coordinates: .init(lat: -26.90778, lng: -48.66194)),
    ]),
])
