import UIKit
import GPUImage

protocol ToneCurveVCDelegate
{
    func ToneCurveFinish(afterImage: UIImage, isDone: Bool);
}

class ToneCurveLeftView: UIView
{
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        
        CGContextClearRect(context, rect);
        CGContextSaveGState(context);
        
        CGContextAddRect(context, self.frame);
        
        var colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        var components: [CGFloat] = [
            // R, G, B, Alpha
            1.0, 1.0, 1.0, 1.0,
            0.0, 0.0, 0.0, 1.0
        ];
        var locations: [CGFloat] = [0.0, 1.0];
        
        let componentsSize = (UInt(components.count) * UInt(sizeof(CGFloat)));
        let rgbaSize = (UInt(sizeof(CGFloat)) * 4);
        let count = componentsSize / rgbaSize;
        
        var frame = self.bounds;
        var startPoint = frame.origin;
        var endPoint = frame.origin;
        endPoint.y = endPoint.y + frame.size.height;
        
        let gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
        
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        
        CGContextRestoreGState(context);
    }
}
class ToneCurveRightView: UIView
{
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);
        CGContextSaveGState(context);
        
        CGContextAddRect(context, self.frame);
        
        var colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        var components: [CGFloat] = [
            // R, G, B, Alpha
            0.0, 0.0, 0.0, 1.0,
            1.0, 1.0, 1.0, 1.0
        ];
        var locations: [CGFloat] = [0.0, 1.0];
        
        let componentsSize = (UInt(components.count) * UInt(sizeof(CGFloat)));
        let rgbaSize = (UInt(sizeof(CGFloat)) * 4);
        let count = componentsSize / rgbaSize;
        
        var frame = self.bounds;
        var startPoint = frame.origin;
        var endPoint = frame.origin;
        endPoint.x = endPoint.x + frame.size.width;
        
        let gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
        
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        
        CGContextRestoreGState(context);
    }
}

