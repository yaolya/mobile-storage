import Foundation

// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
}

enum MobileStorageError: Error {
    case imeiNotUnique
    case productDoesntExist
}

class MobileStorageImpl: MobileStorage {
    
    private var mobileSet: Set<Mobile> = []
    
    func getAll() -> Set<Mobile> {
        return mobileSet
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        let r = mobileSet.filter({ $0.imei == imei})
        return r.first
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        guard self.findByImei(mobile.imei) == nil else {
            throw MobileStorageError.imeiNotUnique
        }
        return mobileSet.insert(mobile).memberAfterInsert
    }
    
    func delete(_ product: Mobile) throws {
        guard self.exists(product) else {
            throw MobileStorageError.productDoesntExist
        }
        mobileSet.remove(product)
    }
    
    func exists(_ product: Mobile) -> Bool {
        return mobileSet.contains(product)
    }
}

func testStorage() {
    //create storage
    let ms = MobileStorageImpl()
    
    //create mobile instances
    let m1 = Mobile(imei: "452284487543947", model: "model1")
    let m2 = Mobile(imei: "918275174128321", model: "model2")
    let m3 = Mobile(imei: "987468718341122", model: "model1")
    let m4 = Mobile(imei: "540319307356254", model: "model3")
    
    do {
        //save
        try ms.save(m1)
        print("m1 saved")
        try ms.save(m2)
        print("m2 saved")
        try ms.save(m3)
        print("m3 saved")
        try ms.save(m4)
        print("m4 saved")
        
        //print all
        var mobileSet = ms.getAll()
        for mobile in mobileSet {
            print("imei \(mobile.imei) and model \(mobile.model)")
        }
        
        // find by imei
        print(ms.findByImei("918275174128321"))
        
        // contains
        print(ms.exists(m3))
        
        //delete
        try ms.delete(m2)
        
        mobileSet = ms.getAll()
        for mobile in mobileSet {
            print("imei \(mobile.imei) and model \(mobile.model)")
        }
    }
    catch MobileStorageError.imeiNotUnique {
        print("imei is not unique")
    }
    catch MobileStorageError.productDoesntExist {
        print("such product does not exist")
    }
    catch {
        print("some other error")
    }
    
}

