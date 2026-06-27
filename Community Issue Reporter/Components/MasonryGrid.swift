//
//  MasonryGrid.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/6/26.
//

import SwiftUI

struct MasonryGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let columns: Int
    let spacing: CGFloat
    let data: Data
    let content: (Data.Element) -> Content
    
    /// Splits the initial single flat list into separate column lists
    private func columnData(for totalColumns: Int) -> [[Data.Element]] {
        var columnsArray: [[Data.Element]] = Array(repeating: [], count: totalColumns)
        for (index, element) in data.enumerated() {
            let columnIndex = index % totalColumns
            columnsArray[columnIndex].append(element)
        }
        return columnsArray
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            let distributedData = columnData(for: columns)
            
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: spacing) {
                    ForEach(distributedData[columnIndex]) { item in
                        content(item)
                    }
                }
            }
        }
    }
}


