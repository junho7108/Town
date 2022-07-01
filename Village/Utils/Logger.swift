import Foundation

struct Logger {
    
    static func printLog(_ value: Any) {
        print("--------------- Logger Print -----------------")
        print(value)
        print("----------------------------------------------")
    }
    
    static func debugPrintLog(_ value: Any) {
        print("--------------- Logger DebugPrint -----------------")
        debugPrint(value)
        print("---------------------------------------------------")
    }
}
