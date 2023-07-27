//
//  FFAPI+.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import FFAPI
import Vapor

extension FFSessionResponse: Content {}

extension FFUser {
    init(from user: User) {
        self.init(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            passwordHash: user.passwordHash
        )
    }
}

extension FFRefreshToken {
    init(from refreshToken: RefreshToken) {
        self.init(userID: refreshToken.$user.id, token: refreshToken.token)
    }
}

extension FFRegisterRequest: Validatable, Content {
    /// Validates the RegisterRequest.
    public static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirmPassword", as: String.self, is: .count(8...))
    }
}

extension User {
    /// Creates a new user from a `RegisterRequest` and encrypts the password.
    /// - Parameters:
    ///   - request: The registration request sent in the body.
    convenience init(from request: FFRegisterRequest) throws {
        self.init(
            firstName: request.firstName,
            lastName: request.lastName,
            email: request.email,
            passwordHash: try Bcrypt.hash(request.password)
        )
    }
}

extension FFLoginRequest: Validatable, Content {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension FFCreateLinkTokenRequestBody: Content {}
extension FFCreateLinkTokenResponse: Content {}

extension FFPostBudgetCategoriesRequestBody: Content {}
extension FFBudgetCategoriesResponse: Content {}

extension FFBudgetItemRequestBody: Content {}

extension FFGetInstitutionsResponse: Content {}
extension FFPostInstitutionsRequestBody: Content {}
extension FFPostInstitutionsResponse: Content {}

extension FFInstitution: Content {
    init(from institution: Institution) {
        self.init(
            name: institution.name,
            userID: institution.$user.id,
            plaidItemID: institution.plaidItemID,
            plaidAccessTokenID: institution.$accessToken.id,
            accounts: institution.accounts
        )
    }
}

extension FFBudgetCategory: Content {
    init(from category: BudgetCategory) throws {
        self.init(
            id: try category.requireID(),
            userID: category.$user.id,
            name: category.name,
            budgetItems: try category.budgetItems.map { try FFBudgetItem(from: $0, categoryID: category.requireID()) }
        )
    }
}

extension FFBudgetItem: Content {
    init(from item: BudgetItem, categoryID: UUID) throws {
        self.init(
            id: try item.requireID(),
            budgetCategoryID: categoryID,
            type: FFCategoryType(from: item.category.type),
            name: item.name,
            planned: item.planned,
            dueDate: item.dueDate
        )
    }
}

extension FFCategoryType {
    init(from type: CategoryType) {
        switch type {
        case .income:
            self = .income
        case .expense:
            self = .expense
        }
    }
}
