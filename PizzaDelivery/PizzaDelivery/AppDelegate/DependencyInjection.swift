//
//  DependencyInjection.swift
//  PizzaDelivery
//
//  Created by Stas Boiko on 09.10.2024.
//

import Swinject

extension AppDelegate {
    
    func createDependencies() -> Container {
        let container = Container()
        
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(dependencies: resolver)
        }.inObjectScope(.container)
    
        registerFirebaseRepo(in: container)
        registerLocationRepo(in: container)
        
        return container
    }
    
    private func registerFirebaseRepo(in container: Container) {
        let registeredContainer = Container()
        
        registeredContainer.register(FirebaseRemoteSource.self) { _ in
            FirebaseRemoteSourceImpl()
        }
        
        container.register(FirebaseRepository.self) { _ in
            FirebaseRepositoryImpl(dependencies: registeredContainer)
        }.inObjectScope(.container)
    }
    
    private func registerLocationRepo(in container: Container) {
        let registeredContainer = Container()
        
        registeredContainer.register(LocationRemoteSource.self) { _ in
            LocationRemoteSourceImpl()
        }
        
        container.register(LocationRepository.self) { _ in
            LocationRepositoryImpl(dependencies: registeredContainer)
        }.inObjectScope(.container)
    }
}
