//
//  JFGroupCell.m
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "JFGroupCell.h"
#import "JFGroupInfo.h"

#define kCellHeight 80
#define kMargin 5

@interface JFGroupCell ()
{
    UIImageView *_image;
    UILabel *_title;
    UILabel *_count;
}
@end

@implementation JFGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addContentView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)addContentView
{
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, kCellHeight - 2 * kMargin, kCellHeight - 2 * kMargin)];
    [self addSubview:_image];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame) + kMargin * 2, kMargin, self.bounds.size.width - (CGRectGetMaxX(_image.frame) + kMargin * 2), 40)];
    [_title setTextColor:[UIColor darkGrayColor]];
    [self addSubview:_title];
    
    _count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame) + kMargin * 2, CGRectGetMaxY(_title.frame), self.bounds.size.width - (CGRectGetMaxX(_image.frame) + kMargin * 2), 20)];
    [_count setTextColor:[UIColor lightGrayColor]];
    [_count setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_count];
}

- (void)setContentView:(JFGroupInfo *)groupInfo
{
    [_image setImage:groupInfo.image];
    [_title setText:groupInfo.title];
    [_count setText:groupInfo.count];
}

+ (CGFloat)getCellHeight
{
    return kCellHeight;
}

@end
