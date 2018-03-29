//
//  DataDownloadTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DataDownloadTableViewCell.h"
#import "DYHeader.h"
@interface DataDownloadTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *fileName;
@property (strong, nonatomic) IBOutlet UIImageView *downloadImage;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UIImageView *isDownLoadImage;
@property (weak, nonatomic) IBOutlet UILabel *downFileName;
@property (strong, nonatomic) IBOutlet UIButton *secondDownload;


@end

@implementation DataDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addContentView:(FileModel *)f withIndex:(int)n{
    _fileName.text = f.fileName;
    if (f.isLocal) {
        _downloadImage.image = [UIImage imageNamed:@"ww"];
        [_downloadBtn setEnabled:NO];
    }
    _downloadBtn.tag = n;
    _createTime.text = f.fileCreatTime;
}
-(void)addDownLoadContentView:(FileModel *)f withIndex:(int)n withIsSelect:(NSString *)b{
    
    _downFileName.text = f.fileName;
    _secondDownload.tag = n;
    if ([b isEqualToString:@"Yes"]) {
        _isDownLoadImage.image = [UIImage imageNamed:@"方形选中-fill"];
    }else{
        _isDownLoadImage.image = [UIImage imageNamed:@"方形未选中"];
    }
}
- (IBAction)downloadFile:(UIButton *)btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFileDelegate:)]) {
        [self.delegate downloadFileDelegate:btn];
    }
}
- (IBAction)secondDownloadBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(secondDownloadBtnDelegate:)]) {
        [self.delegate secondDownloadBtnDelegate:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
