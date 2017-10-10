//
//  ToolsHelper.h
//  CanCan
//
//  Created by 临时 on 16/10/8.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

typedef enum
{
    JCGETDATEYear,
    JCGETDATEMonth,
    JCGETDATEDay,
    JCGETDATEHour,
    JCGETDATEMinute,
    JCGETDATESecond
}JCGETDATE;
@interface ToolsHelper : NSObject

/* --------------------------------- 设备相关  --------------------------*/

//获取app版本号
+(NSString *) getAppVersion;

//获取build版本号
+(NSString *) getBuildVersion;

//获取设备系统版本 例如：8.3  9.0...
+ (NSString *) getSystemVersion;

//获取手机类型 例如：iPhone or ipad...
+ (NSString *) getDeviceModel;

//获取设备名称 例如：iPhone6   iPhone6s...
+ (NSString*) getDeviceName;


/* --------------------------------- 服务相关  --------------------------*/
//颜色色值,全局使用
+ (UIColor *) colorWithHexString: (NSString *)color;

//颜色设置，自动设置alpha值
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

//数据解析
+ (NSMutableDictionary *)lxlcustomDataToDic:(id)dic;


/* -------------------------- Des encrypt or Decrypt ------------------*/
//Des encrypt
+ (NSMutableString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key;


/**
 判断是否是手机号格式
 
 @param mobileNum 输入手机号字符串对象
 
 @return 返回Bool值，yes，表示是手机号，NO，表示不是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;



/**
 判断验证码位数是否大于等于4位
 
 @param verification 验证码字符串对像
 
 @return 返回Bool值，yes，表示验证码大于等于4位，NO，表示验证码不符合规则
 */
+ (BOOL)isVerificationCode:(NSString *)verification;

/**
 判断验证码位数是否在 6 － 16位之间
 
 @param password 密码对象
 
 @return 返回Bool值，yes，表示密码在6位 至 16位之间，NO，表示密码不符合规则
 */
+ (BOOL)isNormalPassword:(NSString *)password;



/**
 将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到30－100k

 @param image 图像对象

 @return 返回图片文件路径
 */
+ (NSString *)fileOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image;


/**
 *  20160103  转换成 2016年1月3日
 */

+ (NSString *)dateNumStringConvertedToString:(NSString *)dateNumStr;


/*+++++++++++++++++++++++++获取体重文案及👍++++++++++++++++++++++++++++*/
+ (NSDictionary *)getHeightEstimatedValue:(NSString *)sex age:(NSString *)age height:(NSString *)height name:(NSString *)name;

+ (NSDictionary *)getWeightEstimatedValue:(NSString *)sex age:(NSString *)age weight:(NSString *)weight name:(NSString *)name;

+ (NSDictionary *)getBMIEstimatedValue:(NSString *)sex age:(NSString *)age bmi:(NSString *)bmi name:(NSString *)name;



/**
 *  根据年龄返回字符串 100 身高  101 体重
 */
+ (NSString *)getWeightOrHeightEstimatedValue:(NSString *)ageStr type:(NSString *)type;


/**
 *  BMI 计算公式
 */
+ (NSString *)getBMIValue:(NSString *)heightStr weight:(NSString *)weightStr;




/**
 * 发育阶段 根据年龄  婴儿期  幼儿期  学龄前期  学龄期  过渡期（少年期） 青期  成年期
 *BABY((byte) 0, (byte) 3, "婴儿期"),
 CHILD((byte) 4, (byte) 6, "幼儿期"),
 STUDENT((byte) 7, (byte) 12, "学龄期"),
 YOUTHHOOD((byte) 13, (byte) 18, "青春期"),
 ADULT((byte) 19, (byte) 100, "成年人");
 */
+ (NSString *)getDevelopmentalStageWithChildsAge:(NSString *)age gender:(NSString *)gender;

+ (NSString *)getDevelopmentalStageCopywritingWithChildsAge:(NSString *)age gender:(NSString *)gender name:(NSString *)name;


/**
 * 发育水平
 *
 */
/**
 * BMI 中国标准 偏瘦 正常 过重 肥胖   分类	BMI 范围
 偏瘦	<= 18.4
 正常	18.5 ~ 23.9
 过重	24.0 ~ 27.9
 肥胖	>= 28.0
 
 */
+ (NSString *)getBMIStandard:(NSString*)BMIStr;

/**
 * 根据字符串转换为日期
 * 返回为NSDate
 */
+ (NSDate *)getDateString:(NSString *)dateStr;

/**
 * 根据"2016-11-11 15:57:10" 获取 月.日
 * 返回 月.日
 */
+ (NSString *)getMonthAndDay:(NSString *)dateStr;

/**
 根据时间字符串返回年
 
 @param dateStr 时间字符串
 
 @return 年
 */
+ (NSString *)getYear:(NSString *)dateStr;

/**
 根据时间字符串返回月
 
 @param dateStr 时间字符串
 
 @return 月
 */
+ (NSString *)getMonth:(NSString *)dateStr;

/**
 根据时间字符串返回日
 
 @param dateStr 时间字符串
 
 @return 日
 */
+ (NSString *)getDay:(NSString *)dateStr;


/**
 根据时间字符串返回时、分
 
 @param dateStr 时间字符串
 
 @return 时、分
 */
+ (NSString *)getTimeHAndM:(NSString *)dateStr;


/**
 根据时间字符串返回当前时间
 
 @return 当前时间
 */
+ (NSString *)getCurrentTime;

/**
 * 根据时间Date返回字符串
 */
+(NSString*)dateTodateString:(NSDate *)date;

#pragma mark - 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text;


/**
 *  截图
 *
 *  @param theView 所截图像所在view
 *  @param r       截图范围
 *
 *  @return 所得图片
 */
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r;

/**
 *  等比例压缩图片
 *
 *  @param sourceImage 原图
 *  @param size        压缩比例
 *
 *  @return image
 */
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (NSString *)fileJCOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image;

//等比例压缩图片
+ (UIImage *)cutImage:(UIImage*)image withSize:(CGSize)size;

//设置有新消息改变成带红点图片
+ (void)jcSetHaveNewMessageChangeTabBarItemImg;

//设置没有新消息改变成不带红点图片
+ (void)jcSetHaveNoNewMessageChangeTabBarItemImg;

+ (void)jcShowHudToast:(id)showView withImgName:(NSString *)img withTitle:(NSString *)title withAfterDelay:(NSTimeInterval)delay;

+ (void)jcShowCustomTipViewWithImgName:(NSString *)img withTitle:(NSString *)title withAfterDelay:(NSTimeInterval)delay;
//点赞个数格式化
+ (NSString *)jcFormatLikeCount:(NSString *)sourceString;

//评论时间的转换
+ (NSString *)jcFormatCommentDateFromDateStr:(NSString *)dateStr;

//步数统计时间的转换
+ (NSString *)jcFormatStepDateFromDateStr:(NSString *)dateStr;

//通知消息列表时间的转换
+ (NSString *)jcFormatNoticeDateFromDateStr:(NSString *)dateStr;

//此段代码可以获取本地异常日志
+ (NSString *)jcGetUncaughtException;

//获取异常日志的路径
+ (NSString *)jcGetUncaughtExceptionPath;

//获取输入日志的路径
+ (NSString *)jcGetLogPath;

//获取年龄类
+ (NSInteger)ageWithDateOfBirth:(NSString *)date;
//计算文字宽度和高度
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

//将原始格式的时间字符串转为目标格式的时间字符串
+(NSString *)jcFormateDatefromDateStr:(NSString *)dateStr  withSourceFormate:(NSString *)source withTargetFromate:(NSString *)target;


/**
 根据百分比获取好姿态标语及描述语

 @param percentage 姿态百分比
 @param typeStr 100 表示获取好姿态标语 101表示获取好姿态描述语
 @param arr 百分比集合
 @param uppercentage 上个百分比
 @param coverIndx 表示选中区域
 @return 返回对应的标语或者描述语
 */

+(NSString *)getGoodPostureTipAndDescribe:(NSString *)percentage withType:(NSString *)typeStr percentArr:(NSMutableArray *)arr upPercent:(NSString *)uppercentage coverIndx:(NSInteger)coverIndx;

/**
 根据年龄步数性别来获取步数的百分比，以及运动步数的描述语
 
 @param age 年龄
 @param theyCount 步数
 @param gender 0男  1女
 @param type 100 表示获取百分比 101表示获取步数描述语
 @return 返回对应的百分比或者描述语
 */
+(id)jcGetTheyCountDescribeAndPercentWithAge:(NSInteger)age withTheyCount:(NSInteger)theyCount withGender:(NSInteger)gender withType:(NSInteger)type;

/**
 根据消耗卡路里来返回描述语言
 
 @param kaluLi 消耗卡路里数
 @return 返回对应的描述语
 */
+(NSString *)jcGetKaluliDesc:(NSInteger)kaluLi;
/**
 根据行走步数来计算卡路里
 @param theyCount 行走步数
 @param height    身高/m
 @param weigth    体重/kg
 @return 返回消耗的卡路里(千卡)
 */

+(NSInteger)jcGetKaluliValueWithTheyCount:(NSInteger)theyCount withHeight:(NSInteger)height withWeigth:(NSInteger)weigth;

/**
 根据年龄性别来获取该年龄段最大步数
 
 @param age 年龄
 
 @param gender 0男  1女
 @return 返回对应的步数
 */
+(NSInteger)jcGetTheyCountDescribeAndPercentWithAge:(NSInteger)age withGender:(NSInteger)gender;


//时间转换成时间戳
+(NSString *)dateChangeToTimestamp:(NSDate *)date;

//时间戳转换成时间字符串
+(NSString *)timestampChangeToDate:(NSInteger)_time;

//根据状态，来获取运动量描述语言
+(NSString *)jcGetActionDescWithStatus:(NSString *)status;

/*
 @param  data      mac的16进制地址，NSData类型
 @return NSString  从data转换而成的mac地址
 */
+ (NSString *)convertToBleMacAddressStringWithNSData:(NSData *)data;

/*
 
 @param  type  枚举类型，年月日时分秒
 @desc   根据所传输的枚举类型，获取当天的年月日时分秒
 */
+ (NSString *)jcGetTodayDateByType:(JCGETDATE)type;

/*
 @param dateStr   原始日期字符串
 @param type      枚举类型，年月日时分秒
 @desc            根据传输的枚举类型，解析原始日期字符串，获取对应的年月日时分秒
 */
+ (NSString *)jcGetHistoryDateByStr:(NSString *)dateStr withType:(JCGETDATE)type;

//根据徽章级别，获取徽章分享的图片
+(NSString *)jcGetShareBadgeImgWithMedalLevel:(NSInteger)level;

@end
