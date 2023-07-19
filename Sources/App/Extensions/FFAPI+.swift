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

extension FFBudgetItemsResponse: Content {}
extension FFPostBudgetItemsRequestBody: Content {}
extension FFDeleteBudgetItemRequestBody: Content {}
extension FFDeleteBudgetCategoryRequestBody: Content {}

extension FFGetTransactionsResponse: Content {}
extension FFPostTransactionsResponse: Content {}
extension FFPostTransactionsRequestBody: Content {}
extension FFDeleteTransactionRequestBody: Content {}

extension FFGetInstitutionsResponse: Content {}
extension FFPostInstitutionsRequestBody: Content {}
extension FFPostInstitutionsResponse: Content {}

extension FFInstitution: Content {
    init(from institution: Institution) {
        self.init(
            id: institution.id,
            name: institution.name,
            userID: institution.$user.id,
            plaidItemID: institution.plaidItemID,
            plaidAccessTokenID: institution.$accessToken.id,
            accounts: institution
                .accounts
                .map { FFBankAccount(from: $0) }
        )
    }
}

extension FFBankAccount: Content {
    init(from bankAccount: BankAccount) {
        self.init(
            id: bankAccount.id,
            accountID: bankAccount.accountID,
            name: bankAccount.name,
            subtype: bankAccount.subtype,
            institutionID: bankAccount.$user.id,
            userID: bankAccount.$institution.id,
            isSyncingTransactions: bankAccount.isSyncingTransactions
        )
    }
}

extension FFBudgetCategory: Content {
    init(from category: BudgetCategory) throws {
        self.init(
            id: category.id,
            userID: category.$user.id,
            name: category.name,
            budgetItems: try category.budgetItems.map { try FFBudgetItem(from: $0) },
            categoryType: FFBudgetCategoryType(from: category.categoryType)
        )
    }
}

extension FFBudgetCategoryType {
    init(from type: BudgetCategoryType) {
        switch type {
        case .savings:
            self = .savings
        case .income:
            self = .income
        case .expense:
            self = .expense
        }
    }
}

extension FFBudgetItem: Content {
    init(from budgetItem: BudgetItem) throws {
        self.init(
            id: budgetItem.id,
            name: budgetItem.name,
            budgetCategoryID: budgetItem.$budgetCategory.id,
            planned: budgetItem.planned,
            transactions: try budgetItem
                .transactions
                .map { try FFTransaction(from: $0) },
            note: budgetItem.note,
            dueDate: budgetItem.dueDate
        )
    }
}

extension FFTransaction: Content {
    init(from transaction: Transaction) throws {
        self.init(
            id: transaction.id,
            name: transaction.name,
            budgetItemID: transaction.$budgetItem.id,
            amount: transaction.amount,
            date: try CustomDateFormatter.toRoundedDate(from: transaction.dateString),
            transactionType: FFTransactionType(from: transaction.transactionType)
        )
    }
}

extension FFTransactionType: Content {
    init(from type: TransactionType) {
        switch type {
        case .income:
            self = .income
        case .expense:
            self = .expense
        }
    }
}
