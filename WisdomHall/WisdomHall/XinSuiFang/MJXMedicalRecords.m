//
//  MJXMedicalRecords.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/5.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXMedicalRecords.h"

@implementation MJXMedicalRecords

-(instancetype)init{
    self=[super init];
    _imageLArray = [NSMutableArray arrayWithCapacity:10];
    _imageSArray = [NSMutableArray arrayWithCapacity:10];
    _imageUrlLArray = [NSMutableArray arrayWithCapacity:10];
    _imageUrlSArray = [NSMutableArray arrayWithCapacity:10];
    _imageAllArray = [NSMutableArray arrayWithCapacity:10];
    return self;
}
-(void)setValueWithDict:(NSDictionary *)dict{
    if ([NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]].length>0&&![[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]] isEqualToString:@"<null>"]) {
       self.illnessDescription = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
    }else{
        self.illnessDescription = @"";
    }
    
    self.medicaDocType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"medicaDocType"]] ;
    self.medicaDocID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"medicaDocTypeId"]];
    id data = [dict objectForKey:@"imagesL"];
    if (![data isEqual:@""]) {
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@",[[dict objectForKey:@"imagesL"] substringFromIndex:0]];
        NSRange range = NSMakeRange(0, 1);
        NSString * str1 = [str substringWithRange:range];
        if ([str1 isEqualToString:@","]) {
            str = [str substringFromIndex:1];
        }
        NSArray * array = [[NSArray alloc] init];
        array = [str componentsSeparatedByString:@","];
        self.imageUrlLArray = [NSMutableArray arrayWithArray:array];//可能会存在问题，接口返回值不确定
    }
}
@end
