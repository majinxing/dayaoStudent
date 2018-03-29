//
//  PhotoPromptBox.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPromptBox : UIView
- (instancetype)initWithBlack:(void(^)(NSString *))backViewBlack WithTakePictureBlack:(void(^)(NSString *))tackPictureBlack;
@end
