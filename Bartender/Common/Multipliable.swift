protocol Multipliable {
    func multiplied(times: Int) -> [Self]
}

extension Multipliable {
    func multiplied(times: Int) -> [Self] {
        var array: [Self] = []
        for _ in 0 ..< times {
            array.append(self)
        }
        return array
    }
}
