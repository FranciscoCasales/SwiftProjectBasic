import Foundation

struct Account {
    var amount: Float = 0
    var bank: String = ""
    var transaction: [Float] = []
    
    init(amount: Float, bank: String){
        self.amount = amount
        self.bank = bank
    }
    
    @discardableResult
    mutating func addTransaction(value: Float) -> Float{
        if (amount-value)<0{
            return 0
        }
        amount -= value
        transaction.append(value)
        return amount
    }
}

struct Person {
    var name: String
    var lastName: String
    var account: Account?
}

var me = Person(name: "Jose", lastName: "Casales", account: nil)

let account = Account(amount: 100_00, bank: "Bank")

me.account = account

print(me.account!.amount)

me.account!.addTransaction(value: 20)

print(me.account!.amount)















