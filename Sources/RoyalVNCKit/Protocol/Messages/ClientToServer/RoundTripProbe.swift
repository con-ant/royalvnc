#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCProtocol {
	/// A non-incremental update request for one pixel, used to time the
	/// server's response. Records when it was written so the receive side
	/// can measure the round trip. See `VNCConnection.measureRoundTrip()`.
	struct RoundTripProbe: VNCSendableMessage {
		let state: VNCConnection.State

		private let request = FramebufferUpdateRequest(incremental: false,
													   xPosition: 0,
													   yPosition: 0,
													   width: 1,
													   height: 1)

		init(state: VNCConnection.State) {
			self.state = state
		}
	}
}

extension VNCProtocol.RoundTripProbe {
	var messageType: UInt8 { request.messageType }

	var data: Data { request.data }

	func send(connection: NetworkConnectionWriting) async throws {
		try await connection.write(data: data)

		// Stamped after the write so time spent queued behind other
		// messages doesn't count.
		state.roundTripProbeSentAt = Date().timeIntervalSinceReferenceDate
	}
}
