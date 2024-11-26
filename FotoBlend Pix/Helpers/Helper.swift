
import Foundation
import UIKit

class HeartImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyHeartShape()
    }
    
    func applyHeartShape() {
        let heartPath = UIBezierPath()
       
            let width = self.bounds.width
            let height = self.bounds.height
       
           // Start from the bottom center of the heart
           heartPath.move(to: CGPoint(x: width / 2, y: height))
       
           // Draw the left curve
           heartPath.addCurve(to: CGPoint(x: 0, y: height / 4),
                              controlPoint1: CGPoint(x: width / 2, y: height * 3 / 4),
                              controlPoint2: CGPoint(x: 0, y: height / 2))
       
           // Draw the left top arc
           heartPath.addArc(withCenter: CGPoint(x: width / 4, y: height / 4),
                            radius: width / 4,
                            startAngle: CGFloat.pi,
                            endAngle: 0,
                            clockwise: true)
       
           // Draw the right top arc
           heartPath.addArc(withCenter: CGPoint(x: width * 3 / 4, y: height / 4),
                            radius: width / 4,
                            startAngle: CGFloat.pi,
                            endAngle: 0,
                            clockwise: true)
       
           // Draw the right curve
           heartPath.addCurve(to: CGPoint(x: width / 2, y: height),
                              controlPoint1: CGPoint(x: width, y: height / 2),
                              controlPoint2: CGPoint(x: width / 2, y: height * 3 / 4))
       
           // Close the path
           heartPath.close()
       
           // Create a shape layer for the heart
           let mask = CAShapeLayer()
           mask.path = heartPath.cgPath
        self.layer.mask = mask
    }
}
func applyHexagonMask(to imageView: UIImageView) {
    let path = hexagonPath(for: imageView.bounds)
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    imageView.layer.mask = mask
}

func hexagonPath(for rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    let sideLength = rect.width / 2
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let angle = CGFloat.pi / 3  // 60 degrees in radians
    
    for i in 0..<6 {
        let x = center.x + sideLength * cos(angle * CGFloat(i))
        let y = center.y + sideLength * sin(angle * CGFloat(i))
        if i == 0 {
            path.move(to: CGPoint(x: x, y: y))
        } else {
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
    path.close()
    
    return path
}
class ZigzagViewL: UIImageView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Define the zigzag path
        let path = UIBezierPath()
        let zigzagHeight: CGFloat = 10.0
        let zigzagWidth: CGFloat = rect.height / 10
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        var isRight = true
        for i in stride(from: 0, to: rect.height, by: zigzagWidth) {
            let nextPoint = CGPoint(x: isRight ? zigzagHeight : 0, y: i)
            path.addLine(to: nextPoint)
            isRight.toggle()
        }
        
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        // Set the stroke color and width
        UIColor.black.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }
}

