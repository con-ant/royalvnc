#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCConnection {
    final class State {
		var disconnectRequested = false

		var serverProtocolVersion: VNCProtocol.ProtocolVersion?
		var agreedProtocolVersion: VNCProtocol.ProtocolVersion?

		var isTightSecurityEnabled = false

		var framebufferWidth: UInt16 = 0
		var framebufferHeight: UInt16 = 0

		var serverPixelFormat: VNCProtocol.PixelFormat?
		var pixelFormat: VNCProtocol.PixelFormat?

		var desktopName: String?

		var incrementalUpdatesEnabled = false

		var areContinuousUpdatesSupported = false
		var areContinuousUpdatesEnabled = false

		/// When the last round-trip probe went on the wire; nil when none
		/// is outstanding. See `VNCConnection.measureRoundTrip()`.
		var roundTripProbeSentAt: TimeInterval?
	}
}

extension VNCConnection.State {
	var isAppleRemoteDesktop: Bool {
		return serverProtocolVersion?.isAppleRemoteDesktop ?? false
	}
}
