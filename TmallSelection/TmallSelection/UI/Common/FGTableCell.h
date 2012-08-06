//
//  FGTableCell.h
//  FreeGames
//
//  Created by 济泽 韩 on 12-5-16.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartView.h"
#import "FGImageView.h"

@protocol cellDelegate;
@interface FGTableCell : UITableViewCell
{
    NSString        *_gameID;
    FGImageView     *_gameIcon;
    UILabel         *_gameName;
    UILabel         *_gameIntroduction;
    UILabel         *_gameCategory;
    HeartView       *_heartView;
    UILabel         *_gameSize;
    UILabel         *_languageString;
    UILabel         *_gamePrice;
    NSString        *_downUrl;
    NSString        *_gameVersion;
    NSString        *_oldPrice;
    NSString        *_currentPrice;
    UIButton        *_downloadBtn;//免费按钮
    UIButton        *_downLoadBtnFree;//限免按钮
    UIImageView     *_freeLine;
    UIImageView     *_introTagImg;
    UIImageView     *_categoryTagImg;
    id<cellDelegate>_clDelegate;
}
@property (nonatomic ,copy)NSString          *gameID;
@property (nonatomic ,retain)FGImageView     *gameIcon;
@property (nonatomic, assign)id              clDelegate;
@property (nonatomic, retain)UILabel         *gameName;
@property (nonatomic, retain)UILabel      *gameIntroduction;
@property (nonatomic, retain)UILabel         *gameCategory;
@property (nonatomic, retain)HeartView       *heartView;
@property (nonatomic, retain)UILabel         *gameSize;
@property (nonatomic, retain)UILabel         *languageString;
@property (nonatomic, retain)UILabel         *gamePrice;
@property (nonatomic, copy)NSString   *downUrl;
@property (nonatomic, copy)NSString          *gameVersion;
@property (nonatomic, copy)NSString          *oldPrice;
@property (nonatomic, copy)NSString          *currentPrice;
- (void)setCellWithDic:(NSDictionary *)cellDic;
@end

@protocol cellDelegate <NSObject>

- (void)didDownloadGameWithCell:(FGTableCell *)tbCell;

@end