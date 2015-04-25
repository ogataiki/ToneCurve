import UIKit
import CoreImage
import GPUImage

class ImageProcessing
{    
    //
    // GPUImage how to use
    //
    
    //
    // Color adjustments
    //
    
    // 輝度
    class func brightnessFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageBrightnessFilter();
        filter.brightness = 0.1;
        return filter.imageByFilteringImage(baseImage);
    }
    class func brightnessFilter(baseImage: UIImage
        , brightness: CGFloat
        ) -> UIImage
    {
        // brightness : -1.0 ~ 1.0
        var filter = GPUImageBrightnessFilter();
        filter.brightness = brightness;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 露出(ISO)
    class func exposureFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageExposureFilter();
        filter.exposure = 0.5;
        return filter.imageByFilteringImage(baseImage);
    }
    class func exposureFilter(baseImage: UIImage
        , exposure: CGFloat
        ) -> UIImage
    {
        // exposure : -10.0 ~ 10.0
        var filter = GPUImageExposureFilter();
        filter.exposure = exposure;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // コントラスト
    class func contrastFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageContrastFilter();
        filter.contrast = 1.5;
        return filter.imageByFilteringImage(baseImage);
    }
    class func contrastFilter(baseImage: UIImage
        , contrast: CGFloat
        ) -> UIImage
    {
        // contrast : 0.0 ~ 4.0
        var filter = GPUImageContrastFilter();
        filter.contrast = contrast;
        return filter.imageByFilteringImage(baseImage);
    }

    // ガンマ値
    class func gammaFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageGammaFilter();
        filter.gamma = 1.1;
        return filter.imageByFilteringImage(baseImage);
    }
    class func gammaFilter(baseImage: UIImage
        , gamma: CGFloat
        ) -> UIImage
    {
        // gamma : 0.0 ~ 3.0
        var filter = GPUImageGammaFilter();
        filter.gamma = gamma;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // カラーマトリクス変換
    class func colorMatrixFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageColorMatrixFilter();
        var r : GLfloat = 0.0;
        var g : GLfloat = 1.0;
        var b : GLfloat = 0.0;
        var a : GLfloat = 0.0;
        filter.colorMatrix = GPUMatrix4x4(
            one:    GPUVector4(one: r, two: r, three: r, four: r),
            two:    GPUVector4(one: g, two: g, three: g, four: g),
            three:  GPUVector4(one: b, two: b, three: b, four: b),
            four:   GPUVector4(one: a, two: a, three: a, four: a));
        filter.intensity = 0.1;
        return filter.imageByFilteringImage(baseImage);
    }
    class func colorMatrixFilter(baseImage: UIImage
        , matrix: GPUMatrix4x4
        , intensity: CGFloat
        ) -> UIImage
    {
        // GPUMatrix4x4(one: GPUVector4(one: GLfloat, two: GLfloat, three: GLfloat, four: GLfloat), two: GPUVector4, three: GPUVector4, four: GPUVector4);
        
        // colorMatrix : GPUMatrix4x4 画像の各色を変換するために使用
        // intensity : 新たに形質転換色各画素の元の色を置き換える度合い
        var filter = GPUImageColorMatrixFilter();
        filter.colorMatrix = matrix;
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // RGB調整
    class func rgbFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBFilter();
        filter.red = 0.5;
        filter.green = 1.0;
        filter.blue = 0.0;
        return filter.imageByFilteringImage(baseImage);
    }
    class func rgbFilter(baseImage: UIImage
        , red: CGFloat
        , green: CGFloat
        , blue: CGFloat
        ) -> UIImage
    {
        // red,green,blue : 0.0 ~ 1.0
        var filter = GPUImageRGBFilter();
        filter.red = red;
        filter.green = green;
        filter.blue = blue;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 色相変換 角度で指定(180.0で逆になる？)
    class func hueFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageHueFilter();
        filter.hue = 90;
        return filter.imageByFilteringImage(baseImage);
    }
    class func hueFilter(baseImage: UIImage
        , hue: CGFloat
        ) -> UIImage
    {
        // hue : 180で逆になる？
        var filter = GPUImageHueFilter();
        filter.hue = hue;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // トーンカーブ##
    class func toneCurveFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageToneCurveFilter();
        var rArray = NSArray(arrayLiteral:
            NSValue(CGPoint: CGPointMake(0.0, 0.0)),
            NSValue(CGPoint: CGPointMake(0.25, 0.75)),
            NSValue(CGPoint: CGPointMake(0.5, 0.5)),
            NSValue(CGPoint: CGPointMake(0.75, 0.25)),
            NSValue(CGPoint: CGPointMake(1.0, 1.0)));
        var gArray = NSArray(arrayLiteral:
            NSValue(CGPoint: CGPointMake(1.0, 1.0)),
            NSValue(CGPoint: CGPointMake(0.25, 0.75)),
            NSValue(CGPoint: CGPointMake(0.5, 0.5)),
            NSValue(CGPoint: CGPointMake(0.75, 0.25)),
            NSValue(CGPoint: CGPointMake(0.0, 0.0)));
        var bArray = NSArray(arrayLiteral:
            NSValue(CGPoint: CGPointMake(1.0, 1.0)),
            NSValue(CGPoint: CGPointMake(0.25, 0.75)),
            NSValue(CGPoint: CGPointMake(0.5, 0.5)),
            NSValue(CGPoint: CGPointMake(0.75, 0.25)),
            NSValue(CGPoint: CGPointMake(0.0, 0.0)));
        filter.redControlPoints = rArray as [AnyObject];
        filter.greenControlPoints = gArray as [AnyObject];
        filter.blueControlPoints = bArray as [AnyObject];
        return filter.imageByFilteringImage(baseImage);
    }
    class func toneCurveFilter(baseImage: UIImage
        , redPoints: NSArray
        , greenPoints: NSArray
        , bluePoints: NSArray
        ) -> UIImage
    {
        // redPoints,greenPoints,bluePoints : NSArray from CGPoint
        // CGPoint : (0.0, 0.0) ~ (1.0, 1.0)
        // NSArray Default : [(0.0, 0.0), (0.5, 0.5), (1.0, 1.0)]
        var filter = GPUImageToneCurveFilter();
        filter.redControlPoints = redPoints as [AnyObject];
        filter.greenControlPoints = greenPoints as [AnyObject];
        filter.blueControlPoints = bluePoints as [AnyObject];
        return filter.imageByFilteringImage(baseImage);
    }
    class func toneCurveFilter(baseImage: UIImage
        , points: NSArray
        ) -> UIImage
    {
        // CGPoint : (0.0, 0.0) ~ (1.0, 1.0)
        // NSArray Default : [(0.0, 0.0), (0.5, 0.5), (1.0, 1.0)]
        var filter = GPUImageToneCurveFilter();
        filter.rgbCompositeControlPoints = points as [AnyObject];
        return filter.imageByFilteringImage(baseImage);
    }
    class func toneCurveFilter(baseImage: UIImage
        , redPoints: NSArray
        , greenPoints: NSArray
        , bluePoints: NSArray
        , rgbCompositePoints: NSArray
        ) -> UIImage
    {
        var filter = GPUImageToneCurveFilter();
        filter.redControlPoints = redPoints as [AnyObject];
        filter.greenControlPoints = greenPoints as [AnyObject];
        filter.blueControlPoints = bluePoints as [AnyObject];
        filter.rgbCompositeControlPoints = rgbCompositePoints as [AnyObject];
        return filter.imageByFilteringImage(baseImage);
    }

    // ハイライト調整
    class func highlightShadowFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageHighlightShadowFilter();
        filter.shadows = 0.2;
        filter.highlights = 0.8;
        return filter.imageByFilteringImage(baseImage);
    }
    class func highlightShadowFilter(baseImage: UIImage
        , shadows: CGFloat
        , highlights: CGFloat
        ) -> UIImage
    {
        // shadows : 0.0 ~ 1.0 Default 0.0
        // highlights : 0.0 ~ 1.0 Default 1.0
        var filter = GPUImageHighlightShadowFilter();
        filter.shadows = shadows;
        filter.highlights = highlights;
        return filter.imageByFilteringImage(baseImage);
    }

    // 色反転
    class func colorInvertFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageColorInvertFilter().imageByFilteringImage(baseImage);
    }
    
    // グレースケール変換
    class func grayscaleFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageGrayscaleFilter().imageByFilteringImage(baseImage);
    }
    
    // 単色変換
    class func falseColorFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageFalseColorFilter().imageByFilteringImage(baseImage);
    }
    class func falseColorFilter(baseImage: UIImage
        , firstColor: GPUVector4
        , secondColor: GPUVector4
        ) -> UIImage
    {
        // 各画素の輝度に基づいて、単色バージョンに画像を変換する
        // firstColor, secondColor : GPUVector4(one: GLfloat, two: GLfloat, three: GLfloat, four: GLfloat)
        var filter = GPUImageFalseColorFilter();
        filter.firstColor = firstColor;
        filter.secondColor = secondColor;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // セピア
    class func sepiaFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageSepiaFilter().imageByFilteringImage(baseImage);
    }
    class func sepiaFilter(baseImage: UIImage
        , intensity: CGFloat
        ) -> UIImage
    {
        // intensity : 0.0 ~ 1.0
        var filter = GPUImageSepiaFilter();
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // アルファチャンネル調整
    class func opacityFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageOpacityFilter();
        filter.opacity = 0.5;
        return filter.imageByFilteringImage(baseImage);
    }
    class func opacityFilter(baseImage: UIImage
        , opacity: CGFloat
        ) -> UIImage
    {
        // opacity : 0.0 ~ 1.0
        var filter = GPUImageOpacityFilter();
        filter.opacity = opacity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 輝度による2値化
    class func luminanceThresholdFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageLuminanceThresholdFilter().imageByFilteringImage(baseImage);
    }
    class func luminanceThresholdFilter(baseImage: UIImage
        , threshold: CGFloat
        ) -> UIImage
    {
        // threshold : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageLuminanceThresholdFilter();
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 平均輝度による2値化
    class func averageLuminanceThresholdFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageAverageLuminanceThresholdFilter().imageByFilteringImage(baseImage);
    }
    class func averageLuminanceThresholdFilter(baseImage: UIImage
        , thresholdMultiplier: CGFloat
        ) -> UIImage
    {
        // これは、閾値が継続的にシーンの平均輝度に基づいて調整される閾値化操作を適用する
        // threshold : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageAverageLuminanceThresholdFilter();
        filter.thresholdMultiplier = thresholdMultiplier;
        return filter.imageByFilteringImage(baseImage);
    }
    

    //
    // Image processing
    //
    
    // 2D変形
    class func transform2DFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageTransformFilter();
        var transform: CGAffineTransform;
        transform = CGAffineTransformMakeScale(0.75, 0.75);
        transform = CGAffineTransformTranslate(transform, 0, 0.5);
        filter.affineTransform = transform;
        filter.ignoreAspectRatio = true;
        return filter.imageByFilteringImage(baseImage);
    }
    class func transformFilter(baseImage: UIImage
        , transform: CGAffineTransform
        , ignoreAspectRatio: Bool
        ) -> UIImage
    {
        // パラメータ例
        //var t: CGAffineTransform;
        //t = CGAffineTransformMakeScale(0.75, 0.75); //　縮小
        //t = CGAffineTransformTranslate(t, 0, 0.5);  // 移動
        
        var filter = GPUImageTransformFilter();
        filter.affineTransform = transform;
        filter.ignoreAspectRatio = ignoreAspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }

    // 3D変形
    class func transform3DFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageTransformFilter();
        var transform = CATransform3DIdentity;
        transform.m34 = 0.4;
        transform.m33 = 0.4;
        transform = CATransform3DRotate(transform, 0.75, 1.0, 0.0, 0.0);
        filter.transform3D = transform;
        filter.ignoreAspectRatio = true;
        return filter.imageByFilteringImage(baseImage);
    }
    class func transformFilter(baseImage: UIImage
        , transform: CATransform3D
        , ignoreAspectRatio: Bool
        ) -> UIImage
    {
        // パラメータ例
        //var t = CATransform3DIdentity;
        //t.m34 = 0.4;
        //t.m33 = 0.4;
        //t = CATransform3DRotate(t, 0.75, 1.0, 0.0, 0.0);

        var filter = GPUImageTransformFilter();
        filter.transform3D = transform;
        filter.ignoreAspectRatio = ignoreAspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }

    // クリッピング
    class func cropFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageCropFilter();
        filter.cropRegion = CGRectMake(0.25, 0.25, 0.5, 0.5);

        // GPUImageCropFilterのforceProcessingAtSizeが動かないので
        var tmp = GPUImageTransformFilter();
        tmp.forceProcessingAtSize(baseImage.size);
        return tmp.imageByFilteringImage(filter.imageByFilteringImage(baseImage));
    }
    class func cropFilter(baseImage: UIImage
        , cropRegion: CGRect
        ) -> UIImage
    {
        var filter = GPUImageCropFilter();
        filter.cropRegion = cropRegion;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ダウンサンプリング
    class func lanczosResamplingFilter(baseImage:UIImage) -> UIImage
    {
        return GPUImageLanczosResamplingFilter().imageByFilteringImage(baseImage);
    }
    
    // シャープネス
    class func sharpenFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageSharpenFilter();
        filter.sharpness = 0.5;
        return filter.imageByFilteringImage(baseImage);
    }
    class func sharpenFilter(baseImage: UIImage
        , sharpness: CGFloat
        ) -> UIImage
    {
        // sharpness : -4.0 ~ 4.0 Default 0.0
        var filter = GPUImageSharpenFilter();
        filter.sharpness = sharpness;
        return filter.imageByFilteringImage(baseImage);
    }

    // アンシャープマスク
    class func unsharpMaskFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageUnsharpMaskFilter();
        filter.blurRadiusInPixels = 2.0;
        filter.intensity = 2.0;
        return filter.imageByFilteringImage(baseImage);
    }
    class func unsharpMaskFilter(baseImage: UIImage
        , blurSize: CGFloat
        , intensity: CGFloat
        ) -> UIImage
    {
        // blurRadiusInPixels : 0.0 ~ Default 1.0
        // intensity : 0.0 ~ Default 1.0
        var filter = GPUImageUnsharpMaskFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ガウスぼかし
    class func gaussianBlurFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageGaussianBlurFilter();
        filter.blurRadiusInPixels = 2.0;
        return filter.imageByFilteringImage(baseImage);
    }
    class func gaussianBlurFilter(baseImage: UIImage
        , blurSize: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Default 1.0
        var filter = GPUImageGaussianBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        return filter.imageByFilteringImage(baseImage);
    }
 
    // 円形フォーカス的ぼかし
    class func gaussianSelectiveBlurFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageGaussianSelectiveBlurFilter();
        filter.blurRadiusInPixels = 5.0;
        filter.excludeCircleRadius = 0.4;
        filter.excludeCirclePoint = CGPointMake(0.5, 0.5);
        filter.excludeBlurSize = 0.2;
        filter.aspectRatio = 1.0;
        return filter.imageByFilteringImage(baseImage);
    }
    class func gaussianSelectiveBlurFilter(baseImage: UIImage
        , blurSize: CGFloat
        , radius: CGFloat
        , point: CGPoint
        , exBlurSize: CGFloat
        , aspectRatio: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Defalut 1.0 ぼかし強度
        // radius : 0.0 ~ 1.0 ぼかし除外(フォーカス)半径
        // point : (0.0, 0.0) ~ (1.0, 1.0) ぼかし除外(フォーカス)円の中心位置
        // exBlurSize : 0.0 ~ フォーカス範囲とぼかし範囲の境界をどれくらいの幅にするか
        // aspectRatio : Default 1.0 円の歪み(0.0だと縦長？よくわからない)
        var filter = GPUImageGaussianSelectiveBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.excludeCircleRadius = radius;
        filter.excludeCirclePoint = point;
        filter.excludeBlurSize = exBlurSize;
        filter.aspectRatio = aspectRatio;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // チルトシフト(上下ぼかし)
    class func tiltShiftFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageTiltShiftFilter();
        filter.blurRadiusInPixels = 3.0;
        filter.topFocusLevel = 0.4;
        filter.bottomFocusLevel = 0.6;
        filter.focusFallOffRate = 0.2;
        return filter.imageByFilteringImage(baseImage);
    }
    class func tiltShiftFilter(baseImage: UIImage
        , blurSize: CGFloat
        , topFocusLevel: CGFloat
        , bottomFocusLevel: CGFloat
        , focusFallOffRate: CGFloat
        ) -> UIImage
    {
        // blurSize : 0.0 ~ Default 2.0
        // topFocusLevel : Default 0.4 焦点領域上部 bottomFocusLeveより低く設定
        // bottomFocusLevel : Default 0.6 焦点領域下部 topFocusLevelより高く設定
        // focusFallOffRate : Default 0.2 画像が合焦領域から離れてぼやけを取得する速度(?)
        var filter = GPUImageTiltShiftFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.topFocusLevel = topFocusLevel;
        filter.bottomFocusLevel = bottomFocusLevel;
        filter.focusFallOffRate = focusFallOffRate;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 平滑化ぼかし?
    class func boxBlurFilter(baseImage :UIImage) -> UIImage
    {
        var filter = GPUImageBoxBlurFilter();
        filter.blurRadiusInPixels = 2.0;
        return filter.imageByFilteringImage(baseImage);
    }
    class func boxBlurFilter(baseImage :UIImage
        , blurSize: CGFloat
        ) -> UIImage
    {
        var filter = GPUImageBoxBlurFilter();
        filter.blurRadiusInPixels = blurSize;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 3x3の畳み込みカーネル##
    class func convolution3x3Filter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImage3x3ConvolutionFilter();
        var kernel = GPUMatrix3x3(
            // 輪郭強調のサンプル
            one:    GPUVector3(one: 0, two: 1, three: 0),
            two:    GPUVector3(one: 1, two: -4, three: 1),
            three:  GPUVector3(one: 0, two: 1, three: 0));
        filter.convolutionKernel = kernel;
        return filter.imageByFilteringImage(baseImage);
    }
    class func convolution3x3Filter(baseImage: UIImage
        , kernel: GPUMatrix3x3
        ) -> UIImage
    {
        // 畳み込みカーネルは、ピクセルとその周囲8画素に適用する値の3×3行列である。
        // 行列は、左上ピクセルの幸福のone.oneと右下のthree.threeで、行優先順に指定されている。
        // 行列の値が1.0にならない場合は、イメージが明るくまたは暗くすることができた。
        // kernel : GPUMatrix3x3(one: GPUVector3, two: GPUVector3, three: GPUVector3);
        var filter = GPUImage3x3ConvolutionFilter();
        filter.convolutionKernel = kernel;
        return filter.imageByFilteringImage(baseImage);
    }

    // ゾーベルエッジ検出白強調
    class func sobelEdgeDetectionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageSobelEdgeDetectionFilter().imageByFilteringImage(baseImage);
    }
    class func sobelEdgeDetectionFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.001くらいが丁度いい
        // texelHeight : 0.001くらいが丁度いい
        var filter = GPUImageSobelEdgeDetectionFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // キャニー法エッジ検出白強調
    class func cannyEdgeDetectionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageCannyEdgeDetectionFilter().imageByFilteringImage(baseImage);
    }
    class func cannyEdgeDetectionFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        , blurSize: CGFloat
        , upperThreshold: CGFloat
        , lowerThreshold: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.001くらいが丁度いい
        // texelHeight : 0.001くらいが丁度いい
        // blurSize: 0.0 ~ Default 1.0 検出前にぼかす度合い
        // upperThreshold : Default 0.4 エッジとして検出する閾値
        // lowerThreshold : Default 0.1 エッジとして検出しない閾値
        
        var filter = GPUImageCannyEdgeDetectionFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        filter.blurRadiusInPixels = blurSize;
        filter.upperThreshold = upperThreshold;
        filter.lowerThreshold = lowerThreshold;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 頂点検出Harris法
    class func harrisCornerDetectionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageHarrisCornerDetectionFilter().imageByFilteringImage(baseImage);
    }
    class func harrisCornerDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageHarrisCornerDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }
 
    // 頂点検出 Noble法
    class func nobleCornerDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageNobleCornerDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func nobleCornerDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageNobleCornerDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }

    // 頂点検出 ShiTomasi法
    class func shiTomasiFeatureDetectionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageShiTomasiFeatureDetectionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    class func shiTomasiFeatureDetectionFilter(baseImage: UIImage
        , blurSize: CGFloat
        , sensitivity: CGFloat
        , threshold: CGFloat
        ) -> UIImage
    {
        // blurSize : Default 1.0 コーナー検出の実装の一部として適用されるぼかしの相対的な大きさ
        // sensitivity : Default 5.0 内部スケーリング係数は、フィルタで生成cornernessマップのダイナミックレンジを調整するために適用
        // threshold : コーナーとして検出される閾値。
        var filter = GPUImageShiTomasiFeatureDetectionFilter();
        filter.blurRadiusInPixels = blurSize;
        filter.sensitivity = sensitivity;
        filter.threshold = threshold;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハリスのコーナー検出フィルタの一部として使用される(で、どういう効果なの？)
    class func nonMaximumSuppressionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageNonMaximumSuppressionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ハリスのコーナー検出フィルタの一部として使用される(で、どういう効果なの？)
    // 使ってみたら、青背景に赤と水色で輪郭線が浮き出てきたけど。。。
    class func xyDerivativeFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageXYDerivativeFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 十字ジェネレータ？これはこのまま動かない
    class func crosshairGenerator(baseImage: UIImage
        , crosshairWidth: CGFloat
        ) -> UIImage
    {
        var filter = GPUImageCrosshairGenerator();
        filter.crosshairWidth = crosshairWidth;
        return filter.imageByFilteringImage(baseImage);
    }

    // 拡張フィルタ?(使ってみたらグレースケールっぽい画像になったけど。。。)
    // 何度か繰り返し適用したら、重なりのあるドット絵みたいになった！
    class func dilationFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageDilationFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 全てのカラーチャンネルに作用する拡張フィルタ?(使ってみたら何が変わったかかわからない画像になったけど。。。)
    // 何度か繰り返し適用したら、重なりのあるドット絵みたいになった！
    class func rgbDilationFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBDilationFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 侵食フィルタ?(使ってみたらグレースケールっぽい画像になったけど。。。)
    // 何度か繰り返し適用したら、油絵的な感じに滲んだ！
    class func erosionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageErosionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 全てのカラーチャンネルに作用する侵食フィルタ?(使ってみたら何が変わったかかわからない画像になったけど。。。)
    // 何度か繰り返し適用したら、油絵的な感じに滲んだ！
    class func rgbErosionFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBErosionFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // これは、同じ半径の膨張が続く画像の赤チャンネル、上の浸食を実行します。半径1-4画素の範囲で、初期化時に設定されている。
    // (使ってみたらグレースケールっぽい画像になったけど。。。)
    class func openingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageOpeningFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 赤チャネル、すべてのカラーチャンネルに作用することを除いて、GPUImageOpeningFilterと同じである。
    // (使ってみたら何が変わったかかわからない画像になったけど。。。)
    class func rgbOpeningFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBOpeningFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // これは、同じ半径の侵食に続く画像の赤チャンネルに拡張を行う?
    // (使ってみたらグレースケールっぽい画像になったけど。。。)
    class func closingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageClosingFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 赤チャネル、すべてのカラーチャンネルに作用することを除いて、GPUImageClosingFilterと同じである。
    // (使ってみたら何が変わったかかわからない画像になったけど。。。)
    class func rgbClosingFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageRGBClosingFilter();
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ローパスフィルタ
    class func lowPassFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageLowPassFilter();
        filter.filterStrength = 0.2;
        return filter.imageByFilteringImage(baseImage);
    }
    class func lowPassFilter(baseImage: UIImage
        , filterStrength: CGFloat
        ) -> UIImage
    {
        // filterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageLowPassFilter();
        filter.filterStrength = filterStrength;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハイパスフィルタ
    class func highPassFilter(baseImage: UIImage) -> UIImage
    {
        var filter = GPUImageHighPassFilter();
        filter.filterStrength = 0.2;
        return filter.imageByFilteringImage(baseImage);
    }
    class func highPassFilter(baseImage: UIImage
        , filterStrength: CGFloat
        ) -> UIImage
    {
        // filterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageHighPassFilter();
        filter.filterStrength = filterStrength;
        return filter.imageByFilteringImage(baseImage);
    }

    // 動き検出器?(使ってみたら、動きのないところが白く、動きのあるところ[滝とか]が水色〜ピンクになった)
    class func motionDetector(baseImage: UIImage) -> UIImage
    {
        return GPUImageMotionDetector().imageByFilteringImage(baseImage);
    }
    class func motionDetector(baseImage: UIImage
        , lowPassFilterStrength: CGFloat
        ) -> UIImage
    {
        // lowPassFilterStrength : 0.0 ~ 1.0 Default 0.5
        var filter = GPUImageMotionDetector();
        filter.lowPassFilterStrength = lowPassFilterStrength;
        return filter.imageByFilteringImage(baseImage);
    }
    
    
    //
    // Blending modes
    //
    
    // 選択的に第二の画像と最初の画像の色を透明にする
    class func chromaKeyFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageChromaKeyFilter();
        filter.thresholdSensitivity = 0.4;
        filter.smoothing = 0.1;

        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    class func chromaKeyFilter(baseImage: UIImage
        , overlayImage: UIImage
        , thresholdSensitivity: CGFloat
        , smoothing: CGFloat
        ) -> UIImage
    {
        // 画像内の指定された色については、これはGPUImageChromaKeyBlendFilterに類似して0にするアルファチャンネルを設定するだけの代わりに、
        // これは単に第二の画像を取り込むとしないマッチング色について第二の画像にブレンディングの所与の色を透明に変わり。
        // thresholdSensitivity : Default 0.4 どれだけの近さを対象にするか
        // smoothing : Default 0.1 どのくらいスムーズに色変えするか
        var filter = GPUImageChromaKeyFilter();
        filter.thresholdSensitivity = thresholdSensitivity;
        filter.smoothing = smoothing;
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 選択的に第二の画像と最初の画像の色を置き換える
    // 同じ画像で片方に他のフィルタかけたものを使うと面白い
    class func chromaKeyBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageChromaKeyBlendFilter();
        filter.thresholdSensitivity = 0.4;
        filter.smoothing = 0.1;

        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    class func chromaKeyBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        , thresholdSensitivity: CGFloat
        , smoothing: CGFloat
        ) -> UIImage
    {
        // thresholdSensitivity : Default 0.4 どれだけの近さを対象にするか
        // smoothing : Default 0.1 どのくらいスムーズに色変えするか
        var filter = GPUImageChromaKeyBlendFilter();
        filter.thresholdSensitivity = thresholdSensitivity;
        filter.smoothing = smoothing;
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    
    // 二つの画像の溶解合成する
    class func dissolveBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageDissolveBlendFilter();
        filter.mix = 0.5;

        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    class func dissolveBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        , mix: CGFloat
        ) -> UIImage
    {
        // mix : 0.0 ~ 1.0 Default 0.5 どの程度上書きを強めるか
        var filter = GPUImageDissolveBlendFilter();
        filter.mix = mix;
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    
    // 二つの画像の乗算ブレンド
    class func multiplyBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageMultiplyBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の加算ブレンド
    class func addBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageAddBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    
    // 二つの画像の分割ブレンド
    class func divideBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageDivideBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の重ねブレンド
    class func overlayBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageOverlayBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の各色最小値をとってブレンド
    class func darkenBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageDarkenBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の各色最大値をとってブレンド
    class func lightenBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageLightenBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の焼き込みブレンド
    class func colorBurnBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageColorBurnBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の覆い焼きブレンド
    class func colorDodgeBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageColorDodgeBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像のスクリーンブレンド
    class func screenBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageScreenBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    
    // 二つの画像の排他ブレンド
    class func exclusionBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageExclusionBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像の差分ブレンド
    class func differenceBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageDifferenceBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像のハード光?ブレンド
    class func hardLightBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageHardLightBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像のソフト光?ブレンド
    class func softLightBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageSoftLightBlendFilter();
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }

    // 二つの画像のアルファブレンド
    class func alphaBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        ) -> UIImage
    {
        var filter = GPUImageAlphaBlendFilter();
        filter.mix = 1.0;

        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    class func alphaBlendFilter(baseImage: UIImage
        , overlayImage: UIImage
        , mix: CGFloat
        ) -> UIImage
    {
        // mix : 0.0 ~ 1.0 Default 1.0
        var filter = GPUImageAlphaBlendFilter();
        filter.mix = mix;
        
        var inputPicture = GPUImagePicture(CGImage: baseImage.CGImage, smoothlyScaleOutput: true);
        var overlayPicture = GPUImagePicture(CGImage: overlayImage.CGImage, smoothlyScaleOutput: true);
        inputPicture.addTarget(filter);
        overlayPicture.addTarget(filter);
        inputPicture.processImage();
        overlayPicture.processImage();
        filter.useNextFrameForImageCapture();
        return filter.imageFromCurrentFramebufferWithOrientation(baseImage.imageOrientation);
    }
    
    
    //
    // Visual effects
    //
    
    // ピクセレート(ドット絵とかモザイクみたいな)フィルタ
    class func pixellateFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImagePixellateFilter().imageByFilteringImage(baseImage);
    }
    class func pixellateFilter(baseImage: UIImage
        , fractionalWidthOfAPixel: CGFloat
        ) -> UIImage
    {
        // fractionalWidthOfAPixel : 0.0 ~ 1.0 Default 0.05 ドットの荒さ 0.05は結構荒い
        var filter = GPUImagePixellateFilter();
        filter.fractionalWidthOfAPixel = fractionalWidthOfAPixel;
        return filter.imageByFilteringImage(baseImage);
    }

    // 集中線みたいな形でのピクセレートフィルタ
    class func polarPixellateFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImagePolarPixellateFilter().imageByFilteringImage(baseImage);
    }
    class func polarPixellateFilter(baseImage: UIImage
        , center: CGPoint
        , pixelSize: CGSize
        ) -> UIImage
    {
        // center : 0.0 ~ 1.0 集中線の中心点
        // pixelSize : 0.0 ~ 1.0 くらい　ドットの荒さ
        var filter = GPUImagePolarPixellateFilter();
        filter.center = center;
        filter.pixelSize = pixelSize;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // ピクセレートの各ドット領域を丸ドットにするフィルタ
    class func polkaDotFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImagePolkaDotFilter().imageByFilteringImage(baseImage);
    }
    class func polkaDotFilter(baseImage: UIImage
        , fractionalWidthOfAPixel: CGFloat
        , dotScaling: CGFloat
        ) -> UIImage
    {
        // fractionalWidthOfAPixel : 0.0 ~ 1.0 Default 0.05 ドットの荒さ 0.05は結構荒い
        // dotScaling : 0.0 ~ 1.0 Default 0.9 ドットのどれくらいを使用して丸にするか
        var filter = GPUImagePolkaDotFilter();
        filter.fractionalWidthOfAPixel = fractionalWidthOfAPixel;
        filter.dotScaling = dotScaling;
        return filter.imageByFilteringImage(baseImage);
    }

    // ハーフトーンフィルタ(なんか、黒い点々になる)
    class func halftoneFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageHalftoneFilter().imageByFilteringImage(baseImage);
    }
    class func halftoneFilter(baseImage: UIImage
        , fractionalWidthOfAPixel: CGFloat
        ) -> UIImage
    {
        // fractionalWidthOfAPixel : 0.0 ~ 1.0 Default 0.05 ドットの荒さ 0.05は結構荒い
        var filter = GPUImageHalftoneFilter();
        filter.fractionalWidthOfAPixel = fractionalWidthOfAPixel;
        return filter.imageByFilteringImage(baseImage);
    }

    // クロスハッチフィルタ
    class func crosshatchFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageCrosshatchFilter().imageByFilteringImage(baseImage);
    }
    class func crosshatchFilter(baseImage: UIImage
        , crossHatchSpacing: CGFloat
        , lineWidth: CGFloat
        ) -> UIImage
    {
        // crossHatchSpacing : Default 0.03 格子の密度
        // lineWidth : Default 0.003 格子の幅
        var filter = GPUImageCrosshatchFilter();
        filter.crossHatchSpacing = crossHatchSpacing;
        filter.lineWidth = lineWidth;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // スケッチフィルタ
    class func sketchFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageSketchFilter().imageByFilteringImage(baseImage);
    }
    class func sketchFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.0005
        // texelHeight : 0.0005
        var filter = GPUImageSketchFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        return filter.imageByFilteringImage(baseImage);
    }

    // 漫画フィルタ
    class func toonFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageToonFilter().imageByFilteringImage(baseImage);
    }
    class func toonFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        , threshold: CGFloat
        , quantizationLevels: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.0005
        // texelHeight : 0.0005
        // threshold : 0.0 ~ 1.0 Default 0.2 ソーベルフィルタの感度
        // quantizationLevels : Default 10.0 最終的なカラーレベル
        var filter = GPUImageToonFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        filter.threshold = threshold;
        filter.quantizationLevels = quantizationLevels;
        return filter.imageByFilteringImage(baseImage);
    }
    
    
    // ノイズ低減漫画フィルタ
    class func smoothToonFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageSmoothToonFilter().imageByFilteringImage(baseImage);
    }
    class func smoothToonFilter(baseImage: UIImage
        , texelWidth: CGFloat
        , texelHeight: CGFloat
        , blurSize: CGFloat
        , threshold: CGFloat
        , quantizationLevels: CGFloat
        ) -> UIImage
    {
        // texelWidth : 0.0005
        // texelHeight : 0.0005
        // blurSize : 0.0 ~ Default 0.5 ノイズ低減のぼかし度合い
        // threshold : 0.0 ~ 1.0 Default 0.2 ソーベルフィルタの感度
        // quantizationLevels : Default 10.0 最終的なカラーレベル
        var filter = GPUImageSmoothToonFilter();
        filter.texelWidth = texelWidth;
        filter.texelHeight = texelHeight;
        filter.threshold = threshold;
        filter.quantizationLevels = quantizationLevels;
        return filter.imageByFilteringImage(baseImage);
    }

    // エンボスフィルタ
    class func embossFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageEmbossFilter().imageByFilteringImage(baseImage);
    }
    class func embossFilter(baseImage: UIImage
        , intensity: CGFloat
        ) -> UIImage
    {
        // intensity : 0.0 ~ 4.0 Default 1.0
        var filter = GPUImageEmbossFilter();
        filter.intensity = intensity;
        return filter.imageByFilteringImage(baseImage);
    }

    // ポスタライズ
    class func posterizeFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImagePosterizeFilter().imageByFilteringImage(baseImage);
    }
    class func posterizeFilter(baseImage: UIImage
        , colorLevels: UInt
        ) -> UIImage
    {
        // colorLevels : 1 ~ 256 Default 10
        var filter = GPUImagePosterizeFilter();
        filter.colorLevels = colorLevels;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 渦巻き歪みフィルタ
    class func swirlFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageSwirlFilter().imageByFilteringImage(baseImage);
    }
    class func swirlFilter(baseImage: UIImage
        , radius: CGFloat
        , center: CGPoint
        , angle: CGFloat
        ) -> UIImage
    {
        // radius : Default 0.5
        // center : (0.0, 0,0) ~ (1.0, 1.0)
        // angle : Default 1.0
        var filter = GPUImageSwirlFilter();
        filter.radius = radius;
        filter.center = center;
        filter.angle = angle;
        return filter.imageByFilteringImage(baseImage);
    }

    // 膨らみ歪みフィルタ
    class func bulgeDistortionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageBulgeDistortionFilter().imageByFilteringImage(baseImage);
    }
    class func bulgeDistortionFilter(baseImage: UIImage
        , radius: CGFloat
        , center: CGPoint
        , scale: CGFloat
        ) -> UIImage
    {
        // radius : Default 0.25
        // center : (0.0, 0,0) ~ (1.0, 1.0)
        // scale : -1.0 ~ 1.0 Default 0.5
        var filter = GPUImageBulgeDistortionFilter();
        filter.radius = radius;
        filter.center = center;
        filter.scale = scale;
        return filter.imageByFilteringImage(baseImage);
    }

    // 挟み込み歪みフィルタ
    class func pinchDistortionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImagePinchDistortionFilter().imageByFilteringImage(baseImage);
    }
    class func pinchDistortionFilter(baseImage: UIImage
        , radius: CGFloat
        , center: CGPoint
        , scale: CGFloat
        ) -> UIImage
    {
        // radius : Default 1.0
        // center : (0.0, 0,0) ~ (1.0, 1.0)
        // scale : -2.0 ~ 2.0 Default 1.0
        var filter = GPUImagePinchDistortionFilter();
        filter.radius = radius;
        filter.center = center;
        filter.scale = scale;
        return filter.imageByFilteringImage(baseImage);
    }

    // 伸縮歪みフィルタ
    class func stretchDistortionFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageStretchDistortionFilter().imageByFilteringImage(baseImage);
    }
    class func stretchDistortionFilter(baseImage: UIImage
        , center: CGPoint
        ) -> UIImage
    {
        // center : (0.0, 0,0) ~ (1.0, 1.0)
        var filter = GPUImageStretchDistortionFilter();
        filter.center = center;
        return filter.imageByFilteringImage(baseImage);
    }
    
    // 指定した色で外側から侵食するふんわりフレーム的なフィルタ
    class func vignetteFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageVignetteFilter().imageByFilteringImage(baseImage);
    }
    class func vignetteFilter(baseImage: UIImage
        , vignetteCenter: CGPoint
        , vignetteColor: GPUVector3
        , vignetteStart: CGFloat
        , vignetteEnd: CGFloat
        ) -> UIImage
    {
        // vignetteCenter : (0.0, 0.0) ~ (1.0, 1.0) どこに向かって侵食するか
        // vignetteColor : GPUVector3(one: 1.0, two: 1.0, three: 1.0)で白
        // vignetteStart : 0.1 くらいがちょうどよかった
        // vignetteEnd : 0.4 くらいがちょうどよかった
        var filter = GPUImageVignetteFilter();
        filter.vignetteCenter = vignetteCenter;
        filter.vignetteColor = vignetteColor;
        filter.vignetteStart = vignetteStart;
        filter.vignetteEnd = vignetteEnd;
        return filter.imageByFilteringImage(baseImage);
    }

    // 質のいいポスタライズみたいな
    class func kuwaharaFilter(baseImage: UIImage) -> UIImage
    {
        return GPUImageKuwaharaFilter().imageByFilteringImage(baseImage);
    }
    class func kuwaharaFilter(baseImage: UIImage
        , radius: UInt
        ) -> UIImage
    {
        // radius : Default 4
        var filter = GPUImageKuwaharaFilter();
        filter.radius = radius;
        return filter.imageByFilteringImage(baseImage);
    }
    
    class func filter_exec(image: UIImage, section: Int, row: Int, overlay: UIImage? = nil) -> UIImage
    {
        switch (section) {
        case 0: // color
            return ImageProcessing.filter_exec_colorfilter(image, row: row);
        case 1: // processiong
            return ImageProcessing.filter_exec_proccessfilter(image, row: row);
        case 2: // blend
            if(overlay != nil)
            {
                return ImageProcessing.filter_exec_blendfilter(image, row: row, overlay: overlay!);
            }
        case 3: // visual effect
            return ImageProcessing.filter_exec_visualeffectfilter(image, row: row);
        default:
            break;
        }
        return image;
    }
    class func filter_exec_colorfilter(image: UIImage, row: Int) -> UIImage
    {
        switch (row) {
        case 0:
            return brightnessFilter(image);
        case 1:
            return exposureFilter(image);
        case 2:
            return contrastFilter(image);
        case 3:
            return gammaFilter(image);
        case 4:
            return colorMatrixFilter(image);
        case 5:
            return rgbFilter(image);
        case 6:
            return hueFilter(image);
        case 7:
            return toneCurveFilter(image);
        case 8:
            return highlightShadowFilter(image);
        case 9:
            return colorInvertFilter(image);
        case 10:
            return grayscaleFilter(image);
        case 11:
            return falseColorFilter(image);
        case 12:
            return sepiaFilter(image);
        case 13:
            return opacityFilter(image);
        case 14:
            return luminanceThresholdFilter(image);
        case 15:
            return averageLuminanceThresholdFilter(image);
        default:
            break;
        }
        return image;
    }
    class func filter_exec_proccessfilter(image: UIImage, row: Int) -> UIImage
    {
        switch (row) {
        case 0:
            return transform2DFilter(image);
        case 1:
            return transform3DFilter(image);
        case 2:
            return cropFilter(image);
        case 3:
            return lanczosResamplingFilter(image);
        case 4:
            return sharpenFilter(image);
        case 5:
            return unsharpMaskFilter(image);
        case 6:
            return gaussianBlurFilter(image);
        case 7:
            return gaussianSelectiveBlurFilter(image);
        case 8:
            return tiltShiftFilter(image);
        case 9:
            return boxBlurFilter(image);
        case 10:
            return convolution3x3Filter(image);
        case 11:
            return sobelEdgeDetectionFilter(image);
        case 12:
            return cannyEdgeDetectionFilter(image);
        case 13:
            return dilationFilter(image);
        case 14:
            return rgbDilationFilter(image);
        case 15:
            return erosionFilter(image);
        case 16:
            return rgbErosionFilter(image);
        case 17:
            return openingFilter(image);
        case 18:
            return rgbOpeningFilter(image);
        case 19:
            return closingFilter(image);
        case 20:
            return rgbClosingFilter(image);
        case 21:
            return lowPassFilter(image);
        case 22:
            return highPassFilter(image);
        case 23:
            return motionDetector(image);
        default:
            break;
        }
        return image;
    }
    class func filter_exec_blendfilter(image: UIImage, row: Int, overlay: UIImage) -> UIImage
    {
        switch (row) {
        case 0:
            return chromaKeyFilter(image, overlayImage: overlay);
        case 1:
            return chromaKeyBlendFilter(image, overlayImage: overlay);
        case 2:
            return dissolveBlendFilter(image, overlayImage: overlay);
        case 3:
            return multiplyBlendFilter(image, overlayImage: overlay);
        case 4:
            return addBlendFilter(image, overlayImage: overlay);
        case 5:
            return divideBlendFilter(image, overlayImage: overlay);
        case 6:
            return overlayBlendFilter(image, overlayImage: overlay);
        case 7:
            return darkenBlendFilter(image, overlayImage: overlay);
        case 8:
            return lightenBlendFilter(image, overlayImage: overlay);
        case 9:
            return colorBurnBlendFilter(image, overlayImage: overlay);
        case 10:
            return colorDodgeBlendFilter(image, overlayImage: overlay);
        case 11:
            return screenBlendFilter(image, overlayImage: overlay);
        case 12:
            return exclusionBlendFilter(image, overlayImage: overlay);
        case 13:
            return differenceBlendFilter(image, overlayImage: overlay);
        case 14:
            return hardLightBlendFilter(image, overlayImage: overlay);
        case 15:
            return softLightBlendFilter(image, overlayImage: overlay);
        case 16:
            return alphaBlendFilter(image, overlayImage: overlay);
        default:
            break;
        }
        return image;
    }
    class func filter_exec_visualeffectfilter(image: UIImage, row: Int) -> UIImage
    {
        switch (row) {
        case 0:
            return pixellateFilter(image);
        case 1:
            return polarPixellateFilter(image);
        case 2:
            return polkaDotFilter(image);
        case 3:
            return halftoneFilter(image);
        case 4:
            return crosshatchFilter(image);
        case 5:
            return sketchFilter(image);
        case 6:
            return toonFilter(image);
        case 7:
            return smoothToonFilter(image);
        case 8:
            return embossFilter(image);
        case 9:
            return posterizeFilter(image);
        case 10:
            return swirlFilter(image);
        case 11:
            return bulgeDistortionFilter(image);
        case 12:
            return pinchDistortionFilter(image);
        case 13:
            return stretchDistortionFilter(image);
        case 14:
            return vignetteFilter(image);
        case 15:
            return kuwaharaFilter(image);
        default:
            break;
        }
        return image;
    }
}

