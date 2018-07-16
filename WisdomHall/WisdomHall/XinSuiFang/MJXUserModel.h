//
//  MJXUserModel.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXUserModel : NSObject
@property (nonatomic,copy) NSString * userPhone;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * hospital;
@property (nonatomic,copy) NSString * department;
@property (nonatomic,copy) NSString * position;
@property (nonatomic,copy) NSString * introduction;
@property (nonatomic,copy) NSString * userNewToken;
@property (nonatomic,copy) NSString * headimg;
@property (nonatomic,copy) NSString * qrcodeimg;//二维码

//
@end