class ToneCurveView: UIView
{
    class TouchPoint: UIView
    {
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame);
            backgroundColor = UIColor.clearColor();
        }

        override func drawRect(rect: CGRect) {
            
            var context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextClearRect(context, rect);
        
            let w = self.frame.size.width;
            let h = self.frame.size.height;
            CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(0, 0, w, h));
            
            CGContextRestoreGState(context);
        }
    }
    
    var points: NSMutableArray!;
    var movePointIndex: Int = 0;
    
    var delegate: ToneCurvePointUpdateDelegate!;

    func initialize(obj: ToneCurvePointUpdateDelegate) {
        
        delegate = obj;
        
        // 長押し
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressAction:");
        longPressGesture.minimumPressDuration = 0.001;
        self.addGestureRecognizer(longPressGesture);
    }
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        
        var location = sender.locationInView(self);
        
        if (sender.state == UIGestureRecognizerState.Began)
        {
            movePointIndex = addPointJudge(positionToPoint(location));
            if(movePointIndex >= points.count) {
                movePointIndex = pointsInsert(positionToPoint(location));
            }
            
            // 描画更新
            draw();
            
            if let target = delegate {
                target.toneCurvePointUpdate(points);
            }
        }
        else if (sender.state == UIGestureRecognizerState.Changed)
        {
            // ポイントを移動
            var p = sender.locationInView(self);
            if(movePointIndex == 0) {
                p.x = 0.0;
            }
            else if(movePointIndex == points.count-1) {
                p.x = self.frame.size.width;
            }
            else {
                p.x = max(p.x, 0);
                p.x = min(p.x, self.frame.size.width);
            }
            p.y = max(p.y, 0);
            p.y = min(p.y, self.frame.size.height);
            points[movePointIndex] = NSValue(CGPoint: positionToPoint(p));
            movePointIndexExchange();
            
            // 描画更新
            draw();
            
            if let target = delegate {
                target.toneCurvePointUpdate(points);
            }
        }
        else if (sender.state == UIGestureRecognizerState.Ended)
        {
            if let target = delegate {
                target.toneCurvePointUpdate(points);
            }
        }
    }

    func setPoints(arr: NSMutableArray) {
        points = arr;
    }
    func pointsInsert(point: CGPoint) -> Int {
        for i in 0 ..< points.count {
            let p = points.objectAtIndex(i).CGPointValue();
            if(p.x > point.x) {
                points.insertObject(NSValue(CGPoint: point), atIndex: i);
                return i;
            }
        }
        points.addObject(NSValue(CGPoint: point));
        return points.count-1;
    }
    func movePointIndexExchange() {
        let movep = points[movePointIndex].CGPointValue();
        if(movePointIndex > 0) {
            let bp = points.objectAtIndex(movePointIndex-1).CGPointValue();
            if(bp.x > movep.x) {
                points.exchangeObjectAtIndex(movePointIndex-1, withObjectAtIndex: movePointIndex);
                movePointIndex--;
            }
        }
        if(movePointIndex < points.count-1) {
            let ap = points.objectAtIndex(movePointIndex+1).CGPointValue();
            if(ap.x < movep.x) {
                points.exchangeObjectAtIndex(movePointIndex+1, withObjectAtIndex: movePointIndex);
                movePointIndex++;
            }
        }
    }
    func addPointJudge(location: CGPoint) -> Int {
        var pointMargin: CGFloat = 0.05;
        for i in 0 ..< points.count {
            let p = points.objectAtIndex(i).CGPointValue();
            if( location.x > p.x - pointMargin && location.x < p.x + pointMargin &&
                location.y > p.y - pointMargin && location.y < p.y + pointMargin )
            {
                return i;
            }
        }
        return points.count;
    }
    
    func draw() {

        var subviews = self.subviews;
        for subview in subviews {
            subview.removeFromSuperview();
        }
        
        // 点を描画
        var pointSize: CGFloat = 10.0;
        for point in points {
            var p = (point as NSValue).CGPointValue();
            p.x = p.x * self.frame.width - (pointSize*0.5);
            p.y = self.frame.height - (p.y * self.frame.height) - (pointSize*0.5);
            self.addSubview(TouchPoint(frame: CGRectMake(p.x, p.y, pointSize, pointSize)));
        }

        // 描画更新
        self.setNeedsDisplay();
    }
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext();
        
        CGContextClearRect(context, self.frame);
        
        CGContextSaveGState(context);
    
        var line = UIBezierPath();
        UIColor.blackColor().setStroke()
        line.lineWidth = 1;

        // 開始点
        var sp = pointToPosition((points.objectAtIndex(0) as NSValue).CGPointValue());
        line.moveToPoint(CGPointMake(sp.x, sp.y));
        
        if (points.count == 2) {
            var ep = pointToPosition((points.lastObject as NSValue).CGPointValue());
            line.addLineToPoint(CGPointMake(ep.x, ep.y));
        }
        else {
            
            for var i=2; i<=points.count; ++i
            {
                var p0: CGPoint!;
                if(i-3 < 0)
                {
                    p0 = pointToPosition((points.objectAtIndex(0) as NSValue).CGPointValue());
                }
                else
                {
                    p0 = pointToPosition((points.objectAtIndex(i-3) as NSValue).CGPointValue());
                }
                var p1 = pointToPosition((points.objectAtIndex(i-2) as NSValue).CGPointValue());
                var p2 = pointToPosition((points.objectAtIndex(i-1) as NSValue).CGPointValue());
                var p3: CGPoint!;
                if(i >= points.count)
                {
                    p3 = pointToPosition((points.lastObject as NSValue).CGPointValue());
                }
                else
                {
                    p3 = pointToPosition((points.objectAtIndex(i) as NSValue).CGPointValue());
                }
                
                let granularity: Int = 10;
                for i in 1 ..< granularity
                {
                    let t: CGFloat = CGFloat(i) * (1.0 / CGFloat(granularity));
                    let tt = t * t;
                    let ttt = tt * t;
                    
                    var pi = CGPointZero;
                    pi.x = 0.5 * (2.0*p1.x+(p2.x-p0.x)*t + (2.0*p0.x-5.0*p1.x+4.0*p2.x-p3.x)*tt + (3.0*p1.x-p0.x-3.0*p2.x+p3.x)*ttt);
                    pi.y = 0.5 * (2.0*p1.y+(p2.y-p0.y)*t + (2.0*p0.y-5.0*p1.y+4.0*p2.y-p3.y)*tt + (3.0*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                    line.addLineToPoint(CGPointMake(pi.x, pi.y));
                }
                line.addLineToPoint(CGPointMake(p2.x, p2.y));
            }
        }

        // 描画
        line.stroke();
        
        CGContextRestoreGState(context);
    }
    
    func midPointForPoints(#p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
    }
    func controlPointForPoints(#p1: CGPoint, p2: CGPoint) -> CGPoint {
        
        var controlPoint = midPointForPoints(p1:p1, p2:p2);
        var diffY = abs(p2.y - controlPoint.y);
    
        if (p1.y < p2.y) {
            controlPoint.y += diffY;
        }
        else if (p1.y > p2.y) {
            controlPoint.y -= diffY;
        }
    
        return controlPoint;
    }
    
    func pointToPosition(point: CGPoint) -> CGPoint {
        return CGPointMake(point.x * self.frame.width, self.frame.height - (point.y * self.frame.height));
    }
    func positionToPoint(position: CGPoint) -> CGPoint {
        return CGPointMake(position.x / self.frame.width, 1.0 - (position.y / self.frame.height));
    }
}

