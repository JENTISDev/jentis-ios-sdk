import Foundation

public struct TrackConfig {
    public enum Environment: String {
        case live, stage
    }

    /// The trackDomain from your Jentis Account
    public let trackDomain: String
    /// The trackID from your Jentis Account
    public let trackID: String
    /// The environment you want to track in (stage | live)
    public let environment: Environment

    public init(trackDomain: String, trackID: String, environment: TrackConfig.Environment, debugId _: String? = nil) {
        self.trackDomain = trackDomain
        self.trackID = trackID
        self.environment = environment
    }
}
