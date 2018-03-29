//
//  MJXBrowsePicturesCollectionViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/5.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJXBrowsePicturesCollectionViewCellDelegate <NSObject>
-(void)MJXBrowsePicturesCollectionViewCellDelegatedelecateImagePressed:(UIButton *)btn;

@end
@interface MJXBrowsePicturesCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,weak)id<MJXBrowsePicturesCollectionViewCellDelegate>delegate;
-(void)addImageViewWithString:(NSString *)imageUrl withD:(BOOL)N withTag:(int)btnTag;
-(void)addImageViewWithImage:(UIImage *)image withD:(BOOL)N withTag:(int)btnTag;

@end
