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

enum RequestError: LocalizedError {
    case badUrl
    case badModel
    case encodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Invalid URL."
        case .badModel:
            return "The model provided is invalid."
        case .encodingFailed(let error):
            return "Failed to encode the model. Error: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: LocalizedError {
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case invalidResponse
    case unknown(Error?)

    var errorDescription: String? {
        switch self {
        case .clientError(let statusCode):
            return "Client error with status code: \(statusCode)."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .invalidResponse:
            return "Invalid response from the server."
        case .unknown(let error):
            return "An unknown error occurred: \(error?.localizedDescription ?? "No additional information")."
        }
    }
}


protocol HTTPClientProtocol {
  func processRequest<T>(urlRequest: URLRequest, with returningType: T.Type) async throws -> T where T: Decodable
}

class HTTPClient: HTTPClientProtocol {

  let httpClient = HTTPClient()

  private var jsonDecoder : JSONDecoder
  private var jsonEncoder : JSONEncoder

  init(jsonDecoder: JSONDecoder = JSONDecoder(), jsonEncoder: JSONEncoder = JSONEncoder()) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    self.jsonDecoder = jsonDecoder
    self.jsonEncoder = jsonEncoder
  }

  // Request Handling
  func makeUrlRequest(baseUrl: URL, path: String?, httpMethod: HTTPMethod, queryParameters: [String: String]?) throws -> URLRequest {
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
    urlRequest.httpMethod = httpMethod.rawValue

    return urlRequest
  }

  func makeUrlRequest<Model: Encodable>(baseUrl: URL, path: String?, httpMethod: HTTPMethod, queryParameters: [String: String]?, model: Model) throws -> URLRequest {
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
    
    do {
      try handleUrlRequest(urlRequest: &urlRequest, httpMethod: httpMethod, model: model)
    } catch {
      throw RequestError.encodingFailed(error)
    }
    return urlRequest
  }

  private func handleUrlRequest<Model: Encodable>(urlRequest: inout URLRequest, httpMethod: HTTPMethod, model: Model) throws {
    urlRequest.httpMethod = httpMethod.rawValue

    let jsonData = try jsonEncoder.encode(model)
    urlRequest.httpBody = jsonData
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
              return .failure(NetworkError.clientError(statusCode: httpResponse.statusCode))
          case 500...599:
              return .failure(NetworkError.serverError(statusCode: httpResponse.statusCode))
          default:
              return .failure(NetworkError.unknown(nil))
          }
      }
}

