import Foundation

enum DebitCategory: String{
    case health
    case food
    case services
    case rent
    case transportation
    case entertainment
}

enum TransactionType{
    case debit(_ value: Debit)
    case gain(_ value: Gain)
}

enum GainCategory{
    case pay
    case loan
    case bonus
}

class Transaction{
    var value: Float
    var name: String
    
    init(value: Float, name: String) {
        self.value = value
        self.name = name
    }
}

class Debit: Transaction{
    var assignedCategory: DebitCategory
    init(value: Float, name: String, assignedCategory: DebitCategory){
        self.assignedCategory = assignedCategory
        super.init(value: value, name: name)
    }
}

class Gain: Transaction{
    var assignedCategory: GainCategory
    init(value: Float, name: String, assignedCategory: GainCategory){
        self.assignedCategory = assignedCategory
        super.init(value: value, name: name)
    }
}

class Account {
    var amount: Float = 0 {
        didSet{
            print("Se modifico el monto", amount)
        }
        willSet{
            print("Se va a modificar el monto", newValue)
        }
    }
    var bank: String = ""
    var transactions: [Transaction] = []
    var debits: [Debit] = []
    var gains: [Gain] = []
    
    init(amount: Float, bank: String){
        self.amount = amount
        self.bank = bank
    }
    
    @discardableResult
    func addTransaction(transaction: TransactionType) -> Float{
        
        switch transaction {
        case TransactionType.debit(let debit):
            if (amount-debit.value)<0{
                return 0
            }
            amount -= transaction.value
            transactions.append(debit)
            debits.append(debit)
            break
        case TransactionType.gain(let gain):
            amount += gain.value
            transactions.append(gain)
            gains.append(gain)
            break
        }
        
        return amount
    }
    
    func debits() -> [Transaction] {
        return transactions.filter({$0 is Debit})
    }
    
    func gains() -> [Transaction] {
        return transactions.filter({$0 is Gain})
    }
    
    func transactionsForCategory(category: DebitCategory) -> [Transaction]{
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Debit else {
                return false
            }
            return transaction.assignedCategory == category
        })
    }
    
    func transactionsForCategory(category: GainCategory) -> [Transaction]{
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Gain else {
                return false
            }
            return transaction.assignedCategory == category
        })
    }
    
}

class Person {
    var name: String = ""
    var lastName: String = ""
    var account: Account?
    
    var fullName: String {
        get{
            return "\(name) \(lastName)"
        }
        set{
            name = String(newValue.split(separator: " ").first ?? "")
            lastName = String(newValue.split(separator: " ").last ?? "")
        }
    }
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
    
}

var me = Person(name: "Jose", lastName: "Casales")

let account = Account(amount: 100_00, bank: "Bank")

me.account = account

print(me.account!.amount)

me.account!.addTransaction(transaction: Debit(value: 100, name: "Chunches", assignedCategory: DebitCategory.food))
me.account!.addTransaction(transaction: Debit(value: 100, name: "Lechuga", assignedCategory: DebitCategory.food))
me.account!.addTransaction(transaction: Gain(value: 10_000, name: "Trabajo", assignedCategory: GainCategory.pay))
me.account!.addTransaction(transaction: Gain(value: 10_000, name: "Prestamo", assignedCategory: GainCategory.loan))

print(me.account!.amount)

print(me.fullName)

print(me.account!.transactions[1])

me.fullName = "Francisco Huerta"

print(me.fullName)

let transacciones = me.account?.transactionsForCategory(category: DebitCategory.food) as? [Debit]
let transaccionesGain = me.account?.transactionsForCategory(category: GainCategory.loan) as? [Gain]

for transaction in transacciones ?? []{
    print("\(transaction.name) \n\(transaction.value) \n\(transaction.assignedCategory.rawValue.capitalized)")
}

for transaction in transaccionesGain ?? []{
    print("\(transaction.name) \n\(transaction.value) \n\(transaction.assignedCategory)")
}













