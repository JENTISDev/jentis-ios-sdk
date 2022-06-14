//
//  File.swift
//  
//
//  Created by Andreas Mühleder on 14.06.22.
//

import Foundation

public struct TrackConfig {
    public enum Environment: String {
        case live, stage
    }

    public let trackDomain: String
    public let trackID: String
    public let environment: Environment
    
    public init(trackDomain: String, trackID: String, environment: TrackConfig.Environment, debugId: String? = nil) {
        self.trackDomain = trackDomain
        self.trackID = trackID
        self.environment = environment
    }
}
