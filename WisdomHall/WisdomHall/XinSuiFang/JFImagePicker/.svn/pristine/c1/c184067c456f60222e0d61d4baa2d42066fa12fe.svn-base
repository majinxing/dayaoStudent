//
//  JFPhotoVC.h
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFGroupInfo;

@protocol JFPhotoViewControllerDelegate <NSObject>

- (void)photoViewControllerImagePickerSuccess:(NSArray *)array;

@end

@interface JFPhotoVC : UIViewController

@property (nonatomic, strong) id delegate;

@property (nonatomic, assign) int maxAmount;

/**
 *  通过groupInfo初始化
 *
 *  @param groupInfo
 *
 *  @return 
 */
- (instancetype)initWithGroupInfo:(JFGroupInfo *)groupInfo;

@end
