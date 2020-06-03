//
//  FilterViewModel.swift
//  DreamingJournals
//
//  Created by moesmoesie on 15/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData

struct FilterViewModel : Identifiable, Equatable{
    static func == (lhs: FilterViewModel, rhs: FilterViewModel) -> Bool {
        lhs.filter.areEqual(filter: rhs.filter)
    }
    
    let id = UUID()
    var filter : Filter
}

enum Filter{
    case isBookmarked(Bool)
    case isLucid(Bool)
    case isNightmare(Bool)
    case tag(TagViewModel)
    case containsWord(String)

    func getPredicate() -> NSPredicate{
        switch self {
        case let .isBookmarked(isBookmarked):
            return isBookmarkedPredicate(isBookmarked)
        case let .isLucid(isLucid):
            return isLucidPredicate(isLucid)
        case let .isNightmare(isNightmare):
            return isNightmarePredicate(isNightmare)
        case let .tag(text):
            return getTagPredicate(text)
        case let .containsWord(text):
            return containsWordPredicate(text)
        }
    }
    
    public func areEqual(filter : Self) -> Bool{
        switch (self,filter) {
        case let (.tag(a), .tag(b)):
            return a.text == b.text
        case let (.isBookmarked(a), .isBookmarked(b)):
            return a == b
        case let (.isLucid(a), .isLucid(b)):
            return a == b
        case let (.isNightmare(a), .isNightmare(b)):
            return a == b
        case let (.containsWord(a), .containsWord(b)):
            return a == b
        default:
            return false
        }
    }
    
    public func areEqualType(filter : Self) -> Bool{
        switch (self,filter) {
        case (.tag(_), .tag(_)):
            return true
        case (.isBookmarked(_), .isBookmarked(_)):
            return true
        case (.isLucid(_), .isLucid(_)):
            return true
        case (.isNightmare(_), .isNightmare(_)):
            return true
        case (.containsWord(_), .containsWord(_)):
            return true
        default:
            return false
        }
    }
    
    private func containsWordPredicate(_ word : String) -> NSPredicate{
        NSPredicate(
            format: "%K contains %@",
            argumentArray: [#keyPath(Dream.text.localizedLowercase), word.lowercased()]
        )
    }
    
    private func getTagPredicate(_ tag : TagViewModel) -> NSPredicate{
        NSPredicate(
            format: "ANY %K.text = %@",
            argumentArray: [#keyPath(Dream.tags), tag.text]
        )
    }
    
    private func isBookmarkedPredicate(_ isBookmarked : Bool) -> NSPredicate{
        NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Dream.isBookmarked), isBookmarked]
        )
    }
    
    private func isLucidPredicate(_ isLucid : Bool) -> NSPredicate{
        NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Dream.isLucid), isLucid]
        )
    }
    
    private func isNightmarePredicate(_ isNightmare : Bool) -> NSPredicate{
        NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Dream.isNightmare), isNightmare]
        )
    }
}
