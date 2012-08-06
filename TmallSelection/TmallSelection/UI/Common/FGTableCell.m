//
//  FGTableCell.m
//  FreeGames
//
//  Created by 济泽 韩 on 12-5-16.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import "FGTableCell.h"
#import "FGHeader.h"
#import "FGCellObject.h"//使用FGCellObject
#import "Color+Hex.h"
#define hXValue 88

@implementation FGTableCell

@synthesize gameID   = _gameID;
@synthesize gameIcon = _gameIcon;
@synthesize clDelegate = _clDelegate;
@synthesize gameName = _gameName;
@synthesize gameIntroduction = _gameIntroduction;
@synthesize gameCategory = _gameCategory;
@synthesize gameSize = _gameSize;
@synthesize gamePrice = _gamePrice;
@synthesize languageString = _languageString;
@synthesize heartView = _heartView;
@synthesize downUrl = _downUrl;
@synthesize gameVersion = _gameVersion;
@synthesize oldPrice = _oldPrice;
@synthesize currentPrice = _currentPrice;
- (void)dealloc
{
    [_gameID release];
    self.downUrl=nil;
     if (_downUrl) {
        [_downUrl release];
    }
    [_gameIcon release];
    [_gameName release];
    [_heartView release];
    [_gameSize release];
    [_freeLine release];
    
    [_gamePrice release];
    [_gameVersion release];
    [_introTagImg release];
    [_gameCategory release];
    [_languageString release];
    [_categoryTagImg release];
    [_gameIntroduction release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
        aView.backgroundColor = [UIColor colorWithHex:0xFFE6E6E6];
        self.selectedBackgroundView = aView;  // 设置选中后cell的背景颜色
        [aView release];
        
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake( 240.0 , 16.0 , 70 , 40 );
        _downloadBtn.frame = frame;
        _downloadBtn.backgroundColor = [UIColor clearColor];
        [_downloadBtn addTarget:self action:@selector(didSelectDisclosureButton) forControlEvents:UIControlEventTouchUpInside]; 
        [self addSubview:_downloadBtn];
        
        
        UIImage *image = [UIImage imageNamed:@"images_btn_dl_free.png"];
        [_downloadBtn setBackgroundImage:image forState:UIControlStateNormal];
        _downloadBtn.hidden = YES;
        
        _downLoadBtnFree = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadBtnFree.frame = frame;
        _downLoadBtnFree.backgroundColor = [UIColor clearColor];
        [_downLoadBtnFree addTarget:self action:@selector(didSelectDisclosureButton) forControlEvents:UIControlEventTouchUpInside]; 
        [self addSubview:_downLoadBtnFree];
        
        UIImage *imageFree = [UIImage imageNamed:@"images_btn_dl_time.png"];
        [_downLoadBtnFree setBackgroundImage:imageFree forState:UIControlStateNormal];
        _downLoadBtnFree.hidden = YES;
        
       _downUrl = [[NSString alloc]initWithString:@""];
        
        
        _gameID = [[NSString alloc]init];
        _gameIcon = [[FGImageView alloc]initWithFrame:GAME_ICON_FRAME];
        [_gameIcon setDefaultFile:@"default_pic.png"];
        _gameIcon.userInteractionEnabled = NO;
        [self insertSubview:_gameIcon atIndex:1];
        [_gameIcon setCornerRadiusForImage:12];
        
        _gameName = [[UILabel alloc]initWithFrame:CGRectMake(hXValue, 14, 162, 18)];
        _gameName.backgroundColor = [UIColor clearColor];
        _gameName.textColor = [UIColor colorWithHex:0xFF222222];
        [_gameName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        
        _gameName.textAlignment = UITextAlignmentLeft;
        [self addSubview:_gameName];
        
        _heartView = [[HeartView alloc]initWithImagesDeselected:REMMEND_IMG_ONE partlySelected:REMMEND_IMG_TWO fullSelected:REMMEND_IMG_THREE];
        [_heartView setImages];
        _heartView.backgroundColor = [UIColor clearColor];
        _heartView.frame =CGRectMake(hXValue, 40, _heartView.frame.size.width, _heartView.frame.size.height) ;
        [self  addSubview:_heartView];
        
        _gameSize = [[UILabel alloc]initWithFrame:CGRectMake(hXValue + _heartView.frame.size.width+14, _heartView.frame.origin.y -3, 40, 16)];
        _gameSize.backgroundColor = [UIColor clearColor];
        _gameSize.textColor = [UIColor colorWithHex:0xFF888888];
        [_gameSize setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        _gameSize.textAlignment = UITextAlignmentCenter;
        [self addSubview:_gameSize];
        
        _languageString = [[UILabel alloc]initWithFrame:CGRectMake(_gameSize.frame.origin.x +14+_gameSize.frame.size.width, _heartView.frame.origin.y -3, 40, 16)];
        _languageString.backgroundColor = [UIColor clearColor];
        _languageString.textColor = [UIColor colorWithHex:0xFF666666];;
        [_languageString setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        _languageString.textAlignment = UITextAlignmentLeft;
        [self addSubview:_languageString];
        
        
        _gamePrice = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x +30, frame.origin.y+1, 40, 20)];
        _gamePrice.backgroundColor = [UIColor clearColor];
        _gamePrice.textColor = [UIColor colorWithHex:0xFFFFFFFF];
        [_gamePrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        _gamePrice.textAlignment = UITextAlignmentCenter;
        _gamePrice.userInteractionEnabled = NO;
        [self addSubview:_gamePrice];
        
        _gameCategory = [[UILabel alloc]initWithFrame:CGRectMake(hXValue+14,_heartView.frame.origin.y +_heartView.frame.size.height +8,209, 14)];
        [_gameCategory setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        _gameCategory.backgroundColor = [UIColor clearColor];
        _gameCategory.textColor = [UIColor colorWithHex:0xFF666666];
        [self addSubview:_gameCategory];
        
        _categoryTagImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images_icon_tag.png"]];
        _categoryTagImg.frame = CGRectMake(hXValue, _heartView.frame.origin.y +_heartView.frame.size.height +10, 9, 9);
        _categoryTagImg.hidden = YES;
        [self addSubview:_categoryTagImg];
        
        
        _gameIntroduction = [[UILabel alloc]initWithFrame:CGRectMake(hXValue+14, _gameCategory.frame.origin.y +_gameCategory.frame.size.height, 209, 36)];
 //       _gameIntroduction.textAlignment = UITextAlignmentLeft;
//        _gameIntroduction.editable = NO;
        _gameIntroduction.userInteractionEnabled = NO;
        [_gameIntroduction setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        _gameIntroduction.backgroundColor = [UIColor clearColor];
        _gameIntroduction.textColor  = [UIColor colorWithHex:0xFF888888];
        _gameIntroduction.lineBreakMode =UILineBreakModeTailTruncation;
        _gameIntroduction.numberOfLines=0;
        [self addSubview:_gameIntroduction];
        
        _introTagImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images_icon_txt.png"]];
        _introTagImg.frame = CGRectMake(hXValue, _gameCategory.frame.origin.y +_gameCategory.frame.size.height +7, 9, 9);
        _introTagImg.hidden = YES;
        [self addSubview:_introTagImg];
        
        
        _gameVersion= [[NSString alloc]init];
        
        _freeLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images_line_del.png"]];
        _freeLine.frame = CGRectMake(5, 7, 33, 5);
        _freeLine.hidden = YES;
        [_gamePrice addSubview:_freeLine];
        
        UIImageView *sortLineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:IMAGE_LINE ]];
        sortLineImage.frame = CGRectMake(hXValue + _heartView.frame.size.width+6, _heartView.frame.origin.y, [UIImage imageNamed:IMAGE_LINE ].size.width, [UIImage imageNamed:IMAGE_LINE ].size.height);
        [self addSubview:sortLineImage];
        [sortLineImage release];
        
        UIImageView *sortLineImageDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:IMAGE_LINE ]];
        sortLineImageDown.frame = CGRectMake(_gameSize.frame.origin.x +2+_gameSize.frame.size.width, _heartView.frame.origin.y, [UIImage imageNamed:IMAGE_LINE ].size.width, [UIImage imageNamed:IMAGE_LINE ].size.height);
        [self addSubview:sortLineImageDown];
        [sortLineImageDown release];
    }
    return self;
}
- (void)didSelectDisclosureButton
{
    if (_clDelegate) {
        [_clDelegate didDownloadGameWithCell:self];
    }
    
}
#pragma mark - 从字典中获取cell的信息并加载
- (NSString *)judgeDataWithDic:(NSDictionary *)cellDict andString:(NSString *)keyString
{
    if ([cellDict objectForKey:keyString]==[NSNull null] || [cellDict objectForKey:keyString] == nil) {
        return  @"";
    }
    else
    {
        return  [cellDict objectForKey:keyString];
    }
}
- (void)setCellWithDic:(NSDictionary *)cellDic
{
  //  TRACE(@"#################%@",cellDic);
//    self.gameID = [[cellDic objectForKey:@"applicationId"] stringValue];
//    _gameSize.text = [cellDic objectForKey:@"fileSize"];
//    _gameName.text  =[cellDic objectForKey:@"title"];
//    
//    CGSize t_Rebate = [_gameSize.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11]];
//    _gameSize.frame = CGRectMake(_gameSize.frame.origin.x, _gameSize.frame.origin.y, t_Rebate.width, _gameSize.frame.size.height);
//    _gamePrice.text = [cellDic objectForKey:@"costStr"];
//    [_downUrl setString:[cellDic objectForKey:@"viewUrl"]]; //设置下载地址
//    
//    if (![[cellDic objectForKey:@"recommendedInfo"] isEqualToString:@""]) 
//    {
//        _introTagImg.hidden = NO;
//        _gameIntroduction.hidden = NO;
//        _gameIntroduction.text=[cellDic objectForKey:@"recommendedInfo"];
//    }
//    else {
//        _introTagImg.hidden = YES;
//        _gameIntroduction.hidden = YES;
//    }
//    if (![[cellDic objectForKey:@"genreListStr"] isEqualToString:@""]) {
//        _categoryTagImg.hidden = NO;
//        _gameCategory.hidden = NO;
//        _gameCategory.text =[cellDic objectForKey:@"genreListStr"]; 
//    }
//    else {
//        _categoryTagImg.hidden = YES;
//        _gameCategory.hidden = YES;
//    }
//    // _gameVersion =[self judgeDataWithDic:cellDic andString:@"gameVersion"];
//    _languageString.text = [cellDic objectForKey:@"language"];
//    _oldPrice =[cellDic objectForKey:@"oldPrice"]; 
//    _currentPrice = [cellDic objectForKey:@"curPrice"];
//    
//    // UIImage *image = nil;
//    if ([_gamePrice.text isEqualToString:@"免费"])
//    {
//        _downloadBtn.hidden = NO;
//        _downLoadBtnFree.hidden = YES;
//        //        image= [UIImage imageNamed:@"images_btn_dl_free.png"];
//        //        [_downloadBtn setBackgroundImage:image forState:UIControlStateNormal];
//        _freeLine.hidden = YES;
//    }
//    else
//    {
//        _downloadBtn.hidden = YES;
//        _downLoadBtnFree.hidden = NO;
//        
//        //        image= [UIImage imageNamed:@"images_btn_dl_time.png"];
//        //        [_downloadBtn setBackgroundImage:image forState:UIControlStateNormal];
//        _gamePrice.text = [NSString stringWithFormat:@"￥%2.1f",[_oldPrice floatValue]];
//        _freeLine.hidden = NO;    
//    }
//    [_heartView displayRating: [[cellDic objectForKey:@"recommendedIndex"] floatValue]];
    
    
    
    self.gameID = [self judgeDataWithDic:cellDic andString:@"applicationId"];
    _gameSize.text = [self judgeDataWithDic:cellDic andString:@"fileSize"];
    _gameName.text  = [self judgeDataWithDic:cellDic andString:@"title"];
    
    CGSize t_Rebate = [_gameSize.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11]];
    _gameSize.frame = CGRectMake(_gameSize.frame.origin.x, _gameSize.frame.origin.y, t_Rebate.width, _gameSize.frame.size.height);
    _gamePrice.text = [self judgeDataWithDic:cellDic andString:@"costStr"];
    
    //[_downUrl setString:[self judgeDataWithDic:cellDic andString:@"viewUrl"]]; //设置下载地址
    self.downUrl = [NSString stringWithFormat:@"%@",[cellDic objectForKey:@"viewUrl"]];
    
    if (![[self judgeDataWithDic:cellDic andString:@"recommendedInfo"] isEqualToString:@""]) 
    {
        _introTagImg.hidden = NO;
        _gameIntroduction.hidden = NO;
       
    }
    else {
        _introTagImg.hidden = YES;
        _gameIntroduction.hidden = YES;
    }
     _gameIntroduction.text=[self judgeDataWithDic:cellDic andString:@"recommendedInfo"];
    if (![[self judgeDataWithDic:cellDic andString:@"genreListStr"] isEqualToString:@""])
    {
        _categoryTagImg.hidden = NO;
        _gameCategory.hidden = NO;
    }
    else {
        _categoryTagImg.hidden = YES;
        _gameCategory.hidden = YES;
    }
    _gameCategory.text = [self judgeDataWithDic:cellDic andString:@"genreListStr"];
    _languageString.text = [self judgeDataWithDic:cellDic andString:@"language"];
    _oldPrice = [self judgeDataWithDic:cellDic andString:@"oldPrice"];
    _currentPrice = [self judgeDataWithDic:cellDic andString:@"curPrice"];
    
    if ([_gamePrice.text isEqualToString:@"免费"])
    {
        _downloadBtn.hidden = NO;
        _downLoadBtnFree.hidden = YES;
        _freeLine.hidden = YES;
    }
    else
    {
        _downloadBtn.hidden = YES;
        _downLoadBtnFree.hidden = NO;
        _gamePrice.text = [NSString stringWithFormat:@"￥%2.1f",[_oldPrice floatValue]];
        _freeLine.hidden = NO;    
    }
    [_heartView displayRating: [[cellDic objectForKey:@"recommendedIndex"] floatValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
