//
//  JFImagePickerController.m
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "JFImagePickerController.h"
#import "JFAlbumVC.h"
#import "JFPhotoVC.h"

static JFAlbumVC *_albumVC;

@interface JFImagePickerController () <JFPhotoViewControllerDelegate>

@end

@implementation JFImagePickerController

+ (instancetype)imagePicker
{
    _albumVC = [[JFAlbumVC alloc] init];
    
    return [[self alloc] initWithRootViewController:_albumVC];
}

- (instancetype)init
{
    _albumVC = [[JFAlbumVC alloc] init];
    
    return [super initWithRootViewController:_albumVC];
}

- (instancetype)initWithMaxAmount:(int)maxAmount
{
    _albumVC = [[JFAlbumVC alloc] init];
    _albumVC.maxAmount = maxAmount;
    
    return [super initWithRootViewController:_albumVC];
}

- (void)setMaxAmount:(int)maxAmount
{
    _maxAmount = maxAmount;
    _albumVC.maxAmount = maxAmount;
}

#pragma mark JFPhotoViewControllerDelegate

- (void)photoViewControllerImagePickerSuccess:(NSArray *)array
{
    if (self.jfDelegate && [self.jfDelegate respondsToSelector:
                          @selector(imagePickerControllerDidFinishWithArray:)])
    {
        [self.jfDelegate imagePickerControllerDidFinishWithArray:array];
    }
}

@end
