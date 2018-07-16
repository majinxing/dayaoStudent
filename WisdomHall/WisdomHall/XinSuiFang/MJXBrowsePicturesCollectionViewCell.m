//
//  MJXBrowsePicturesCollectionViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/5.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXBrowsePicturesCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface MJXBrowsePicturesCollectionViewCell ()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *imageView1;
@property (nonatomic,strong)UIButton *delect;
@property (nonatomic,strong)UIImageView * imageSC;
@end
@implementation MJXBrowsePicturesCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       // [self.contentView addSubview:self.imageView];
        _delect = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageSC = [[UIImageView alloc] init];
    }
    return self;
    
}
-(void)addImageViewWithString:(NSString *)imageUrl withD:(BOOL)N withTag:(int)btnTag{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,73 , 73)];
    NSMutableString * str = [[NSMutableString alloc] initWithString:imageUrl];
    
    [str replaceCharactersInRange:NSMakeRange([str length]-5, 1) withString:@"S"];

    [_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"xc"]];
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    
    _delect.tag = btnTag;
    if(N){
        _delect.frame = CGRectMake(50, 0, 23, 23);
    }else{
        _delect.frame = CGRectMake(0, 0, 0, 0);
    }
    [_delect addTarget:self action:@selector(delecateImage:) forControlEvents:UIControlEventTouchUpInside];
    [_delect setBackgroundImage:[UIImage imageNamed:@"dtsc"] forState:UIControlStateNormal];
    [self.contentView addSubview:_delect];

}
-(void)addImageViewWithImage:(UIImage *)image withD:(BOOL)N withTag:(int)btnTag{//没有做url的
    
    
    //image = [self scaleImage:image toScale:0.5];
//    NSData *_data = UIImageJPEGRepresentation(image, 0.5f);
//    UIImage * image1 = [UIImage imageWithData:_data];//没有则走下一个
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,73 , 73)];
    _imageView.image = image;
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    
  
    _delect.tag = btnTag;
    if(N){
      _delect.frame = CGRectMake(50, 0, 23, 23);
    }else{
      _delect.frame = CGRectMake(0, 0, 0, 0);
    }
    [_delect addTarget:self action:@selector(delecateImage:) forControlEvents:UIControlEventTouchUpInside];
    [_delect setBackgroundImage:[UIImage imageNamed:@"dtsc"] forState:UIControlStateNormal];
    [self.contentView addSubview:_delect];
    
    _imageSC = [[UIImageView alloc] initWithFrame:CGRectMake(50, 55, 20, 15)];
    _imageSC.image = [UIImage imageNamed:@"shangchuan"];
    [self.contentView addSubview:_imageSC];
}
-(void)delecateImage:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(MJXBrowsePicturesCollectionViewCellDelegatedelecateImagePressed:)]) {
        [self.delegate MJXBrowsePicturesCollectionViewCellDelegatedelecateImagePressed:btn];
    }
}
@end
