//
//  APIService.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

//MARK: - Kakao API를 통해 도서 목록 조회 네트워크 서비스
class APIService {
    static let shared = APIService()
    private let baseURL = "https://dapi.kakao.com/v3/search/book"
    
    // Secret.scconfig -> Info.plist에서 API 키를 읽어오기
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KakaoAPIKey") as? String else {
            fatalError("Info.plist에 'KakaoAPIKey'를 설정해야함")
        }
        return key
    }

    private init() {}

    
    //MARK: - 네트워크 요청 쿼리를 받아 도서 조회
    /// - Parameters:
    ///   - query: 검색어
    ///   - sort: 정렬 상태
    ///   - page: 로드 페이지
    ///   - size: 페이지당 도서 아이템 갯수
    /// - Returns: `BookSearchResponse`를 방출하는 객체
    func searchBooks(query: String, sort: String, page: Int, size: Int = 20) -> Observable<BookSearchResponse> {
        print("--------------------------------------------------------------")
        print("APIService.searchBooks() 실행됨")
        return Observable.create { observer in
            
            // URL 컴포넌트 생성
            var components = URLComponents(string: self.baseURL)
            components?.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "sort", value: sort),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
            
            
            guard let url = components?.url else {
                print("Invalid URL: \(String(describing: components?.string))")
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }

            // 요청 객체 생성
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")

            // URLSession으로 네트워크 요청, 응답 처리
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                if let error = error {
                    print("Network Request Failed: \(error)")
                    observer.onError(NetworkError.requestFailed(error))
                    return
                }

                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid HTTP Response: \(String(describing: response))")
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    print("No data received.")
                    observer.onError(NetworkError.invalidResponse)
                    return
                }

                do {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let dateFormatter = ISO8601DateFormatter()
                    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]
                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        if let date = dateFormatter.date(from: dateString) {
                            return date
                        }
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                    }

                    // 응답된 JSON 디코딩
                    let bookResponse = try decoder.decode(BookSearchResponse.self, from: data)
                    observer.onNext(bookResponse)
                    observer.onCompleted()
                } catch {
                    print("Decoding Failed: \(error)")
                    observer.onError(NetworkError.decodingFailed(error))
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
