//
//  HTTPClient.swift
//  GitHubFollowers
//
//  Created by ilhan serhan ipek on 16.08.2024.
//

import Foundation

let baseUrl = "https://api.github.com"

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

enum RequestError: Error {
  case badUrl
  case badModel
}

enum NetworkError: Error {
  case clientError
  case serverError
  case invalidResponse
  case unknown
}

protocol HTTPClientProtocol {
  
}

class HTTPClient: HTTPClientProtocol {

  var jsonDecoder = JSONDecoder()
  var jsonEncoder = JSONEncoder()
  
  // Request Handling
  func makeUrlRequest<Model: Codable>(baseUrl: URL, path: String?, httpMethod: HTTPMethod, queryParameters: [String: String]?, model: Model? = nil) throws -> URLRequest {
    let url: URL

    if let path = path {
      url = baseUrl.appendingPathComponent(path)
    } else {
      url = baseUrl
    }

    if let queryParameters = queryParameters {
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
      urlComponents?.queryItems = queryParameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
    }

    var urlRequest = URLRequest(url: url)

    try handleUrlRequest(urlRequest: &urlRequest, httpMethod: httpMethod, model: model)
    return urlRequest
  }

  private func handleUrlRequest<Model: Encodable>(urlRequest: inout URLRequest, httpMethod: HTTPMethod, model: Model? = nil) throws {
    urlRequest.httpMethod = httpMethod.rawValue

    if httpMethod != .get && model != nil {
      let jsonData = try jsonEncoder.encode(model)
      urlRequest.httpBody = jsonData
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
  }

  // Response Handling

  func processRequest<T>(urlRequest: URLRequest, with returningType: T.Type) async throws -> T where T: Decodable {
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    let result = verifyResponse(data: data, response: response)
    switch result {
    case .success(let data):
      return try jsonDecoder.decode(returningType, from: data)
    case .failure(let error):
      throw error
    }
  }

  private func verifyResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
    guard let httpResponse = response as? HTTPURLResponse else {
      return .failure(NetworkError.invalidResponse)
    }
    switch httpResponse.statusCode {
    case 200...299:
      return .success(data)
    case 400...499:
      return .failure(NetworkError.clientError)
    case 500...599:
      return .failure(NetworkError.serverError)
    default:
      return .failure(NetworkError.unknown)
    }
  }
}

