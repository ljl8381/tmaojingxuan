//
//  FGEngine+Album.h
//  FreeGames
//
//  Created by 济泽 韩 on 12-5-18.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import "TSEngine.h"

@interface TSEngine (Album)
- (void)requestAlbumDetialData:(NSString *)albumID andPageNo:(int)pageNo;
@end
