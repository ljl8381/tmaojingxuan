//
//  FGEngine+Album.m
//  FreeGames
//
//  Created by 济泽 韩 on 12-5-18.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import "FGEngine+Album.h"
#import "AlbumDetialPage.h"
#import "FGAlbumObject.h"
@implementation TSEngine (Album)
//请求专辑合辑页面数据
- (void)requestAlbumData
{
    TRACE(@"请求专辑合辑页面数据");
    [_fgHttpObject requestAlbumData];   
}

- (void)requestEarlierData:(int)PageNo
{
    [_fgHttpObject requestEarlierData:PageNo];   

}
//跳转到Album详细页面
- (void)showAlbumDetialPage:(UIViewController *)supperViewController withDic:(NSDictionary *)albumDic;
{
    [self reportEvent:[NSString stringWithFormat:@"%@页跳转到专辑详情",[supperViewController class]] withParameters:nil];
    TRACE(@"跳转到+Album详细页面");
    AlbumDetialPage *albumDetailView = [[AlbumDetialPage alloc]init];
    albumDetailView.adDelegate = self;
    FGAlbumObject *album = [FGAlbumObject getAlbumObjectWithDic:albumDic];
    albumDetailView.album =album;
    [albumDetailView reloadTableView];
    [supperViewController.navigationController pushViewController:albumDetailView animated:YES];
    [self requestAlbumDetialData:album.AlbumId andPageNo:0];
    [albumDetailView release];
    
}
//请求专辑详细页数据
- (void)requestAlbumDetialData:(NSString *)albumID andPageNo:(int)pageNo;
{
    TRACE(@"请求专辑合辑详细页面数据");
    [_fgHttpObject requestAlbumDetialData:albumID andPageNo:pageNo];   
}

@end
