//
//  Appsetting.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "Appsetting.h"
#import "UserModel.h"
#import "FMDBTool.h"
#import "DYHeader.h"

@interface Appsetting()
@property (nonatomic,strong)FMDatabase * db;

@end

@implementation Appsetting
+(Appsetting *)sharedInstance{
    static Appsetting * shareInstance = nil;
    if (shareInstance == nil) {
        shareInstance = [[Appsetting alloc] init];
    }
    return shareInstance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _mySettingData = [NSUserDefaults standardUserDefaults];//本地化，归档的一种
    }
    return self;
}
-(void)sevaUserInfoWithDict:(NSDictionary *)dict withStr:(NSString *)p{
    [_mySettingData setValue:[dict objectForKey:@"pictureId"] forKey:@"user_pictureId"];
    [_mySettingData setValue:[dict objectForKey:@"id"] forKey:@"user_id"];
    [_mySettingData setValue:[dict objectForKey:@"name"] forKey:@"user_name"];
    [_mySettingData setValue:[dict objectForKey:@"phone"] forKey:@"user_phone"];
    [_mySettingData setValue:[dict objectForKey:@"type"] forKey:@"user_type"];
    [_mySettingData setValue:[dict objectForKey:@"universityId"] forKey:@"user_universityCode"];
    [_mySettingData setValue:[dict objectForKey:@"workNo"] forKey:@"user_workNo"];
    [_mySettingData setValue:[dict objectForKey:@"majorId"] forKey:@"user_majorCode"];
    [_mySettingData setValue:[dict objectForKey:@"facultyId"] forKey:@"user_facultyCode"];
    [_mySettingData setValue:[dict objectForKey:@"classId"] forKey:@"user_classCode"];
    
    [_mySettingData setValue:[dict objectForKey:@"majorName"] forKey:@"user_majorName"];
    [_mySettingData setValue:[dict objectForKey:@"facultyName"] forKey:@"user_facultyName"];
    [_mySettingData setValue:[dict objectForKey:@"className"] forKey:@"user_className"];
    [_mySettingData setValue:[dict objectForKey:@"universityName"] forKey:@"user_universityName"];
    [_mySettingData setValue:[NSString stringWithFormat:@"%@",p] forKey:@"user_password"];
    [_mySettingData setValue:@"1" forKey:@"is_Login"];
    [_mySettingData setValue:[dict objectForKey:@"token"] forKey:@"user_token"];
    NSString * time = [UIUtils getTime];
    [self insertedIntoNoticeTable:time];
    [_mySettingData synchronize];
}
-(void)saveUserOtherInfo:(NSDictionary *)dict{
    [_mySettingData setValue:[dict objectForKey:@"birthday"] forKey:@"user_birthday"];
    [_mySettingData setValue:[dict objectForKey:@"email"] forKey:@"user_email"];
    [_mySettingData setValue:[dict objectForKey:@"region"] forKey:@"user_region"];
    [_mySettingData setValue:[dict objectForKey:@"sex"] forKey:@"user_sex"];
    [_mySettingData setValue:[dict objectForKey:@"sign"] forKey:@"user_sign"];
    [_mySettingData setValue:[dict objectForKey:@"pictureId"] forKey:@"user_pictureId"];
    [_mySettingData synchronize];
}
-(UserModel *)getUsetInfo{
    UserModel * userInfo = [[UserModel alloc] init];
    userInfo.userPhone = [_mySettingData objectForKey:@"user_phone"];
    userInfo.userName = [_mySettingData objectForKey:@"user_name"];
    userInfo.school = [_mySettingData objectForKey:@"user_universityCode"];
    userInfo.identity = [_mySettingData objectForKey:@"user_type"];
    userInfo.departments = [_mySettingData objectForKey:@"user_facultyCode"];
    userInfo.professional = [_mySettingData objectForKey:@"user_majorCode"];
    userInfo.classNumber = [_mySettingData objectForKey:@"user_classCode"];
    userInfo.studentId = [_mySettingData objectForKey:@"user_workNo"];
    userInfo.peopleId = [_mySettingData objectForKey:@"user_id"];
    userInfo.userPassword = [_mySettingData objectForKey:@"user_password"];
    userInfo.departmentsName = [_mySettingData objectForKey:@"user_facultyName"];
    userInfo.professionalName = [_mySettingData objectForKey:@"user_majorName"];
    userInfo.className = [_mySettingData objectForKey:@"user_className"];
    userInfo.schoolName = [_mySettingData objectForKey:@"user_universityName"];
    userInfo.userPassword = [_mySettingData objectForKey:@"user_password"];
    userInfo.birthday = [_mySettingData objectForKey:@"user_birthday"];
    userInfo.email = [_mySettingData objectForKey:@"user_email"];
    userInfo.sex = [_mySettingData objectForKey:@"user_sex"];
    userInfo.region = [_mySettingData objectForKey:@"user_region"];
    userInfo.sign = [_mySettingData objectForKey:@"user_sign"];
    userInfo.token = [_mySettingData objectForKey:@"user_token"];
    userInfo.userHeadImageId = [_mySettingData objectForKey:@"user_pictureId"];
    userInfo.host = [_mySettingData objectForKey:@"user_universityHost"];
    return userInfo;
}
-(void)setThemeColor:(UIColor *)color{
    NSString *colorStr = [self toStrByUIColor:color];
    [_mySettingData setValue:colorStr forKey:@"theme_color"];
    [_mySettingData synchronize];
}
-(UIColor *)getThemeColor{
    if (![UIUtils isBlankString:[_mySettingData objectForKey:@"theme_color"]]) {
        UIColor *color = [self toUIColorByStr:[_mySettingData objectForKey:@"theme_color"]];
        return color;
    }
    return RGBA_COLOR(217, 0, 21, 1);
}
// 颜色 转字符串（16进制）
-(NSString*)toStrByUIColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"%06x", rgb];
}
// 颜色 字符串转16进制
-(UIColor*)toUIColorByStr:(NSString*)colorStr{
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(BOOL)isLogin{
    NSString * isLogin = [_mySettingData objectForKey:@"is_Login"];
    if ([isLogin isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(NSString *)getUserPhone{
    NSString * phone = [_mySettingData objectForKey:@"user_phone"];
    return phone;
}
-(void)saveUserSchool:(SchoolModel *)school{
    [_mySettingData setValue:school.schoolId forKey:@"user_universityCode"];
    [_mySettingData setValue:school.schoolName forKey:@"user_universityName"];
    [_mySettingData setValue:school.schoolHost forKey:@"user_universityHost"];
    [_mySettingData synchronize];
}
-(SchoolModel *)getUserSchool{
    NSString * schoolName = [_mySettingData objectForKey:@"user_universityName"];
    NSString * schoolId = [_mySettingData objectForKey:@"user_universityCode"];
    NSString * host = [_mySettingData objectForKey:@"user_universityHost"];
    SchoolModel * s = [[SchoolModel alloc] init];
    s.schoolName = schoolName;
    s.schoolId = schoolId;
    s.schoolHost = host;
    return s;
}
-(void)getOut{
    [_mySettingData setValue:@"0" forKey:@"is_Login"];
    [_mySettingData synchronize];
    
}
-(void)insertedIntoNoticeTable:(NSString *)noticeTime{
    
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    if ([_db open]) {
        
        [FMDBTool deleteTable:TOKENTIME_TABLE_NAME withDB:_db];
        
    }
    [_db close];
    
    [self creatTextTable:TOKENTIME_TABLE_NAME];
    
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (tokenTime) values ('%@')",TOKENTIME_TABLE_NAME,noticeTime];
        
        BOOL rs = [FMDBTool insertWithDB:_db tableName:TOKENTIME_TABLE_NAME withSqlStr:sql];
        
        if (!rs) {
            NSLog(@"失败");
        }
        
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"tokenTime" : @"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}
-(UIImage*)grayscale:(UIImage*)anImage{
    if (!anImage) {
        return nil;
    }
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    UIColor * color = [self getThemeColor];
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
//    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            //            UInt8 brightness;
            
            if (red!=0||green!=0||blue!=0) {
                *(tmp + 0) = r*255;
                *(tmp + 1) = g*255;
                *(tmp + 2) = b*255;
            }
            //            switch (type) {
            //                case 1://モノクロ
            //                    // 輝度計算
            //                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
            //
            //                    *(tmp + 0) = brightness;
            //                    *(tmp + 1) = brightness;
            //                    *(tmp + 2) = brightness;
            //                    break;
            //
            //                case 2://セピア
            //                    *(tmp + 0) = red;
            //                    *(tmp + 1) = green * 0.7;
            //                    *(tmp + 2) = blue * 0.4;
            //                    break;
            //
            //                case 3://色反転
            //                    *(tmp + 0) = 255 - red;
            //                    *(tmp + 1) = 255 - green;
            //                    *(tmp + 2) = 255 - blue;
            //                    break;
            //
            //                default:
            //                    *(tmp + 0) = red;
            //                    *(tmp + 1) = green;
            //                    *(tmp + 2) = blue;
            //                    break;
            //            }
            
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

-(void)saveWiFiMac:(NSString *)wifiMac{
    [_mySettingData setValue:wifiMac forKey:@"WIFI_mac"];
    [_mySettingData setValue:[UIUtils getCurrentDate ] forKey:@"WIFI_time"];
    [_mySettingData synchronize];
}
-(NSDictionary *)getWifiMacAndTime{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[_mySettingData objectForKey:@"WIFI_mac"] forKey:@"WIFI_mac"];
    [dict setValue:[_mySettingData objectForKey:@"WIFI_time"] forKey:@"WIFI_time"];
    return dict;
}
@end















