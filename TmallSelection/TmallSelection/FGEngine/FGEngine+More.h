//
//  FGEngine+More.h
//  FreeGames
//
//  Created by ljl on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSEngine.h"

typedef enum 
{
	more_error_type = -1,
	
	//更多页各选项
    //	question_feedback_type=0,
    score_type = 0,
    //  recommend_type,
    //  weibo_type,
    about_type,
    zbar_type
    //....
    
    
}more_request_Type;

@interface TSEngine (More)

@end
