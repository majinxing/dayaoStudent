//
//  QrCodeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/31.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QrCodeViewController.h"
#import "DYHeader.h"
#import <CommonCrypto/CommonDigest.h>

@interface QrCodeViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong,nonatomic) NSTimer * showTimer;
@end

@implementation QrCodeViewController
-(void)dealloc{
    [_showTimer invalidate];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_showTimer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //时间间隔
    NSTimeInterval timeInterval = CodeEffectiveTime ;
    //定时器
    _showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(handleMaxShowTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [_showTimer fire];
//    _codeImageView.image = [self qrImageForString:_dict imageSize:220 logoImageSize:220];
    _textLabel.text = [NSString stringWithFormat:@"注意：二维码将每3秒钟重新生成，请即时提供给同学签到"];
    // Do any additional setup after loading the view from its nib.
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
    
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_mck withMac:bssid]) {
            NSString * interval = [UIUtils getCurrentTime];
            [_dict setObject:interval forKey:@"date"];
            NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",interval];
            NSString * md5 = [self md5:checkcodeLocal];
            [_dict setObject:md5 forKey:@"checkcode"];
            _codeImageView.image = nil;
            _codeImageView.image = [self qrImageForString:_dict imageSize:220 logoImageSize:220];
//            if (!_dict) {
//                [UIUtils showInfoMessage:@""];
//            }
        }else{
            [_showTimer invalidate];
            [self outView];
        }
    }else{
        [_showTimer invalidate];
        [self outView];
    }
}
-(void)outView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：请在连接指定的DAYAO或XTU开头的WiFi下生成二维码" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
-(UIImage *)qrImageForString:(NSDictionary *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [NSJSONSerialization dataWithJSONObject:string options:NSJSONWritingPrettyPrinted error:nil];
    
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"icon_imgApp"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
