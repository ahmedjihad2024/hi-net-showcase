//
//  MyAppWidgetLiveActivity.swift
//  MyAppWidget
//
//  Created by Ahmed Jihad on 26/02/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

let sharedDefault = UserDefaults(suiteName: "group.esim_usage_live_activity")!

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    public struct ContentState: Codable, Hashable { }
    var id = UUID()
}

struct MyAppWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let country = sharedDefault.string(forKey: context.attributes.prefixedKey("country")) ?? "eSIM"
            let daysText = sharedDefault.string(forKey: context.attributes.prefixedKey("daysText")) ?? ""
            let statusText = sharedDefault.string(forKey: context.attributes.prefixedKey("statusText")) ?? "Active"
            let statusTextColorInt = sharedDefault.integer(forKey: context.attributes.prefixedKey("statusTextColor"))
            let partOne = sharedDefault.string(forKey: context.attributes.prefixedKey("partOne")) ?? "0.0"
            let partTwo = sharedDefault.string(forKey: context.attributes.prefixedKey("partTwo")) ?? "/ 0.0 GB"
            let progress = sharedDefault.double(forKey: context.attributes.prefixedKey("progress"))

            let statusTextColor = Color(hex: statusTextColorInt != 0 ? UInt64(statusTextColorInt) : 0xFFFFFFFF)

            HStack(spacing: 14) {
                // Left: App icon
                Image("widget_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                // Center: Info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(country)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)

                        Text(statusText)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(statusTextColor.opacity(0.9))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(statusTextColor.opacity(0.15))
                            .clipShape(Capsule())
                    }

                    Text(daysText)
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.55))
                }

                Spacer()

                // Right: Data usage
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text(partOne)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text(partTwo)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.white.opacity(0.12))
                                .frame(height: 5)

                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: 0x6DD5FA), Color(hex: 0xFFFFFF)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(geo.size.width * CGFloat(progress), 4), height: 5)
                        }
                    }
                    .frame(height: 5)
                }
                .frame(width: 130)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .activityBackgroundTint(Color.clear)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: 0x0F0C29), Color(hex: 0x302B63), Color(hex: 0x24243E)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            let country = sharedDefault.string(forKey: context.attributes.prefixedKey("country")) ?? "eSIM"
            let statusText = sharedDefault.string(forKey: context.attributes.prefixedKey("statusText")) ?? "Active"
            let partOne = sharedDefault.string(forKey: context.attributes.prefixedKey("partOne")) ?? "0.0"
            let partTwo = sharedDefault.string(forKey: context.attributes.prefixedKey("partTwo")) ?? "/ 0.0 GB"
            let progress = sharedDefault.double(forKey: context.attributes.prefixedKey("progress"))
            let statusTextColorInt = sharedDefault.integer(forKey: context.attributes.prefixedKey("statusTextColor"))
            let statusTextColor = Color(hex: statusTextColorInt != 0 ? UInt64(statusTextColorInt) : 0xFFFFFFFF)

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image("widget_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                        VStack(alignment: .leading, spacing: 1) {
                            Text(country)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text(statusText)
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(statusTextColor)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(partOne)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(partTwo)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.white.opacity(0.15))
                                .frame(height: 5)

                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: 0x6DD5FA), .white],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(geo.size.width * CGFloat(progress), 4), height: 5)
                        }
                    }
                    .frame(height: 5)
                    .padding(.top, 4)
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Image("widget_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                    Text(partOne)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
            } compactTrailing: {
                Text(partTwo)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            } minimal: {
                Image("widget_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
            .keylineTint(Color(hex: 0x302B63))
        }
    }
}

extension Color {
    init(hex: UInt64) {
        let a = Double((hex >> 24) & 0xff) / 255.0
        let r = Double((hex >> 16) & 0xff) / 255.0
        let g = Double((hex >> 8) & 0xff) / 255.0
        let b = Double(hex & 0xff) / 255.0
        if hex > 0xFFFFFF {
            self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
        } else {
            self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
        }
    }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
