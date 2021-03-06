// MARK: - SQLOrderingTerm

/// This protocol is an implementation detail of the query interface.
/// Do not use it directly.
///
/// See https://github.com/groue/GRDB.swift/#the-query-interface
///
/// # Low Level Query Interface
///
/// The protocol for all types that can be used as an SQL ordering term, as
/// described at https://www.sqlite.org/syntax/ordering-term.html
public protocol SQLOrderingTerm {
    var reversed: SQLOrderingTerm { get }
    func orderingTermSQL(_ arguments: inout StatementArguments?) -> String
}

// MARK: - SQLOrdering

enum SQLOrdering : SQLOrderingTerm {
    case asc(SQLExpression)
    case desc(SQLExpression)
    
    var reversed: SQLOrderingTerm {
        switch self {
        case .asc(let expression):
            return SQLOrdering.desc(expression)
        case .desc(let expression):
            return SQLOrdering.asc(expression)
        }
    }
    
    func orderingTermSQL(_ arguments: inout StatementArguments?) -> String {
        switch self {
        case .asc(let expression):
            return expression.expressionSQL(&arguments) + " ASC"
        case .desc(let expression):
            return expression.expressionSQL(&arguments) + " DESC"
        }
    }
}
