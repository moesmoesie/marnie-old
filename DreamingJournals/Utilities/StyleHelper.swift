//
//  StyleHelper.swift
//  DreamingJournals
//
//  Created by moesmoesie on 24/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI


func removeTableViewBackground(){
    UITableView.appearance().backgroundColor = .clear
    UITableView.appearance().separatorStyle = .none
    UITableViewCell.appearance().backgroundColor = .clear
    UITableViewCell.appearance().selectionStyle = .none
}
