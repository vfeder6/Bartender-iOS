import Networking
import SwiftUI

struct DrinkImageService: Microservice {
    let networkClient: NetworkClient<Image>

    func fetch(fileName: String) async -> Result<Image, NetworkError> {
        do {
            let response = try await networkClient.performRequest(
                to: "media/drink/\(fileName)",
                queryItems: [],
                body: nil,
                method: .get,
                additionalHeaders: [:],
                expectedStatusCode: 200
            )
            return .success(response.body!)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            fatalError()
        }
    }
}
