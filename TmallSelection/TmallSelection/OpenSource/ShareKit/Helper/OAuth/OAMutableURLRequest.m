//
// OAMutableURLRequest.m
// OAuthConsumer
//
// Created by Jon Crosby on 10/19/07.
// Copyright 2007 Kaboomerang LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "OAMutableURLRequest.h"


@interface OAMutableURLRequest (Private)
-(NSString *)_signatureBaseStringTencent;
-(void)_prepareTencent;
-(void)_prepareFileDataTencent:(NSData *)_fData;
@end

@implementation OAMutableURLRequest
@synthesize fileData;

#pragma mark init


- (id)initWithURL:(NSURL *)aUrl andAppSecret:(NSString *)secret
{
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:20.0])
	{
		
        signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		appSecret=[secret retain];
	}
    return self; 
}

- (void)dealloc
{
	[signatureProvider release];
    [appSecret release];
    [extraOAuthParams release];
    [fileData release];
	[super dealloc];
}

#pragma mark -
#pragma mark Public

-(void)addOAuthParam:(OARequestParameter *)param
{
    if (!param.name||!param.value)
    {
        return;
    }
    if (extraOAuthParams==nil)
    {
        extraOAuthParams=[NSMutableArray new];
    }
    [extraOAuthParams addObject:param];
}

#pragma mark - prepare
- (void)prepare
{
    [self _prepareTencent];
    /*
    switch (weiboType)
    {
        case SHKWeiboTypeTencent:
            [self _prepareTencent];
            break;
        case SHKWeiboTypeWangyi:
            [self _prepareWangyi];
            break;
        default:
            [self _prepareDefault];
            break;
    }
     */
}

-(void)_prepareTencent
{
    if (fileData&&[fileData length])
    {
        [self _prepareFileDataTencent:fileData];
    }
	// set OAuth headers
    
   // [self addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]]];
   // [self addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce]];
   // [self addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp]];
    NSString *signClearText = [self _signatureBaseStringTencent];
    TRACE(@"sign text:%@",signClearText);
	NSString *secret = [NSString stringWithFormat:@"%@&",
                        [appSecret URLEncodedString]];
    TRACE(@"secret:%@",secret);
    
    NSString *signature = [signatureProvider signClearText:signClearText
                                      withSecret:secret];
    TRACE(@"final signature:%@",signature);
    [self addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_signature" value:signature]];
    
    if (fileData&&[fileData length])
    {
        NSString *extraParameters;
        NSMutableArray *parametersArray = [NSMutableArray array];
        // Adding the optional parameters in sorted order isn't required by the OAuth spec, but it makes it possible to hard-code expected values in the unit tests.
        for (OARequestParameter *paramItem in extraOAuthParams) 
        {
            [parametersArray addObject:[paramItem URLEncodedNameValuePair]];
        }	
        [parametersArray sortUsingSelector:@selector(compare:)];
        extraParameters=[parametersArray componentsJoinedByString:@"&"];
        [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",[[self URL] URLStringWithoutQuery],extraParameters]]];
        TRACE(@"header:%@",extraParameters);
    }
    else
    {
        //
        [self setParameters:extraOAuthParams];
    }
}

-(void)_prepareFileDataTencent:(NSData *)_fData
{
    NSString *bound=@"0194784892923";
    NSMutableString *param = [NSMutableString string];
    NSString *formDataTemplate = @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n";
    for (OARequestParameter *paramItem in extraOAuthParams) {
        NSString *formItem = [NSString stringWithFormat:formDataTemplate, bound, paramItem.name, paramItem.value];
        [param appendString:formItem];
    }
    [param appendFormat:@"--%@\r\n",bound];
    
    NSString *headerTemplate = @"Content-Disposition: form-data; name=\"pic\"; filename=\"image.jpg\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
    [param appendString:headerTemplate];
    TRACE(@"param:%@",param);     
    NSMutableData *bodyData = [NSMutableData data];
    [bodyData appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:_fData];
     NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:boundaryBytes];
    
    [self setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bound] forHTTPHeaderField:@"Content-Type"];
    [self setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [self setHTTPBody:bodyData];
}
#pragma mark -
#pragma mark Private

- (NSString *)_signatureBaseStringTencent 
{
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray *parameterPairs = [NSMutableArray  arrayWithCapacity:6]; // 6 being the number of OAuth params in the Signature Base String
    for (OARequestParameter *param in extraOAuthParams) 
    {
        [parameterPairs addObject:[param URLEncodedNameValuePair]];
    }
    
   [parameterPairs sortUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [parameterPairs componentsJoinedByString:@"&"];
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
					 [self HTTPMethod],
					 [[[self URL] URLStringWithoutQuery] URLEncodedString],
					 [normalizedRequestParameters URLEncodedString]];
	
    //TRACE(@"normalizedRequestParameters: %@, ret: %@",normalizedRequestParameters, ret);
	return ret;
}
@end