protocol ToneCurvePointUpdateDelegate
{
    func toneCurvePointUpdate(arr: NSMutableArray);
}
class ToneCurveVC: UIViewController
    , UINavigationControllerDelegate
    , UITextFieldDelegate
    , MainVCDelegate
    , ToneCurvePointUpdateDelegate
{
    var delegate: ToneCurveVCDelegate!;
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var rgbSelectControl: UISegmentedControl!
    
    var imageSource: UIImage!;
    var imageNow: UIImage!;
    
    @IBOutlet weak var toneCurveView: ToneCurveView!

    var points: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_r: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_g: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    var points_b: NSMutableArray = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
    
    var movingIndex: Int = 0;
    
    enum rgbselect : Int
    {
        case rgb = 0, red, green, blue
    }
    var rgbSelect: rgbselect = rgbselect.rgb;

    
    func passImageSource(baseImage: UIImage)
    {
        imageSource = baseImage;
        imageNow = ImageProcessing.toneCurveFilter(imageSource,
            redPoints: points_r,
            greenPoints: points_g,
            bluePoints: points_b,
            rgbCompositePoints: points);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // AutoLayoutを使用するとviewDidLoadではframeが確定しない
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // AutoLayoutを使用するとframeが確定するのはここ
        
        preview.image = imageNow;
        
        toneCurveView.initialize(self);
        toneCurveViewUpdate();
        
        rgbSelectControl.addTarget(self, action: "rgbChange:", forControlEvents: UIControlEvents.ValueChanged);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toneCurvePointUpdate(arr: NSMutableArray) {
        switch(rgbSelect)
        {
        case rgbselect.red:
            points_r = arr;
            break;
        case rgbselect.green:
            points_g = arr;
            break;
        case rgbselect.blue:
            points_b = arr;
            break;
        default:
            points = arr;
            break;
        }
        
        imageNow = ImageProcessing.toneCurveFilter(imageSource,
            redPoints: points_r,
            greenPoints: points_g,
            bluePoints: points_b,
            rgbCompositePoints: points);
        preview.image = imageNow;
    }
    
    func toneCurveViewUpdate() {
        switch(rgbSelect)
        {
        case rgbselect.red:
            toneCurveView.setPoints(points_r);
            break;
        case rgbselect.green:
            toneCurveView.setPoints(points_g);
            break;
        case rgbselect.blue:
            toneCurveView.setPoints(points_b);
            break;
        default:
            toneCurveView.setPoints(points);
            break;
        }
        toneCurveView.draw();
    }
    
    func rgbChange(seg: UISegmentedControl)
    {
        switch(seg.selectedSegmentIndex)
        {
        case rgbselect.red.rawValue:
            rgbSelect = rgbselect.red;
            break;
        case rgbselect.green.rawValue:
            rgbSelect = rgbselect.green;
            break;
        case rgbselect.blue.rawValue:
            rgbSelect = rgbselect.blue;
            break;
        default:
            rgbSelect = rgbselect.rgb;
            break;
        }
        toneCurveView.draw();
    }

    @IBAction func resetAction(sender: UIBarButtonItem) {
        points = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
        points_r = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
        points_g = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
        points_b = [NSValue(CGPoint: CGPointMake(0.0, 0.0)), NSValue(CGPoint: CGPointMake(1.0, 1.0))];
        
        toneCurveView.draw();
        
        imageNow = ImageProcessing.toneCurveFilter(imageSource,
            redPoints: points_r,
            greenPoints: points_g,
            bluePoints: points_b,
            rgbCompositePoints: points);
        preview.image = imageNow;
    }
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        
        delegate = self.presentingViewController as ViewController;
        delegate.ToneCurveFinish(imageNow, isDone: true);
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        
        delegate = self.presentingViewController as ViewController;
        delegate.ToneCurveFinish(imageNow, isDone: false);
    }
}

