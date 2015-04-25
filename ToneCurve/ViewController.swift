import UIKit
import GPUImage
import GoogleMobileAds

protocol MainVCDelegate
{
    func passImageSource(baseImage: UIImage);
}

class ViewController: UIViewController
    , UIImagePickerControllerDelegate
    , UINavigationControllerDelegate
    , ToneCurveVCDelegate
{
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var beforAfterControl: UISegmentedControl!
    var imageSource: UIImage!;
    var imageNow: UIImage!;
    var focusCenter: CIVector!;
    var focusRadius0: Float!;
    var focusRadius1: Float!;
    
    @IBOutlet weak var admobView: GADBannerView!
    
    enum pickerModeType : Int
    {
        case sourceSelect = 0, overlaySelect
    }
    var pickerMode: pickerModeType = pickerModeType.sourceSelect;
    
    enum selectImage : Int
    {
        case befor = 0, after
    }
    var beforAfter: selectImage = selectImage.befor;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // AutoLayoutを使用するとviewDidLoadではframeが確定しない
        
        // 広告Unit IDを設定
        admobView.adUnitID = "ca-app-pub-9023231672440164/4670601409"
        admobView.rootViewController = self
        
        // テスト用デバイスのデバイスIDを登録してからリクエスト
        let req = GADRequest()
        req.testDevices = [
            "f53f84138559f6ef12ec2126ee863bbd"
        ]
        admobView.loadRequest(req)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // AutoLayoutを使用するとframeが確定するのはここ
        beforAfterControl.addTarget(self, action: "beforAfterChange:", forControlEvents: UIControlEvents.ValueChanged);
        
        if let image = showImageView.image
        {
            // まあありえないよね
        }
        else
        {
            // 最初に画像を選択
            pickerMode = pickerModeType.sourceSelect;
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            
            if(UIImagePickerController.isSourceTypeAvailable(sourceType))
            {
                let picker: UIImagePickerController = UIImagePickerController();
                picker.sourceType = sourceType;
                picker.delegate = self;
                self.presentViewController(picker, animated: true, completion: nil);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageAction(sender: UIBarButtonItem) {
        
        pickerMode = pickerModeType.sourceSelect;
        
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            let picker: UIImagePickerController = UIImagePickerController();
            picker.sourceType = sourceType;
            picker.delegate = self;
            self.presentViewController(picker, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func filtersSelectAction(sender: UIBarButtonItem) {
        
        if let image = imageSource
        {
            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("ToneCurveVC") as! ToneCurveVC;
            nextView.passImageSource((self.beforAfter == selectImage.befor) ? self.imageSource : self.imageNow);
            self.presentViewController(nextView, animated: true, completion: nil);
        }
    }
    
    @IBAction func imageSave(sender: UIBarButtonItem) {
        if let image = imageNow
        {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil);
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>)
    {
        if error != nil
        {
            let alert:UIAlertController = UIAlertController(title:"保存失敗",
                message:NSString(format:"errorcode : %d", error.code) as String,
                preferredStyle: UIAlertControllerStyle.Alert);
            
            //Cancel 一つだけしか指定できない
            let cancelAction:UIAlertAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel,
                handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil);
        }
    }
    
    func ToneCurveFinish(afterImage: UIImage, isDone: Bool) {
        
        if(isDone)
        {
            imageNow = afterImage;
            self.showImageView.image = imageNow;
            beforAfter = selectImage.after;
            beforAfterControl.selectedSegmentIndex = beforAfter.rawValue;
        }
        
        // 閉じる
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        });
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let dic: NSDictionary = info;
        
        imageSource = dic.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage;
        imageNow = dic.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage;
        
        // そのまま表示
        self.showImageView.image = self.imageSource;
        
        beforAfter = selectImage.befor;
        beforAfterControl.selectedSegmentIndex = beforAfter.rawValue;
        
        // 閉じる
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            // 画像選択後すぐにトーンカーブビューへ
            if let image = self.imageSource
            {
                let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("ToneCurveVC") as! ToneCurveVC;
                nextView.passImageSource((self.beforAfter == selectImage.befor) ? self.imageSource : self.imageNow);
                self.presentViewController(nextView, animated: true, completion: nil);
            }
        });
    }
    
    func beforAfterChange(seg: UISegmentedControl)
    {
        if(seg.selectedSegmentIndex == selectImage.after.rawValue)
        {
            beforAfter = selectImage.after;
            self.showImageView.image = imageNow;
        }
        else
        {
            beforAfter = selectImage.befor;
            self.showImageView.image = imageSource;
        }
    }
    
}

