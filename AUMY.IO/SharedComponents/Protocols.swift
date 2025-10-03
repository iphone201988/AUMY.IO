
protocol ServicesEvents {
    func backTo(vc: ViewControllers)
    func resumeShorts()
    func selectedPlaybackSpeed(value: Double)
    func selectedPixel(value: Int?)
    func handlePIP(isEnable: Bool)
    func dismissVC()
}

extension ServicesEvents {
    func backTo(vc: ViewControllers) {}
    func resumeShorts() {}
    func selectedPlaybackSpeed(value: Double) {}
    func selectedPixel(value: Int?) {}
    func handlePIP(isEnable: Bool) {}
    func dismissVC() {}
}
