//
//  ScanOutCellTableViewCell.m
//  ESCloudsManager
//
//  Created by 孙滢贺 on 16/7/19.
//  Copyright © 2016年 ESClouds. All rights reserved.
//

#import "ScanOutCellTableViewCell.h"
#import "ScanOutModel.h"

@implementation ScanOutCellTableViewCell{
    UILabel *barcodeLabel;
    UILabel *goodnameLabel;
    UILabel *numberLabel;
    UILabel *line;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)getInformation:(ScanOutModel *)info{
    if (!barcodeLabel) {
        barcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,  kScreenWidth / 3 + 20, 40)];
        barcodeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:barcodeLabel];
    }
    barcodeLabel.text = info.barcode;
    
    if (!goodnameLabel) {
        goodnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 3 + 40, 0, kScreenWidth / 2, 40)];
        goodnameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:goodnameLabel];
    }
    goodnameLabel.text = info.name;
    
    if (!numberLabel) {
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 5 / 6 + 20 , 0, kScreenWidth / 6 , 40)];
        numberLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:numberLabel];
    }
    numberLabel.text = info.number;
    
    if (!line) {
        line = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kScreenWidth - 20, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
