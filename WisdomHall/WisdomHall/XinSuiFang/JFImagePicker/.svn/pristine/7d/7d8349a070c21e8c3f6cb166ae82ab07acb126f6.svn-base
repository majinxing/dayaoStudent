//
//  JFGroupInfo.m
//  JFAlbum
//
//  Created by Japho on 15/10/21.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "JFGroupInfo.h"

@implementation JFGroupInfo

- (instancetype)initWithGroup:(ALAssetsGroup *)group
{
    self = [super init];
    if (self)
    {
        self.group = group;
        self.image = [UIImage imageWithCGImage:group.posterImage];
        self.count = [NSString stringWithFormat:@"%ld张照片",(long)group.numberOfAssets];
        self.title = [group valueForProperty:ALAssetsGroupPropertyName];
    }
    return self;
}

+ (instancetype)groupInfoWithGroup:(ALAssetsGroup *)group
{
    return [[self alloc] initWithGroup:group];
}

@end
