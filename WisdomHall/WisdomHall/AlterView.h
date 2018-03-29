//
//  AlterView.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AlterViewDelegate <NSObject>
-(void)alterViewDeleageRemove;

@end
@interface AlterView : UIView
@property(nonatomic,weak)id<AlterViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame withLabelText:(NSString *)textStr;
-(instancetype)initWithFrame:(CGRect)frame withAlterStr:(NSString *)str;

@end
