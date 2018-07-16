//
//  JFImagePickerController.h
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFImagePickerControllerDelegate <NSObject>

- (void)imagePickerControllerDidFinishWithArray:(NSArray *)array;

@end

@interface JFImagePickerController : UINavigationController

@property (nonatomic, assign) id<JFImagePickerControllerDelegate> jfDelegate;

@property (nonatomic, assign) int maxAmount;

+ (instancetype)imagePicker;

- (instancetype)initWithMaxAmount:(int)maxAmount;

@end
