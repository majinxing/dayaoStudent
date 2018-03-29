//
//  MJXPersonalInfoView.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol personalInfoViewDelegate <NSObject>

-(void)personalInfoViewCompletePressed;
-(void)personalInfoViewSkipPressed;
-(void)personalInfoViewRegionalPressed:(UIButton *)btn;
@end
@interface MJXPersonalInfoView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *introduction;
@property (nonatomic,weak) id <personalInfoViewDelegate>delegate;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) UIButton *complete;
@end