@IBDesignable extension UIButton {
    func applyCornerRadiusAndShadowbutton(cornerRadius: CGFloat = 12, shadowColor: UIColor = .white, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 4.0, backgroundAlpha: CGFloat = 1.0) {
         
         // Set corner radius
         self.layer.cornerRadius = cornerRadius
         
         // Set up shadow properties
         self.layer.shadowColor = shadowColor.cgColor
         self.layer.shadowOffset = shadowOffset
         self.layer.shadowOpacity = shadowOpacity
         self.layer.shadowRadius = shadowRadius
         self.layer.masksToBounds = false

         // Set background opacity
         self.alpha = backgroundAlpha
     }
    @IBInspectable override var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable override var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable override var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UILabel {

    @IBInspectable var borderWidth2: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius2: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor2: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIView {
    func applyCornerRadiusAndShadow(cornerRadius: CGFloat = 12, shadowColor: UIColor = .black, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 4.0, backgroundAlpha: CGFloat = 1.0) {
         
         // Set corner radius
         self.layer.cornerRadius = cornerRadius
         
         // Set up shadow properties
         self.layer.shadowColor = shadowColor.cgColor
         self.layer.shadowOffset = shadowOffset
         self.layer.shadowOpacity = shadowOpacity
         self.layer.shadowRadius = shadowRadius
         self.layer.masksToBounds = false

         // Set background opacity
         self.alpha = backgroundAlpha
     }
    
    @IBInspectable var borderWidth1: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius1: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor1: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
@IBDesignable extension UIImageView {
    
    func addBottomCurve(curveHeight: CGFloat = 50) {
         // Define the size of the image view
         let imageViewBounds = self.bounds
         
         // Create a bezier path with a curved bottom
         let path = UIBezierPath()
         path.move(to: CGPoint(x: 0, y: 0))
         path.addLine(to: CGPoint(x: imageViewBounds.width, y: 0))
         path.addLine(to: CGPoint(x: imageViewBounds.width, y: imageViewBounds.height - curveHeight)) // Adjust height for curve
         path.addQuadCurve(to: CGPoint(x: 0, y: imageViewBounds.height - curveHeight), controlPoint: CGPoint(x: imageViewBounds.width / 2, y: imageViewBounds.height)) // Control point for curve
         path.close()
         
         // Create a shape layer mask
         let maskLayer = CAShapeLayer()
         maskLayer.path = path.cgPath
         
         // Apply the mask to the imageView
         self.layer.mask = maskLayer
     }
}
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(white: 1.0, alpha: 0.0) // Return a clear color if invalid
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

func roundCorner(button:UIButton)
{
    button.layer.cornerRadius = button.frame.size.height/2
    button.clipsToBounds = true
}

func roundCorneView(view:UIView)
{
    view.layer.cornerRadius = view.frame.size.height/2
    view.clipsToBounds = true
}
func makeImageViewCircular(imageview:UIImageView) {
    imageview.layer.cornerRadius = imageview.frame.size.width / 2
    imageview.clipsToBounds = true
    }
func roundCorneLabel(label:UILabel)
{
    label.layer.cornerRadius = label.frame.size.height/2
    label.clipsToBounds = true
}
func applyCornerRadiusToBottomCorners(view: UIView, cornerRadius: CGFloat) {
     // Create a bezier path with rounded corners at bottom-left and bottom-right
     let path = UIBezierPath(roundedRect: view.bounds,
                             byRoundingCorners: [.bottomLeft, .bottomRight],
                             cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
     
     // Create a shape layer with the bezier path
     let maskLayer = CAShapeLayer()
     maskLayer.path = path.cgPath
     
     // Set the shape layer as the mask for the view
     view.layer.mask = maskLayer
 }
extension UIViewController
{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func showToast(message: String, font: UIFont) {
           let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                                  y: self.view.frame.size.height-100,
                                                  width: 150,
                                                  height: 35))
           toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           toastLabel.textColor = UIColor.white
           toastLabel.textAlignment = .center
           toastLabel.font = font
           toastLabel.text = message
           toastLabel.alpha = 1.0
           toastLabel.layer.cornerRadius = 10
           toastLabel.clipsToBounds = true
           self.view.addSubview(toastLabel)
           
           UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
               toastLabel.alpha = 0.0
           }, completion: { (isCompleted) in
               toastLabel.removeFromSuperview()
           })
       }
    
    func setupDatePicker(for textField: UITextField, target: Any, doneAction: Selector) {
        // Initialize the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date // Change to .dateAndTime if needed
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        } // Optional: Choose style
        
        // Set the date picker as the input view for the text field
        textField.inputView = datePicker
        
        // Create a toolbar with a done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: doneAction)
        toolbar.setItems([doneButton], animated: true)
        
        // Set the toolbar as the input accessory view for the text field
        textField.inputAccessoryView = toolbar
    }
    
    
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: radians)
        
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

func curveTopLeftCornersforView(of view: UIView, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: view.bounds,
                               byRoundingCorners: [.topRight],
                               cornerRadii: CGSize(width: radius, height: radius))
       
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       view.layer.mask = mask
   }
func curveTopCornersDown(of view: UIView, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: view.bounds,
                               byRoundingCorners: [.topLeft, .topRight],
                               cornerRadii: CGSize(width: radius, height: radius))
       
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       view.layer.mask = mask
   }

