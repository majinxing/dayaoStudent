//
//  JFAssetsInfo.h
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ALAsset;

@interface JFAssetsInfo : NSObject

@property (nonatomic, strong) UIImage *thumbNailImage;

@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, strong) UIImage *fullScreenImage;

/**
 *  初始化方法
 *
 *  @param asset
 *
 *  @return 
 */
- (instancetype)initWithAsset:(ALAsset *)asset;

@end
