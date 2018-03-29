//
//  ImageBrowserViewController.h
//  ImageBrowser
//
//  Created by msk on 16/9/1.
//  Copyright © 2016年 msk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 跳转方式
 */
typedef NS_ENUM(NSUInteger,PhotoBroswerVCType) {
    
    //modal
    PhotoBroswerVCTypePush=0,
    
    //push
    PhotoBroswerVCTypeModal,
    
    //zoom
    PhotoBroswerVCTypeZoom,
};

@protocol ImageBrowserViewControllerDelegate <NSObject>
-(void)imageBrowserVCDeleteImageButtonPressed:(UIButton *) btn;


@end
@interface ImageBrowserViewController : UIViewController
@property (nonatomic,weak)id<ImageBrowserViewControllerDelegate> delegate;
/**
 *  显示图片
 */
-(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type index:(NSUInteger)index deleteImage:(BOOL)N imagesBlock:(NSArray *(^)())imagesBlock;
@end
