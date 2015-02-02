import Foundation

// read a file, OSx type playground, relative path first then
// let url: NSURL! = NSBundle.mainBundle().URLForResource("adjusted", withExtension: "AAE")





func int16WithBytes(bytesFull: [Byte], offset: Int) -> UInt16 {
    let bytes = Array(bytesFull[offset..<offset+2])
    let u16raw = UnsafePointer<UInt16>(bytes).memory
    let u16 = CFSwapInt16BigToHost(u16raw)
//    println("u16: \(u16)")
    return u16
}




//let bytes:[Byte] = [0x01, 0x02]

func parseACVFileData(url: NSURL) -> ([Double],[Double],[Double],[Double]) {

    var fileData = NSData(contentsOfURL: url)
    
    let count = fileData!.length / sizeof(Byte)

    // create array of appropriate length:
    var bytes = [Byte](count: count, repeatedValue: 0)
    
    // copy bytes into array
    fileData!.getBytes(&bytes, length:count * sizeof(Byte))
    
    if (count == 0)
    {
        NSLog("failed to init ACVFile with data")
        return ([],[],[],[])
    }
    
    var offset    = Int(0)
    
    var version     = int16WithBytes(bytes, offset)
    offset += 2
    
    var totalCurves = int16WithBytes(bytes, offset)
    offset += 2
    
    
    var curves = [[Double]](count: 0, repeatedValue:[Double]())
    
    var pointRate = 1.0 / 255
    
    println(totalCurves)
    
    // The following is the data for each curve specified by count above
    for var x = 0; x < Int(totalCurves); x++ {
        var pointCount = int16WithBytes(bytes, offset)
        offset += 2
        
        var points = [Double]()
        // point count * 4
        // Curve points. Each curve point is a pair of short integers where
        // the first number is the output value (vertical coordinate on the
        // Curves dialog graph) and the second is the input value. All coordinates have range 0 to 255.
        for var y = 0; y < Int(pointCount); y++ {
            var y = int16WithBytes(bytes, offset)
            offset += 2
            var x = int16WithBytes(bytes, offset)
            offset += 2
            points.append(Double(x) * pointRate)
            points.append(Double(y) * pointRate)
        }
        curves.append(points)
    }
    var composite = curves[0]
    var redCurvePoints = curves[1]
    var greenCurvePoints = curves[2]
    var blueCurvePoints = curves[3]
    return (composite,redCurvePoints,greenCurvePoints,blueCurvePoints)
}



let files = [
    "AshfordBWCurve",
    "AuburnCurve",
    "BloomCurve",
    "ClassicCurve",
    "ElmCurve",
    "EmersonBWCurve",
    "NewburyCurve",
    "WarmCurve"
]

for file in files {
    var url: NSURL! = NSBundle.mainBundle().URLForResource(file, withExtension: "ACV")
    var controlPoints = parseACVFileData(url)
    println(file)
    println(controlPoints.0)
    println(controlPoints.1)
    println(controlPoints.2)
    println(controlPoints.3)
}

