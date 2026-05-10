//
//  MyAppWidgetBundle.swift
//  MyAppWidget
//
//  Created by Ahmed Jihad on 26/02/2026.
//

import WidgetKit
import SwiftUI

@main
struct MyAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyAppWidget()
        MyAppWidgetLiveActivity()
    }
}
