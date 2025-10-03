//import UIKit
//
//func createLayout(headerHeight: CGFloat = 40,
//                  itemWidth: CGFloat = 140,
//                  itemHeight: CGFloat = 180,
//                  sectionBottomContentInsets: CGFloat = 12) -> UICollectionViewLayout {
//    return UICollectionViewCompositionalLayout { sectionIndex, _ in
//        
//        // Define the size of a single item (cell)
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(itemWidth),
//            heightDimension: .absolute(itemHeight)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        // Define a group that holds multiple items horizontally
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .estimated(500), // enough width for multiple 140pt items + spacing
//            heightDimension: .absolute(itemHeight)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        
//      //  group.interItemSpacing = .fixed(10)
//        
//        // Define the section header
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(headerHeight)
//        )
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerSize,
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .top
//        )
//        
//        // Create section using the group and header
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [sectionHeader]
//        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = 0
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
//                                                        leading: 24,
//                                                        bottom: sectionBottomContentInsets,
//                                                        trailing: 16)
//        
//        return section
//    }
//}

import UIKit

struct SectionLayoutConfig {
    var headerHeight: CGFloat = 34.0
    var itemWidth: CGFloat
    var itemHeight: CGFloat
    var sectionBottomContentInsets: CGFloat = 32.0
    var interGroupSpacing: CGFloat = 10.0
}

func createLayout(configs: [SectionLayoutConfig]) -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, _ in
        guard sectionIndex < configs.count else { return nil }
        
        let config = configs[sectionIndex]
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(config.itemWidth),
            heightDimension: .absolute(config.itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(config.itemWidth * 3), // just an estimate for scrolling
            heightDimension: .absolute(config.itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(config.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = config.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 24,
            bottom: config.sectionBottomContentInsets,
            trailing: 16
        )
        
        return section
    }
}
