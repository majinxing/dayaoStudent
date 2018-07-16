//
//  imageBigView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/24.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imageBigViewDelegate<NSObject>
-(void)outViewDelegate;
@end
@interface imageBigView : UIView
@property (nonatomic,copy) NSString * number;
@property (nonatomic,weak)id<imageBigViewDelegate>delegate;
-(void)addImageView:(NSString *)str;
@end
