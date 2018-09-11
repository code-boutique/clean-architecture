import Foundation

enum Result<T, E> where E: Error {
    case success(T)
    case failure(E)
}
