#import <UIKit/UIKit.h>

@interface NSString (CCString)

//	ui
- (void)show_alert_title:(NSString*)title message:(NSString*)msg;
- (void)show_alert_message:(NSString*)msg;
- (void)show_alert_title:(NSString*)title;
- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj;

//	application
- (BOOL)go_url;
- (BOOL)can_go_url;

//	file
- (NSString*)filename_document;
- (NSString*)filename_bundle;
- (BOOL)is_directory;
- (BOOL)file_exists;
- (BOOL)file_exists_bundle;
- (BOOL)create_dir;
- (BOOL)file_backup;
- (BOOL)file_backup_to:(NSString*)dest;

//	url
- (NSString*)url_to_filename;
- (NSString*)to_url;

//	string
- (BOOL)has_substring:(NSString*)sub;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions;
- (NSString*)string_between:(NSString*)head and:(NSString*)tail;
//取指定字符串，之前，之后(暂时只支持一个符号)
- (NSDictionary*)string_head_tail:(NSString*)sub;
//取head到尾巴的字符
- (NSString*)string_tail:(NSString*)head;
//替换指定字符为
- (NSString*)string_replace:(NSString*)findstring to:(NSString*)replacestring;
//替换掉所有非数据字符
- (NSString*)trimNONumberString;
//unicode 转NSString
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//	date and time
- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new;
- (time_t)convert_date_string_to_unix;

//md5
+ (NSString*)genmd5:(NSString*)nstr;


//英文2个算1个字符，中文1个算1个字符）计算字符数
-(int)count_charNum;
//计算字符数
- (int)calc_charsetNum;
//检查是不是有表情
- (BOOL)isExitsFace;
//去除输入汉字时不小心输入的半个字符
- (NSString*)trimUnichar;
// 去除字符串两端的空格字符，中间的空格不予处理<仍保留>
- (NSString*)trimWhiteSpaceInTwoEnds;

@end