func addDropShadowButtonOne(to button: UIButton) {
    button.layer.shadowColor = UIColor.white.cgColor   // Shadow color
    button.layer.shadowOpacity = 0.5                   // Shadow opacity (0 to 1, where 1 is completely opaque)
    button.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset (width = horizontal, height = vertical)
    button.layer.shadowRadius = 4                      // Shadow blur radius
    button.layer.masksToBounds = false                 // Ensure shadow appears outside the view bounds
}
func addDropShadow(to view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor   // Shadow color
    view.layer.shadowOpacity = 0.5                   // Shadow opacity (0 to 1, where 1 is completely opaque)
    view.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset (width = horizontal, height = vertical)
    view.layer.shadowRadius = 4                      // Shadow blur radius
    view.layer.masksToBounds = false                 // Ensure shadow appears outside the view bounds
}
func applyGradientToButton(button: UIButton) {
        let gradientLayer = CAGradientLayer()
        
        // Define your gradient colors
        gradientLayer.colors = [
            UIColor(hex: "#6934ff").cgColor, // Purple
            UIColor(hex: "#8735fc").cgColor, // Bright Purple
            UIColor(hex: "#a535ff").cgColor  // Violet
        ]
        
        // Set the gradient direction
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
        
        // Set the gradient's frame to match the button's bounds
        gradientLayer.frame = button.bounds
        
        // Apply rounded corners to the gradient
        gradientLayer.cornerRadius = button.layer.cornerRadius
        
        // Add the gradient to the button
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
var currency = ""


func generateRandomCharacter() -> Character {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return characters.randomElement()!
}
struct User:Codable {
    let id : String
    let picData: Data? // Use Data to store the image
    let name: String
    let Address : String
    let gender: String
    let email: String
    let contact: String
    
    var pic: UIImage? {
        if let picData = picData {
            return UIImage(data: picData)
        }
        return nil
    }
}

// Order Things
func generateOrderNumber() -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomOrderNumber = String((0..<6).map { _ in characters.randomElement()! })
    return randomOrderNumber
}
func generateCustomerId() -> Character {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return characters.randomElement()!
}
struct Ordered:Codable {
    let orderNo : String
    let customerId : String
    let user: String
    let product: String
    let DateOfOrder: Date // Array to store scheduled times
    let Discount : String
    let paymentType : String
    let amount: String
    let advancePaymemt: String
    let firstInstallment: String
    let nowAmount: String
    
//    var pic: UIImage? {
//        if let picData = picData {
//            return UIImage(data: picData)
//        }
//        return nil
//    }
}

// Order Products
func generateProductNumber() -> Character {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return characters.randomElement()!
}
   struct Products:Codable {
        let id: String
        let picData: Data? // Use Data to store the image
        let name: String
        let price: String
        let quantities: String
        let DateOfAdd: Date // Array to store scheduled times

       
       var pic: UIImage? {
           if let picData = picData {
               return UIImage(data: picData)
           }
           return nil
       }
    }

var layoutImages: [UIImage] = [UIImage(named: "5")!,UIImage(named: "2")!,UIImage(named: "1515")!,UIImage(named: "4")!,UIImage(named: "1414")!,UIImage(named: "6")!,UIImage(named: "1111")!,UIImage(named: "99")!,UIImage(named: "88")!,UIImage(named: "1")!,UIImage(named: "1313")!,UIImage(named: "1212")!,UIImage(named: "1010")!,UIImage(named: "77")!,UIImage(named: "3")!]


    let name = [
        "Laptop","Smartphone","Tablet","Headphones","Charger","Wireless Mouse","Keyboard","Monitor","Printer","Camera","Smartwatch","Fitness Tracker","Television","Speaker","Projector","External Hard Drive","USB Flash Drive","SD Card","Power Bank","Home Router","Smart Home Hub","Game Console","Video Game","Action Figure","Board Game","Puzzle","Doll","Toy Car","Bicycle","Skateboard","Scooter","Soccer Ball","Basketball","Tennis Racket","Golf Club","Baseball Bat","Yoga Mat","Dumbbell","Resistance Bands","Jump Rope","Treadmill","Elliptical Machine","Exercise Bike","Cookbook","Blender","Microwave","Toaster","Coffee Maker","Slow Cooker","Rice Cooker","Electric Kettle","Food Processor","Air Fryer","Dishwasher","Refrigerator","Stove","Washing Machine","Dryer","Iron","Vacuum Cleaner","Bedding Set","Towels","Shower Curtain","Wall Art","Furniture Set","Couch","Chair","Table","Bookshelf","Desk","Lamp","Rug","Curtains","Clock","Picture Frame","Stationery Set","Notebooks","Pens","Pencils","Highlighters","Markers","Sticky Notes","Envelopes","Mailing Labels","Gift Wrap","Greeting Cards"
    ]

