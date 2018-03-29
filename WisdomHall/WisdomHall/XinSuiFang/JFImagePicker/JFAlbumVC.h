//
//  JFAlbumVC.h
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFAlbumVCDelegate <NSObject>
- (void)imagePickerControllerDidFinishWithArray:(NSArray *)array;


@end
@interface JFAlbumVC : UIViewController

@property (nonatomic, assign) int maxAmount;
@property (nonatomic, weak) id delegate;
@end
