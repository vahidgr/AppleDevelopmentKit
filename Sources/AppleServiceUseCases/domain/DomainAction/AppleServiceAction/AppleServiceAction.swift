public enum AppleServiceAction: Sendable {
    case makeFaceTimeCallURL(destination: String, type: FaceTimeCallType)
    case checkICloudAccount
}
