//
//  JFAssetsInfo.m
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "JFAssetsInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation JFAssetsInfo

- (instancetype)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.thumbNailImage = [UIImage imageWithCGImage:[asset thumbnail]];
        self.asset = asset;
    }
    return self;
}

@end
