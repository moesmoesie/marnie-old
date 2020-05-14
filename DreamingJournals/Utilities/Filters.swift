//
//  Filters.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

func tagFilter(tags : [TagViewModel], dreams : [DreamViewModel]) -> [DreamViewModel]{
    return dreams.filter({ dream in
        for filter in tags{
            if !dream.tags.contains(where: {$0.text == filter.text}){
                return false
            }
        }
        return true
    })
}
