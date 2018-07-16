//
//  MJXModifyInformation.h
//  XinSuiFang
//
//  Created by majinxing on 16/10/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJXModifyInformationDelegate <NSObject>
-(void)personalInfoViewCompletePressed;
-(void)personalInfoViewSkipPressed;
-(void)personalInfoViewRegionalPressed:(UIButton *)btn;
@end
@interface MJXModifyInformation : UIView
@property (nonatomic,strong) UITextField *introduction;
@property (nonatomic,weak) id <MJXModifyInformationDelegate>delegate;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) UIButton *complete;
@end
