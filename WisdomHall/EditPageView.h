//
//  EditPageView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditPageViewDelegate<NSObject>
-(void)saveTextStrDelegate:(UIButton *)btn;
@end
@interface EditPageView : UIView

@property (nonatomic,weak)id<EditPageViewDelegate>delegate;

@property (nonatomic,copy)NSString * editStr;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong) UIButton * cancle;
@property (nonatomic,strong) UIButton * save;
@end
