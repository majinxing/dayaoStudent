//
//  MJXTabbarItem.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTabbarItem.h"


@implementation MJXTabbarItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
        self.tag = tag;
    }
    
    return self;
}

@end
