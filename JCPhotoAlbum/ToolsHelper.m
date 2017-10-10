//
//  ToolsHelper.m
//  CanCan
//
//  Created by 临时 on 16/10/8.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#import "ToolsHelper.h"
#import <sys/utsname.h>
#import "AppDelegate.h"

NSString * const theyCountDes1 = @"不足";
NSString * const theyCountDes2 = @"一般";
NSString * const theyCountDes3 = @"很不错";
NSString * const theyCountDes4 = @"太棒了";

@implementation ToolsHelper

#pragma mark -
#pragma mark - 获取app版本号
+(NSString *) getAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
#pragma mark -
#pragma mark - 获取build版本号
+(NSString *) getBuildVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
#pragma mark -
#pragma mark - 获取设备系统版本 例如：iOS 10.0...
+(NSString *) getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark -
#pragma mark - 获取手机类型 例如：iphone or ipad...
+(NSString *)getDeviceModel
{
    return [[UIDevice currentDevice] model];
}

#pragma mark - 
#pragma mark - 获取设备名称 如：iPhone6   iPhone6s...
+(NSString*) getDeviceName {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPhone9,1" :@"iPhone 7",
                              @"iPhone9,2" :@"iPhone 7 Plus",
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}



#pragma mark -
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}




#pragma mark -
#pragma mark -数据解析
+(NSMutableDictionary *)lxlcustomDataToDic:(id)dic{
    
    NSData *data=nil;
    
    if (!dic) {
        return nil;
    }
    
    if([dic isKindOfClass:[NSDictionary class]]){
        
        return dic;
        
    }else if ([dic isKindOfClass:[NSData class]]) {
        
        data=dic;
        
    }else if([dic isKindOfClass:[NSString class]]){
        
        data=[dic dataUsingEncoding:NSUTF8StringEncoding];
        
    }else{
        
        return nil;
        
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
}





//NSData转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

/**
 判断是否是手机号格式
 
 @param mobileNum 输入手机号字符串对象
 
 @return 返回Bool值，yes，表示是手机号，NO，表示不是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:mobileNum];
}


/**
 判断验证码位数是否大于等于4位
 
 @param verification 验证码字符串对像
 
 @return 返回Bool值，yes，表示验证码大于等于4位，NO，表示验证码不符合规则
 */
+ (BOOL)isVerificationCode:(NSString *)verification{
    
    if (verification.length<4) {
        return NO;
    }
    
    return YES;
    
}


/**
 判断密码位数是否在 6 － 16位之间

 @param password 密码对象

 @return 返回Bool值，yes，表示密码在6位 至 16位之间，NO，表示密码不符合规则
 */
+ (BOOL)isNormalPassword:(NSString *)password{
    
    if (password.length>=6 &&password.length<=16) {
        return YES;
    }
    
    return NO;
}


//将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到40－100k，
+ (NSString *)fileOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image{
    
    NSLog(@"%@", NSStringFromCGSize(image.size));
    
    NSString *tmpDic = NSTemporaryDirectory(); //生成一个临时目录，生命周期很短
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = image.size.height;
    imageSize.width = image.size.width;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [[UIColor blackColor] setFill];
    [p fill];
    
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
//    NSData *pressSizeData1 = UIImageJPEGRepresentation(imageHavePress, 1.0);
    UIGraphicsEndImageContext();
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, compression);
    while ([pressSizeData length] > 200*1024 && compression > maxCompression) {
        compression -= 0.1;
        pressSizeData = UIImageJPEGRepresentation(imageHavePress, compression);
    }
//    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
//    
//    if (pressSizeData.length>1024*1024){
//        pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
//    }

    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
}

//将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到500k，
+ (NSString *)fileJCOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image{
    
    NSLog(@"%@", NSStringFromCGSize(image.size));
    
    NSString *tmpDic = NSTemporaryDirectory(); //生成一个临时目录，生命周期很短
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = image.size.height;
    imageSize.width = image.size.width;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [[UIColor blackColor] setFill];
    [p fill];
    
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
    //    NSData *pressSizeData1 = UIImageJPEGRepresentation(imageHavePress, 1.0);
    UIGraphicsEndImageContext();
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, compression);
    while ([pressSizeData length] > 500*1024 && compression > maxCompression) {
        compression -= 0.1;
        pressSizeData = UIImageJPEGRepresentation(imageHavePress, compression);
    }
    //    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    //
    //    if (pressSizeData.length>1024*1024){
    //        pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    //    }
    
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
}

/**
 *  20160103  转换成 2016年1月3日
 */

+ (NSString *)dateNumStringConvertedToString:(NSString *)dateNumStr{
    
    NSString *dateStr =[NSString new];

    if (dateNumStr.length ==8) {
        
        NSString *yearS =[dateNumStr substringToIndex:4];
        yearS = [yearS stringByAppendingString:@"年"];
        dateStr =yearS;
        
        NSString *monthS =[dateNumStr substringWithRange:NSMakeRange(4, 2)];
        if ([monthS hasPrefix:@"0"]) {
            monthS =[monthS substringFromIndex:1];
        }
        monthS =[monthS stringByAppendingString:@"月"];
        dateStr =[dateStr stringByAppendingString:monthS];
        
        NSString *dayS =[dateNumStr substringFromIndex:6];
        if ([dayS hasPrefix:@"0"]) {
            dayS =[dayS substringFromIndex:1];
        }
        dayS =[dayS stringByAppendingString:@"日"];
        dateStr =[dateStr stringByAppendingString:dayS];
        
    }else{
    
        dateStr =dateNumStr;
        
    }
    
    return dateStr;
}

/**
 *  根据年龄返回字符串 100 身高  101 体重
 */
+ (NSString *)getWeightOrHeightEstimatedValue:(NSString *)ageStr type:(NSString *)type {
    
   
        if ([type isEqualToString:@"101"]) {//体重 kg
            
            if ([ageStr integerValue]<1) {
                
                return @"3.8";
                
            }else if ([ageStr integerValue]==1){
                
                return @"10.1";
                
            }else if ([ageStr integerValue]==2){
                
                return @"12.5";
                
            }else if ([ageStr integerValue]==3){
                
                return @"14.7";
                
            }else if ([ageStr integerValue]==4){
                
                return @"16.7";
                
            }else if([ageStr integerValue]==5){
                
                return @"19.0";
                
            }else if([ageStr integerValue]==6){
                
                return @"21.3";
                
            }else if([ageStr integerValue]==7){
                
                return @"24.1";
                
            }else if([ageStr integerValue]==8){
                
                return @"27.3";
                
            }else if([ageStr integerValue]==9){
                
                return @"30.5";
                
            }else if([ageStr integerValue]==10){
                
                return @"33.8";
                
            }else if([ageStr integerValue]==11){
                
                return @"37.7";
                
            }else if([ageStr integerValue]==12){
                
                return @"42.5";
                
            }else if([ageStr integerValue]==13){
                
                return @"48.1";
                
            }else if([ageStr integerValue]==14){
                
                return @"53.4";
                
            }else if([ageStr integerValue]==15){
                
                return @"57.1";
                
            }else if([ageStr integerValue]==16){
                
                return @"59.4";
                
            }else if([ageStr integerValue]==17){
                
                return @"60.7";
                
            }else if([ageStr integerValue]==18){
                
                return @"61.4";
                
            }else {
                
                return @"61.4";
                
            }
            
        }else{//身高 cm
            
            if ([ageStr integerValue]<1) {
                
                return @"50";
                
            }else if ([ageStr integerValue]==1){
                
                return @"77";
                
            }else if ([ageStr integerValue]==2){
                return @"89";
                
            }else if ([ageStr integerValue]==3){
                return @"97";
                
            }else if ([ageStr integerValue]==4){
                return @"104";
                
            }else if([ageStr integerValue]==5){
                return @"111";
                
            }else if([ageStr integerValue]==6){
                return @"118";
                
            }else if([ageStr integerValue]==7){
                return @"124";
                
            }else if([ageStr integerValue]==8){
                return @"130";
                
            }else if([ageStr integerValue]==9){
                return @"135";
                
            }else if([ageStr integerValue]==10){
                return @"140";
                
            }else if([ageStr integerValue]==11){
                return @"145";
                
            }else if([ageStr integerValue]==12){
                return @"152";
                
            }else if([ageStr integerValue]==13){
                return @"160";
                
            }else if([ageStr integerValue]==14){
                return @"166";
                
            }else if([ageStr integerValue]==15){
                return @"170";
                
            }else if([ageStr integerValue]==16){
                return @"172";
                
            }else if([ageStr integerValue]==17){
                return @"172";
                
            }else if([ageStr integerValue]==18){
                return @"173";
                
            }else{
                
                return @"173";
                
            }
            
            
        }


}

/**
 *  BMI 计算公式
 */
+ (NSString *)getBMIValue:(NSString *)heightStr weight:(NSString *)weightStr{

    NSInteger heightInt =[heightStr integerValue];
    double weightDouble =[weightStr doubleValue];
    double bmiDouble =weightDouble/pow(heightInt/100.0,2);
    
    // BMI=体重(kg)／身高(M)ˆ2
    
    NSLog(@"%lf   %lf",pow(heightInt/100.0,2),round(bmiDouble*10)/10);
    
    return [NSString stringWithFormat:@"%.1lf",round(bmiDouble*10)/10];
}

/**
 * BMI 中国标准 偏瘦 正常 过重 肥胖   分类	BMI 范围
 偏瘦	<= 18.4
 正常	18.5 ~ 23.9
 过重	24.0 ~ 27.9
 肥胖	>= 28.0
 
 */
+ (NSString *)getBMIStandard:(NSString*)BMIStr{

    double bmiDouble = [BMIStr doubleValue];
    
    if (bmiDouble<=18.4) {
        
        return @"偏瘦";
        
    }else if (bmiDouble>=18.5 && bmiDouble<=23.9){
        
        return @"正常";
    
    }else if (bmiDouble>=24.0 && bmiDouble<=27.9){
        
        return @"过重";
    
    }else{
     
        return @"肥胖";
        
    }
    
}

/**
 * 发育阶段 根据年龄  婴儿期  幼儿期  学龄前期  学龄期  过渡期（少年期） 青期  成年期
BABY((byte) 0, (byte) 3, "婴儿期"),
CHILD((byte) 4, (byte) 6, "幼儿期"),
STUDENT((byte) 7, (byte) 12, "学龄期"),
YOUTHHOOD((byte) 13, (byte) 18, "青春期"),
ADULT((byte) 19, (byte) 100, "成年人");
*/
+ (NSString *)getDevelopmentalStageWithChildsAge:(NSString *)age gender:(NSString *)gender{
    
    NSInteger genderInt =[gender integerValue];
    NSInteger ageInt =[age integerValue];
    
    if (genderInt==0) {//男孩
    
        if (ageInt>=0 && ageInt<=1) {
            
            return @"婴儿期";
            
        }else if (ageInt>=2 && ageInt<=3){
            
            return @"幼儿期";
            
        }else if (ageInt>=4 && ageInt<=6){
            
            return @"学龄前期";
            
        }else if (ageInt>=7 && ageInt<=12){
            
            return @"学龄期";
            
        }else if(ageInt>=13 && ageInt<=17){
            
            return @"青春期";
            
        }else{
            
            return @"成年人";
            
        }
        
    }else{//女孩
        
        if (ageInt>=0 && ageInt<=1) {
            
            return @"婴儿期";
            
        }else if (ageInt>=2 && ageInt<=3){
            
            return @"幼儿期";
            
        }else if (ageInt>=4 && ageInt<=6){
            
            return @"学龄前期";
            
        }else if (ageInt>=7 && ageInt<=12){
            
            return @"学龄期";
            
        }else if(ageInt>=13 && ageInt<=17){
            
            return @"青春期";
            
        }else{
            
            return @"成年人";
            
        }
    
    }
    
}


+ (NSString *)getDevelopmentalStageCopywritingWithChildsAge:(NSString *)age gender:(NSString *)gender name:(NSString *)name{
    
    NSInteger genderInt =[gender integerValue];
    NSInteger ageInt =[age integerValue];
    
    if (genderInt==0) {//男孩
        
        if (ageInt>=0 && ageInt<=1) {
            
            return [NSString stringWithFormat:@"    目前%@处于婴儿期，婴儿期一段时间内大脑仍处于迅速发育状态，需要充足均衡合理的营养素（特别是优质蛋白）的支持。\n    需要家长要特别注意孩子的营养补充，保证孩子充足的睡眠时间，当然不能忘记动作教育和感知觉教育。",name];
            
        }else if (ageInt>=2 && ageInt<=3){
            
            return [NSString stringWithFormat:@"    目前%@处于幼儿期，幼儿期小儿生长速度减慢，智能发育加速，由于缺乏对危险事物的识别能力和自我保护能力，易发生意外伤害和中毒，此期保健重点在于培养良好的饮食卫生习惯，保证营养和辅食添加。\n    需要家长注意孩子牙齿的健康，因为牙齿的发育可以反映骨骼的发育情况。",name];
            
        }else if (ageInt>=4 && ageInt<=6){
            
            return [NSString stringWithFormat:@"    目前%@处于学龄前期，学龄前期体格生长发育处于稳步增长状态，智能发育较幼儿期更加迅速，与同龄儿童和社会事物有了广泛的接触，知识面能够得以扩大，自理能力和初步社交能力能够得到锻炼。\n    需要家长要特别注意孩子优质蛋白要补充，矿物质与维生素不能少，营养要均衡。",name];
            
        }else if (ageInt>=7 && ageInt<=12){
            
            return [NSString stringWithFormat:@"    目前%@正处于学龄期，学龄期是孩子学习知识的关键期，同时也是孩子身体生长的关键期，在这个时期，家长要注意多出些时间让孩子进行体育锻炼，让孩子的身体体质保持良好，这对孩子的学习也是很有帮助的。\n    需要家长注意孩子的脊椎保健、视力保健以及体质保健。",name];
            
        }else if(ageInt>=13 && ageInt<=17){
            
            return [NSString stringWithFormat:@"    目前%@处于青春期，青春期正处于生长发育的旺盛时期，对各种营养的需求量远远高于成人，因此营养问题显得更为重要。\n    青春期的孩子可能有些小叛逆，家长要善于疏通教导。",name];
            
        }else{
            
            return [NSString stringWithFormat:@"    目前%@已经是成年人，要注意多锻炼身体，提高身体素质",name];
            
        }
        
    }else{//女孩
        
        if (ageInt>=0 && ageInt<=1) {
            
            return [NSString stringWithFormat:@"    目前%@处于婴儿期，婴儿期一段时间内大脑仍处于迅速发育状态，需要充足均衡合理的营养素（特别是优质蛋白）的支持。\n    需要家长要特别注意孩子的营养补充，保证孩子充足的睡眠时间，当然不能忘记动作教育和感知觉教育。",name];
            
        }else if (ageInt>=2 && ageInt<=3){
            
            return [NSString stringWithFormat:@"    目前%@处于幼儿期，幼儿期小儿生长速度减慢，智能发育加速，由于缺乏对危险事物的识别能力和自我保护能力，易发生意外伤害和中毒，此期保健重点在于培养良好的饮食卫生习惯，保证营养和辅食添加。\n    需要家长注意孩子牙齿的健康，因为牙齿的发育可以反映骨骼的发育情况。",name];
            
        }else if (ageInt>=4 && ageInt<=6){
            
            return [NSString stringWithFormat:@"    目前%@处于学龄前期，学龄前期体格生长发育处于稳步增长状态，智能发育较幼儿期更加迅速，与同龄儿童和社会事物有了广泛的接触，知识面能够得以扩大，自理能力和初步社交能力能够得到锻炼。\n    需要家长要特别注意孩子优质蛋白要补充，矿物质与维生素不能少，营养要均衡。",name];
            
        }else if (ageInt>=7 && ageInt<=12){
            
            return [NSString stringWithFormat:@"    目前%@正处于学龄期，学龄期是孩子学习知识的关键期，同时也是孩子身体生长的关键期，在这个时期，家长要注意多出些时间让孩子进行体育锻炼，让孩子的身体体质保持良好，这对孩子的学习也是很有帮助的。\n    需要家长注意孩子的脊椎保健、视力保健以及体质保健。",name];
            
        }else if(ageInt>=13 && ageInt<=17){
            
            return [NSString stringWithFormat:@"    目前%@处于青春期，青春期正处于生长发育的旺盛时期，对各种营养的需求量远远高于成人，因此营养问题显得更为重要。\n    青春期的孩子可能有些小叛逆，家长要善于疏通教导。",name];
            
        }else{
            
            return [NSString stringWithFormat:@"    目前%@已经是成年人，要注意多锻炼身体，提高身体素质",name];
            
        }
        
    }
    
}

/*+++++++++++++++++++++++++获取身高、体重、BMI文案及👍++++++++++++++++++++++++++++*/
+ (NSDictionary *)getHeightEstimatedValue:(NSString *)sex age:(NSString *)age height:(NSString *)height name:(NSString *)name{
    
    NSInteger sexInt=[sex integerValue];
    NSInteger ageInt =[age integerValue];
    NSInteger heightInt =[height integerValue];
    
    if (sexInt==0) {//男人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getHeightState:47 endHeight:50 height:heightInt name:name];
            case 1:
                return [ToolsHelper getHeightState:72 endHeight:83 height:heightInt name:name];
            case 2:
                return [ToolsHelper getHeightState:83 endHeight:90 height:heightInt name:name];
            case 3:
                return [ToolsHelper getHeightState:90 endHeight:97 height:heightInt name:name];
            case 4:
                return [ToolsHelper getHeightState:97 endHeight:104 height:heightInt name:name];
            case 5:
                return [ToolsHelper getHeightState:103 endHeight:111 height:heightInt name:name];
            case 6:
                return [ToolsHelper getHeightState:109 endHeight:118 height:heightInt name:name];
            case 7:
                return [ToolsHelper getHeightState:115 endHeight:124 height:heightInt name:name];
            case 8:
                return [ToolsHelper getHeightState:120 endHeight:130 height:heightInt name:name];
            case 9:
                return [ToolsHelper getHeightState:125 endHeight:135 height:heightInt name:name];
            case 10:
                return [ToolsHelper getHeightState:129 endHeight:150 height:heightInt name:name];
            case 11:
                return [ToolsHelper getHeightState:133 endHeight:155 height:heightInt name:name];
            case 12:
                return [ToolsHelper getHeightState:138 endHeight:162 height:heightInt name:name];
            case 13:
                return [ToolsHelper getHeightState:145 endHeight:170 height:heightInt name:name];
            case 14:
                return [ToolsHelper getHeightState:152 endHeight:176 height:heightInt name:name];
            case 15:
                return [ToolsHelper getHeightState:157 endHeight:180 height:heightInt name:name];
            case 16:
                return [ToolsHelper getHeightState:160 endHeight:182 height:heightInt name:name];
            case 17:
                return [ToolsHelper getHeightState:161 endHeight:182 height:heightInt name:name];
            case 18:
                return [ToolsHelper getHeightState:161 endHeight:186 height:heightInt name:name];
            default:
                return [ToolsHelper getHeightState:161 endHeight:186 height:heightInt name:name];
                
        }

        
    }else{//女人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getHeightState:47 endHeight:50 height:heightInt name:name];
            case 1:
                return [ToolsHelper getHeightState:70 endHeight:75 height:heightInt name:name];
            case 2:
                return [ToolsHelper getHeightState:81 endHeight:87 height:heightInt name:name];
            case 3:
                return [ToolsHelper getHeightState:89 endHeight:96 height:heightInt name:name];
            case 4:
                return [ToolsHelper getHeightState:96 endHeight:103 height:heightInt name:name];
            case 5:
                return [ToolsHelper getHeightState:102 endHeight:110 height:heightInt name:name];
            case 6:
                return [ToolsHelper getHeightState:108 endHeight:117 height:heightInt name:name];
            case 7:
                return [ToolsHelper getHeightState:113 endHeight:123 height:heightInt name:name];
            case 8:
                return [ToolsHelper getHeightState:119 endHeight:139 height:heightInt name:name];
            case 9:
                return [ToolsHelper getHeightState:123 endHeight:144 height:heightInt name:name];
            case 10:
                return [ToolsHelper getHeightState:128 endHeight:150 height:heightInt name:name];
            case 11:
                return [ToolsHelper getHeightState:134 endHeight:157 height:heightInt name:name];
            case 12:
                return [ToolsHelper getHeightState:140 endHeight:162 height:heightInt name:name];
            case 13:
                return [ToolsHelper getHeightState:145 endHeight:166 height:heightInt name:name];
            case 14:
                return [ToolsHelper getHeightState:148 endHeight:169 height:heightInt name:name];
            case 15:
                return [ToolsHelper getHeightState:150 endHeight:170 height:heightInt name:name];
            case 16:
                return [ToolsHelper getHeightState:150 endHeight:170 height:heightInt name:name];
            case 17:
                return [ToolsHelper getHeightState:150 endHeight:170 height:heightInt name:name];
            case 18:
                return [ToolsHelper getHeightState:150 endHeight:171 height:heightInt name:name];
            default:
                return [ToolsHelper getHeightState:150 endHeight:171 height:heightInt name:name];
                
        }
        
        
    }

}

+(NSDictionary *) getHeightState:(NSInteger)start endHeight:(NSInteger)endHeight height:(NSInteger)height name:(NSString *)name{

    NSInteger typeSate =0; //不正常
    NSInteger base =endHeight;
    NSString *text =@"";
    
    if (height < start) {
        typeSate = 0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的身高矮小\n建议进行相关检查,排除矮小症等症状",name];
        
    } else if (height > endHeight) {
        typeSate = 0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的身高高于正常范围\n建议密切关注，也可进行相关检查",name];
    } else {
        typeSate = 1;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的身高正常\n继续保持",name];
    }
   // return @{@"typeState":,@"base":[NSString stringWithFormat:@"%ld",base],@"text":text};
    
    return @{@"typeState":[NSNumber numberWithInteger:typeSate],@"base":[NSNumber numberWithInteger:base],@"text":text};
    
    
}





+ (NSDictionary *)getWeightEstimatedValue:(NSString *)sex age:(NSString *)age weight:(NSString *)weight name:(NSString *)name{
    
    NSInteger sexInt=[sex integerValue];
    NSInteger ageInt =[age integerValue];
    double weightDouble =[weight doubleValue];
    
    if (sexInt==0) {//男人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getWeightState:2.9 endWeight:3.8 weight:weightDouble name:name];
            case 1:
                return [ToolsHelper getWeightState:9.0 endWeight:10.1 weight:weightDouble name:name];
            case 2:
                return [ToolsHelper getWeightState:11.2 endWeight:12.5 weight:weightDouble name:name];
            case 3:
                return [ToolsHelper getWeightState:13.1 endWeight:14.7 weight:weightDouble name:name];
            case 4:
                return [ToolsHelper getWeightState:14.9 endWeight:16.6 weight:weightDouble name:name];
            case 5:
                return [ToolsHelper getWeightState:16.9 endWeight:19.0 weight:weightDouble name:name];
            case 6:
                return [ToolsHelper getWeightState:18.7 endWeight:21.2 weight:weightDouble name:name];
            case 7:
                return [ToolsHelper getWeightState:20.8 endWeight:24.1 weight:weightDouble name:name];
            case 8:
                return [ToolsHelper getWeightState:23.2 endWeight:27.3 weight:weightDouble name:name];
            case 9:
                return [ToolsHelper getWeightState:25.5 endWeight:40.5 weight:weightDouble name:name];
            case 10:
                return [ToolsHelper getWeightState:27.9 endWeight:43.7 weight:weightDouble name:name];
            case 11:
                return [ToolsHelper getWeightState:31.0 endWeight:47.7 weight:weightDouble name:name];
            case 12:
                return [ToolsHelper getWeightState:34.7 endWeight:52.5 weight:weightDouble name:name];
            case 13:
                return [ToolsHelper getWeightState:39.2 endWeight:58.1 weight:weightDouble name:name];
            case 14:
                return [ToolsHelper getWeightState:44.1 endWeight:63.4 weight:weightDouble name:name];
            case 15:
                return [ToolsHelper getWeightState:48.0 endWeight:67.1 weight:weightDouble name:name];
            case 16:
                return [ToolsHelper getWeightState:50.6 endWeight:69.4 weight:weightDouble name:name];
            case 17:
                return [ToolsHelper getWeightState:52.2 endWeight:70.7 weight:weightDouble name:name];
            case 18:
                return [ToolsHelper getWeightState:53.1 endWeight:71.4 weight:weightDouble name:name];
            default:
                return [ToolsHelper getWeightState:53.1 endWeight:71.4 weight:weightDouble name:name];
                
        }
        
        
    }else{//女人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getWeightState:2.7 endWeight:3.6 weight:weightDouble name:name];
            case 1:
                return [ToolsHelper getWeightState:8.5 endWeight:9.4 weight:weightDouble name:name];
            case 2:
                return [ToolsHelper getWeightState:10.7 endWeight:17.0 weight:weightDouble name:name];
            case 3:
                return [ToolsHelper getWeightState:12.7 endWeight:19.1 weight:weightDouble name:name];
            case 4:
                return [ToolsHelper getWeightState:14.4 endWeight:21.1 weight:weightDouble name:name];
            case 5:
                return [ToolsHelper getWeightState:16.2 endWeight:23.3 weight:weightDouble name:name];
            case 6:
                return [ToolsHelper getWeightState:18.0 endWeight:25.3 weight:weightDouble name:name];
            case 7:
                return [ToolsHelper getWeightState:18.0 endWeight:27.7 weight:weightDouble name:name];
            case 8:
                return [ToolsHelper getWeightState:21.8 endWeight:30.2 weight:weightDouble name:name];
            case 9:
                return [ToolsHelper getWeightState:24.0 endWeight:33.1 weight:weightDouble name:name];
            case 10:
                return [ToolsHelper getWeightState:26.6 endWeight:36.8 weight:weightDouble name:name];
            case 11:
                return [ToolsHelper getWeightState:30.0 endWeight:41.1 weight:weightDouble name:name];
            case 12:
                return [ToolsHelper getWeightState:34.0 endWeight:45.8 weight:weightDouble name:name];
            case 13:
                return [ToolsHelper getWeightState:37.9 endWeight:50.0 weight:weightDouble name:name];
            case 14:
                return [ToolsHelper getWeightState:41.2 endWeight:53.8 weight:weightDouble name:name];
            case 15:
                return [ToolsHelper getWeightState:43.4 endWeight:54.8 weight:weightDouble name:name];
            case 16:
                return [ToolsHelper getWeightState:44.6 endWeight:55.8 weight:weightDouble name:name];
            case 17:
                return [ToolsHelper getWeightState:45.0 endWeight:56.2 weight:weightDouble name:name];
            case 18:
                return [ToolsHelper getWeightState:45.3 endWeight:61.4 weight:weightDouble name:name];
            default:
                return [ToolsHelper getWeightState:45.3 endWeight:61.4 weight:weightDouble name:name];
                
        }
    }
}


+(NSDictionary *) getWeightState:(double)start endWeight:(double)endWeight weight:(double)weight name:(NSString *)name{
    
    NSInteger typeSate =0; //不正常
    double base =endWeight;
    NSString *text =@"";
    
    
    if (weight < start) {
        typeSate = 0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的体重低于正常范围\n建议增强营养,进行检查排除营养不良等疾病",name];
        
    } else if (weight > endWeight) {
        typeSate = 0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的体重高于正常范围\n小心肥胖，建议控制饮食，增加运动",name];
    } else {
        typeSate = 1;
        text = [NSString stringWithFormat:@"与同龄孩子相比%@的体重正常\n继续保持",name];
    }
    
    
    return @{@"typeState":[NSNumber numberWithInteger:typeSate],@"base":[NSNumber numberWithInteger:base],@"text":text};
    
}






+ (NSDictionary *)getBMIEstimatedValue:(NSString *)sex age:(NSString *)age bmi:(NSString *)bmi name:(NSString *)name{

    NSInteger sexInt=[sex integerValue];
    NSInteger ageInt =[age integerValue];
    double bmiDouble =[bmi doubleValue];

    if (sexInt==0) {//男人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getBMIState:15.2 endBMI:17.6  fatBMI:18.9 bmi:bmiDouble name:name];
            case 1:
                return [ToolsHelper getBMIState:15.2 endBMI:17.6  fatBMI:18.9 bmi:bmiDouble name:name];
            case 2:
                return [ToolsHelper getBMIState:15.2 endBMI:17.6  fatBMI:18.9 bmi:bmiDouble name:name];
            case 3:
                return [ToolsHelper getBMIState:14.8 endBMI:17.6  fatBMI:19.0 bmi:bmiDouble name:name];
            case 4:
                return [ToolsHelper getBMIState:14.4 endBMI:17.6  fatBMI:19.2 bmi:bmiDouble name:name];
            case 5:
                return [ToolsHelper getBMIState:14.0 endBMI:17.6  fatBMI:19.3 bmi:bmiDouble name:name];
            case 6:
                return [ToolsHelper getBMIState:13.9 endBMI:17.8  fatBMI:19.6 bmi:bmiDouble name:name];
            case 7:
                return [ToolsHelper getBMIState:14.7 endBMI:18.5  fatBMI:21.1 bmi:bmiDouble name:name];
            case 8:
                return [ToolsHelper getBMIState:15.0 endBMI:19.2  fatBMI:21.9 bmi:bmiDouble name:name];
            case 9:
                return [ToolsHelper getBMIState:15.2 endBMI:19.6  fatBMI:22.4 bmi:bmiDouble name:name];
            case 10:
                return [ToolsHelper getBMIState:15.4 endBMI:20.2  fatBMI:22.8 bmi:bmiDouble name:name];
            case 11:
                return [ToolsHelper getBMIState:15.8 endBMI:20.9  fatBMI:23.4 bmi:bmiDouble name:name];
            case 12:
                return [ToolsHelper getBMIState:16.4 endBMI:21.4  fatBMI:24.1 bmi:bmiDouble name:name];
            case 13:
                return [ToolsHelper getBMIState:17.0 endBMI:22.1  fatBMI:24.7 bmi:bmiDouble name:name];
            case 14:
                return [ToolsHelper getBMIState:17.6 endBMI:22.6  fatBMI:25.1 bmi:bmiDouble name:name];
            case 15:
                return [ToolsHelper getBMIState:18.2 endBMI:23.0  fatBMI:25.4 bmi:bmiDouble name:name];
            case 16:
                return [ToolsHelper getBMIState:18.6 endBMI:23.3  fatBMI:25.5 bmi:bmiDouble name:name];
            case 17:
                return [ToolsHelper getBMIState:19.0 endBMI:23.5  fatBMI:25.5 bmi:bmiDouble name:name];
            case 18:
                return [ToolsHelper getBMIState:19.2 endBMI:23.6  fatBMI:25.5 bmi:bmiDouble name:name];
            default:
                return [ToolsHelper getBMIState:18.5 endBMI:23.9  fatBMI:27.9 bmi:bmiDouble name:name];
                
        }
        
        
    }else{//女人
        
        switch (ageInt) {
            case 0:
                return [ToolsHelper getBMIState:14.9 endBMI:17.2  fatBMI:18.2 bmi:bmiDouble name:name];
            case 1:
                return [ToolsHelper getBMIState:14.9 endBMI:17.2  fatBMI:18.2 bmi:bmiDouble name:name];
            case 2:
                return [ToolsHelper getBMIState:14.9 endBMI:17.2  fatBMI:18.2 bmi:bmiDouble name:name];
            case 3:
                return [ToolsHelper getBMIState:14.5 endBMI:17.1  fatBMI:18.4 bmi:bmiDouble name:name];
            case 4:
                return [ToolsHelper getBMIState:14.2 endBMI:17.0  fatBMI:18.5 bmi:bmiDouble name:name];
            case 5:
                return [ToolsHelper getBMIState:13.9 endBMI:17.0  fatBMI:18.8 bmi:bmiDouble name:name];
            case 6:
                return [ToolsHelper getBMIState:13.6 endBMI:17.1  fatBMI:19.0 bmi:bmiDouble name:name];
            case 7:
                return [ToolsHelper getBMIState:14.4 endBMI:17.9  fatBMI:20.2 bmi:bmiDouble name:name];
            case 8:
                return [ToolsHelper getBMIState:14.6 endBMI:18.7  fatBMI:20.9 bmi:bmiDouble name:name];
            case 9:
                return [ToolsHelper getBMIState:14.9 endBMI:19.2 fatBMI:21.5 bmi:bmiDouble name:name];
            case 10:
                return [ToolsHelper getBMIState:15.2 endBMI:20.0  fatBMI:22.2 bmi:bmiDouble name:name];
            case 11:
                return [ToolsHelper getBMIState:15.8 endBMI:20.8  fatBMI:23.0 bmi:bmiDouble name:name];
            case 12:
                return [ToolsHelper getBMIState:16.4 endBMI:21.5  fatBMI:23.8 bmi:bmiDouble name:name];
            case 13:
                return [ToolsHelper getBMIState:17.0 endBMI:22.1  fatBMI:24.5 bmi:bmiDouble name:name];
            case 14:
                return [ToolsHelper getBMIState:17.6 endBMI:22.6  fatBMI:25.0 bmi:bmiDouble name:name];
            case 15:
                return [ToolsHelper getBMIState:18.0 endBMI:22.6  fatBMI:25.2 bmi:bmiDouble name:name];
            case 16:
                return [ToolsHelper getBMIState:18.2 endBMI:22.6  fatBMI:25.2 bmi:bmiDouble name:name];
            case 17:
                return [ToolsHelper getBMIState:18.3 endBMI:22.6  fatBMI:25.2 bmi:bmiDouble name:name];
            case 18:
                return [ToolsHelper getBMIState:18.3 endBMI:22.6  fatBMI:25.2 bmi:bmiDouble name:name];
            default:
                return [ToolsHelper getBMIState:18.5 endBMI:23.9  fatBMI:27.9 bmi:bmiDouble name:name];
                
        }
    }

}

+(NSDictionary *) getBMIState:(double)start endBMI:(double)endBMI fatBMI:(double)fatBMI bmi:(double)bmi name:(NSString *)name{
    
    NSInteger typeSate =0; //不正常
    double base =endBMI;
    NSString *text =@"";
    NSString *titleStr =@"";
    
    if (bmi<start) {//偏瘦
        typeSate =0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的BMI值处于偏瘦状态\n需加强孩子的营养补充,让孩子保持良好心态",name];
        titleStr =@"偏瘦";
        
    }else if (bmi>=start && bmi<=endBMI){//正常
        typeSate =1;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的BMI值处于正常状态\n继续保持",name];
        titleStr =@"正常";
    
    }else if (bmi>=endBMI && bmi<=fatBMI){//偏胖
        typeSate =0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的BMI值处于偏胖状态\n需控制孩子的营养补充，多多锻炼",name];
        titleStr =@"偏胖";
    
    }else{//肥胖
        typeSate =0;
        text = [NSString stringWithFormat:@"与同龄孩子相比\n%@的BMI值处于肥胖状态\n建议进行相关检查，查明原因",name];
        titleStr =@"肥胖";
    
    }
    
    
    return @{@"typeState":[NSNumber numberWithInteger:typeSate],@"base":[NSNumber numberWithInteger:base],@"text":text,@"titleStr":titleStr};
    
}



/**
 * 根据"2016-11-11 15:57:10" 获取 月.日
 * 返回 月.日
 */
+ (NSString *)getMonthAndDay:(NSString *)dateStr{

    NSString *monthStr =[NSString new];
    NSString *dayStr =[NSString new];
    
    NSString *dateSStr =[NSString stringWithFormat:@"%@",dateStr];
    
    NSArray *dateArr =[dateSStr componentsSeparatedByString:@"-"];
    if (dateArr.count>2) {
        monthStr =dateArr[1];
        NSArray *dayArr =[dateArr[2] componentsSeparatedByString:@" "];
        dayStr =dayArr[0];
    }
    
    
    return [NSString stringWithFormat:@"%@.%@",monthStr,dayStr];

    
    
}


/**
 根据时间字符串返回年

 @param dateStr 时间字符串

 @return 年
 */
+ (NSString *)getYear:(NSString *)dateStr{

    NSString *yearStr =[NSString new];
    NSString *dateSStr =[NSString stringWithFormat:@"%@",dateStr];
    
    NSArray *dateArr =[dateSStr componentsSeparatedByString:@"-"];
    
    if (dateArr.count>2) {
        yearStr =dateArr[0];
    }
    
    
    return yearStr;
    
}

/**
 根据时间字符串返回月
 
 @param dateStr 时间字符串
 
 @return 月
 */
+ (NSString *)getMonth:(NSString *)dateStr{
    
    NSString *monthStr =[NSString new];
    NSString *dateSStr =[NSString stringWithFormat:@"%@",dateStr];
    
    NSArray *dateArr =[dateSStr componentsSeparatedByString:@"-"];
    
    if (dateArr.count>2) {
        monthStr =dateArr[1];
    }
    
    
    return monthStr;
    
}

/**
 根据时间字符串返回日
 
 @param dateStr 时间字符串
 
 @return 日
 */
+ (NSString *)getDay:(NSString *)dateStr{
    
    NSString *dayStr =[NSString new];
    NSString *dateSStr =[NSString stringWithFormat:@"%@",dateStr];
    
    NSArray *dateArr =[dateSStr componentsSeparatedByString:@"-"];
    
    if (dateArr.count>2) {
        NSArray *dayArr =[dateArr[2] componentsSeparatedByString:@" "];
        dayStr =dayArr[0];
    }
    
    
    return dayStr;
    
}

/**
 根据时间字符串返回时、分
 
 @param dateStr 时间字符串
 
 @return 时、分
 */
+ (NSString *)getTimeHAndM:(NSString *)dateStr{
    
    NSString *timeStr =[NSString new];
    NSString *dateSStr =[NSString stringWithFormat:@"%@",dateStr];
    
    NSArray *dateArr =[dateSStr componentsSeparatedByString:@"-"];
    
    if (dateArr.count>2) {
        NSArray *dayArr =[dateArr[2] componentsSeparatedByString:@" "];
        timeStr =dayArr[1];
        
        
    }
    
    NSArray *timeArr =[timeStr componentsSeparatedByString:@":"];
    
    if (timeArr.count>1) {
        
        return [NSString stringWithFormat:@"%@:%@",timeArr[0],timeArr[1]];
        
    }else{
     
        return [NSString stringWithFormat:@"%@",timeArr[0]];
        
    }
    
    
    
}

/**
 * 根据时间Date返回字符串
 */
+ (NSString*)dateTodateString:(NSDate *)_date{
    
    NSDate *date =_date;
    
    NSTimeZone *timeZone =[NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    ;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [dateFormatter setTimeZone:timeZone];
    
    NSString *fixString = [NSString new];
    fixString=[dateFormatter stringFromDate:date];
    
    return fixString;

}


/**
 根据时间字符串返回当前时间

 
 @return 当前时间
 */
+ (NSString *)getCurrentTime{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return currentDate;
    
}

#pragma mark - 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text
{
    __block BOOL isEomji = NO;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}


/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */

/**
 *  截图
 *
 *  @param theView 所截图像所在view
 *  @param r       截图范围
 *
 *  @return 所得图片
 */
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r
{
    CGSize size0 = {theView.frame.size.width,theView.size.height};
    UIGraphicsBeginImageContext(size0); //获取上下文大小，也是获取图像大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //UIRectClip(r);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(theImage.size));
    
    CGSize size1 = CGSizeMake(kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContext(size1);
    CGRect rect = {{0,0}, size1};
    [theImage drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(compressedImg.size));
    
    
    
    
    
    
    return compressedImg;
    
    
    
}


//压缩图片（等比例)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImage *)cutImage:(UIImage*)image withSize:(CGSize)size
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (size.width / size.height))
    {
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * size.height / size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else
    {
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * size.width / size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

+ (NSString *)jcFormatLikeCount:(NSString *)sourceString
{
    NSString * jcStr = nil;
    NSInteger jcInt = [sourceString integerValue];
    
    if (jcInt>=0&&jcInt<=9999)
    {
        jcStr = sourceString;
    }
    else if (jcInt>=10000&&jcInt<=999999)
    {
        jcStr = [NSString stringWithFormat:@"%.1f万",[sourceString floatValue]/10000];
    }
    else
    {
        jcStr = [NSString stringWithFormat:@"%ld万",jcInt/10000];
    }
    return jcStr;
}
//将原始格式的时间字符串转为目标格式的时间字符串
+(NSString *)jcFormateDatefromDateStr:(NSString *)dateStr  withSourceFormate:(NSString *)source withTargetFromate:(NSString *)target
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (source.length==0||source == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [dateFormatter setDateFormat:source];
    }
    NSDate *jcdate=[dateFormatter dateFromString:dateStr];
    NSString * jcFinishDate = nil;
    [dateFormatter setDateFormat:target];
    jcFinishDate = [dateFormatter stringFromDate:jcdate];
    return jcFinishDate;

}
//此段代码可以获取本地异常日志
+ (NSString *)jcGetUncaughtException
{
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Log"];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    NSString * jcContent = [NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    
    return jcContent;

}
+ (NSString *)jcGetUncaughtExceptionPath
{
   
    NSString *logDirectory = @"Log";
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    return logFilePath;
}
+ (NSString *)jcGetLogPath
{
    NSString *logDirectory = @"Log";
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"CanCan.log"];
    return logFilePath;

}


+ (NSInteger)ageWithDateOfBirth:(NSString *)date
{
    NSString *str=date;
    
    // 出生日期转换 年月日
    
    NSInteger brithDateYear  = [[str substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSInteger brithDateMonth = [[str substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger brithDateDay   = [[str substringWithRange:NSMakeRange(6, 2)] integerValue];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}
//计算文字宽度和高度
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    
    CGSize maxSize=CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

/**
 根据百分比获取好姿态标语及描述语
 
 @param percentage 姿态百分比
 @param typeStr 100 表示获取好姿态标语 101表示获取好姿态描述语
 @param arr 百分比集合
 @param uppercentage 上个百分比
 @param coverIndx 表示选中区域
 @return 返回对应的标语或者描述语
 */

+(NSString *)getGoodPostureTipAndDescribe:(NSString *)percentage withType:(NSString *)typeStr percentArr:(NSMutableArray *)arr upPercent:(NSString *)uppercentage coverIndx:(NSInteger)coverIndx{
    
    double percentD =[percentage doubleValue];
    double upPercentD =[uppercentage doubleValue];

    if ([typeStr isEqualToString:@"100"]) {//表示好姿态标语类型
        
        if (percentD<0.222) {
            
            return @"日常习惯不良，姿态问题严重";
            
        }else if (percentD>=0.222 && percentD<0.444){
            
            return @"姿态问题有些明显";
        
        }else if (percentD>=0.444 && percentD<0.667){
            
            return @"还不错，但稍有些低头含胸";
        
        }else{
            
            return @"姿态端正，真棒！";
        
        }
        
    }else if ([typeStr isEqualToString:@"101"]){//表示好姿态描述语类型
        
        if (percentD>=0.667) {
            
            return @"孩子姿态保持的真棒，继续坚持！";
            
        }else{
            
            if (arr.count>0) {
                
                if (arr.count==1) {
                    
                   return percentD ==0?@"未采集到好姿态数据":@"孩子可能有驼背的征兆，为了孩子的健康发育，建议进行驼背矫正训练";
                    
                }else{
                    
                    if (coverIndx!=0) {
                        
                        if (percentD>upPercentD) {
                            
                            return percentD ==0?@"未采集到好姿态数据":@"孩子的好姿态进步了，但还存在驼背征兆，建议继续进行驼背矫正训练";
                            
                        }else{
                            
                            return percentD ==0?@"未采集到好姿态数据":@"孩子的好姿态退步了，为防止驼背愈加严重，建议进行驼背矫正训练";
                            
                        }
                        
                    }else{
                        
                        return percentD ==0?@"未采集到好姿态数据":@"孩子可能有驼背的征兆，为了孩子的健康发育，建议进行驼背矫正训练";
                    
                    }
                    
                
                }
                
            }else{
            
                return @"未采集到好姿态数据";
                
            }
        
        }
        
            
    }else{
    
        return @"未采集到好姿态数据";
        
    }
    
}
/**
 根据年龄步数性别来获取步数的百分比，以及运动步数的描述语
 
 @param age 年龄
 @param theyCount 步数
 @param gender 0男  1女
 @param type 100 表示获取百分比 101表示获取步数描述语
 @return 返回对应的百分比或者描述语
 */
+(id)jcGetTheyCountDescribeAndPercentWithAge:(NSInteger)age withTheyCount:(NSInteger)theyCount withGender:(NSInteger)gender withType:(NSInteger)type
{
    NSString * jcValue;
    CGFloat jcPercent = 0.0;
    NSString *jcDescri;
    NSInteger maxTheyCount = 0;
    
    //先判断是男还是女，再判断类型
    if (gender == 0)//男
    {
        if (age<6)
        {
            if (theyCount>=0&&theyCount<3500) {
                
                jcPercent = theyCount/3500.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 3500;
            }
            else if (theyCount>=3500&&theyCount<5000)
            {
                jcPercent = ((theyCount-3500.0)/(5000-3500))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 5000;
            }
            else if (theyCount>=5000&&theyCount<8000)
            {
                jcPercent =((theyCount-5000.0)/(8000-5000))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 8000;
            }
            else if (theyCount>=8000&&theyCount<15000)
            {
                jcPercent = ((theyCount-8000.0)/(15000-8000))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
                
            }
        }
        else if (age>=6&&age<=12)
        {
            if (theyCount>=0&&theyCount<4653) {
                
                jcPercent = theyCount/4653.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 4653;
            }
            else if (theyCount>=4653&&theyCount<7599)
            {
                jcPercent = ((theyCount-4653.0)/(7599-4653))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 7599;
                
            }
            else if (theyCount>=7599&&theyCount<10099)
            {
                jcPercent =((theyCount-7599.0)/(10099-7599))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 10099;
            }
            else if (theyCount>=10099&&theyCount<18000)
            {
                jcPercent = ((theyCount-10099.0)/(18000-10099))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 18000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 18000;
            }

        }
        else if (age>12)
        {
            if (theyCount>=0&&theyCount<4653) {
                
                jcPercent = theyCount/4653.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 4653;
            }
            else if (theyCount>=4653&&theyCount<6099)
            {
                jcPercent = ((theyCount-4653.0)/(6099-4653))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 6099;
                
            }
            else if (theyCount>=6099&&theyCount<9099)
            {
                jcPercent =((theyCount-6099.0)/(9099-6099))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 9099;
            }
            else if (theyCount>=9099&&theyCount<20000)
            {
                jcPercent = ((theyCount-9099.0)/(20000-9099))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 20000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 20000;
            }

        }
        
        if (type == 100) {//获取返回的百分比
            
            jcValue = [NSString stringWithFormat:@"%f",jcPercent];
        }
        else if (type==101)//获取描述语
        {
            jcValue = jcDescri;
        }
        else if(type == 102)//返回区间最大值
        {
            jcValue = [NSString stringWithFormat:@"%ld",maxTheyCount];
        }
    }
    else if(gender == 1)//女
    {
        if (age<6)
        {
            
            if (theyCount>=0&&theyCount<3500) {
                
                jcPercent = theyCount/3500.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 3500;
            }
            else if (theyCount>=3500&&theyCount<5000)
            {
                jcPercent = ((theyCount-3500.0)/(5000-3500))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 5000;
            }
            else if (theyCount>=5000&&theyCount<8000)
            {
                jcPercent =((theyCount-5000.0)/(8000-5000))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 8000;
            }
            else if (theyCount>=8000&&theyCount<15000)
            {
                jcPercent = ((theyCount-8000.0)/(15000-8000))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
            }

        }
        else if (age>=6&&age<=12)
        {
            if (theyCount>=0&&theyCount<4653) {
                
                jcPercent = theyCount/4653.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 4653;
            }
            else if (theyCount>=4653&&theyCount<6599)
            {
                jcPercent = ((theyCount-4653.0)/(6599-4653))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 6599;
            }
            else if (theyCount>=6599&&theyCount<9099)
            {
                jcPercent =((theyCount-6599.0)/(9099-6599))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 9099;
            }
            else if (theyCount>=9099&&theyCount<15000)
            {
                jcPercent = ((theyCount-9099.0)/(15000-9099))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 15000;
            }

        }
        else if (age>12)
        {
            if (theyCount>=0&&theyCount<4653) {
                
                jcPercent = theyCount/4653.0*0.25;
                jcDescri = theyCountDes1;
                maxTheyCount = 4653;
            }
            else if (theyCount>=4653&&theyCount<6099)
            {
                jcPercent = ((theyCount-4653.0)/(6099-4653))*0.25+0.25;
                jcDescri = theyCountDes2;
                maxTheyCount = 6099;
            }
            else if (theyCount>=6099&&theyCount<8099)
            {
                jcPercent =((theyCount-6099.0)/(8099-6099))*0.25+0.5;
                jcDescri = theyCountDes3;
                maxTheyCount = 8099;
            }
            else if (theyCount>=8099&&theyCount<18000)
            {
                jcPercent = ((theyCount-8099.0)/(18000-8099))*0.25+0.75;
                jcDescri = theyCountDes4;
                maxTheyCount = 18000;
            }
            else
            {
                jcPercent = 1.0;
                jcDescri = theyCountDes4;
                maxTheyCount = 18000;
            }

        }

        if (type == 100) {//获取返回的百分比
            
            jcValue = [NSString stringWithFormat:@"%f",jcPercent];
        }
        else if (type==101)//获取描述语
        {
            jcValue = jcDescri;
        }
        else if(type == 102)//返回区间最大值
        {
            jcValue = [NSString stringWithFormat:@"%ld",maxTheyCount];
        }

    }
    return jcValue;
}

/**
 根据消耗卡路里来返回描述语言
 
 @param kaluLi 消耗卡路里数
 @return 返回对应的描述语
 */
+(NSString *)jcGetKaluliDesc:(NSInteger)kaluLi
{
    NSString * jcDesc;
    if (kaluLi>0&&kaluLi<=80) {
        
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡≈2颗奶糖",kaluLi];
        
    }
    else if (kaluLi>80&&kaluLi<=200)
    {
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡≈1盒冰淇淋",kaluLi];
    }
    else if (kaluLi>200&&kaluLi<=300)
    {
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡≈1盒薯条",kaluLi];
    }
    else if (kaluLi>300&&kaluLi<=400)
    {
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡≈1个鸡腿汉堡",kaluLi];
    }
    else if (kaluLi>400)
    {
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡≈1块奶油蛋糕",kaluLi];
    }
    else
    {
        jcDesc = [NSString stringWithFormat:@"消耗%ld千卡",kaluLi];
    }


    return jcDesc;
}
/**
 根据行走步数来计算卡路里
 @param theyCount 行走步数
 @param height    身高/m
 @param weigth    体重/kg
 @return 返回消耗的卡路里(千卡)
 */
//卡路里算法 能耗=身高（m）x 体重(kg)x0.3241x步数/1000
+(NSInteger)jcGetKaluliValueWithTheyCount:(NSInteger)theyCount withHeight:(NSInteger)height withWeigth:(CGFloat)weigth
{
    
    NSInteger kaluliValue = 0;
    kaluliValue = height *weigth*0.3241*theyCount/1000;
    return (NSInteger)kaluliValue;

    
}

/**
 根据年龄性别来获取该年龄段最大步数
 
 @param age 年龄

 @param gender 0男  1女
  @return 返回对应的步数
 */
+(NSInteger)jcGetTheyCountDescribeAndPercentWithAge:(NSInteger)age withGender:(NSInteger)gender {
    
    NSInteger maxTheyCount = 0;
    
    //先判断是男还是女，再判断类型
    if (gender == 0)//男
    {
        if (age<6)
        {
     
                maxTheyCount = 15000;
                
           
        }

        else if (age>=6&&age<=12)
        {
                maxTheyCount = 18000;
            
        }
        else if (age>12)
        {
                maxTheyCount = 20000;
            
        }
        
          }
    else if(gender == 1)//女
    {
        if (age<6)
        {
                maxTheyCount = 15000;

            
        }
        else if (age>=6&&age<=12)
        {
          
                maxTheyCount = 15000;
            
        }
        else if (age>12)
        {
                maxTheyCount = 18000;
            
        }
        
        
    }
    return maxTheyCount;
}

/**
 * 根据字符串转换为日期
 * 返回为NSDate
 */
+ (NSDate *)getDateString:(NSString *)dateStr{

    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",[formatter dateFromString:dateStr]);
    NSDate *date=[formatter dateFromString:dateStr];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    
    return localeDate;
    
}

//时间转换成时间戳(有问题：时间转换为时间戳后再转换为时间多了8个小时)
+(NSString *)dateChangeToTimestamp:(NSDate *)date{
    
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
}

//时间戳转换成时间字符串
+(NSString *)timestampChangeToDate:(NSInteger)_time{
    
    NSTimeInterval time=_time;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *dateStr = [dateFormatter stringFromDate: detaildate];
    
    
    return dateStr;
    
}
//根据状态，来获取运动量描述语言
+(NSString *)jcGetActionDescWithStatus:(NSString *)status
{
    NSString *jcDesc;
    if ([status isEqualToString:@"活动充足"]) {
        
        jcDesc = @"孩子今天真棒，运动量很充足，要注意放松和休息";
    }
    else if ([status isEqualToString:@"活动适中"])
    {
        jcDesc = @"孩子今天的活动量还不错，可以适度增加训练";
    }
    else if ([status isEqualToString:@"静坐少动"])
    {
        jcDesc = @"孩子今天运动太少了，快来锻炼身体吧！";
    }
    return jcDesc;
}

/*
 @param  data      mac的16进制地址，NSData类型
 @return NSString  从data转换而成的mac地址
 */
+ (NSString *)convertToBleMacAddressStringWithNSData:(NSData *)data
{
    if (data.length!=8) {
        return @"";
    }
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    
    const unsigned char *szBuffer = [data bytes];
    
    for (NSInteger i=0; i < [data length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    NSString * jcStr = strTemp;
    jcStr = [jcStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * mac = [jcStr substringWithRange:NSMakeRange(4, jcStr.length-4)];
    NSLog(@"截取完成之后的mac地址:%@",mac);
    NSMutableString *macString = [[NSMutableString alloc] init];
    [macString appendString:[[mac substringWithRange:NSMakeRange(10, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[mac substringWithRange:NSMakeRange(8, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[mac substringWithRange:NSMakeRange(6, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[mac substringWithRange:NSMakeRange(4, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[mac substringWithRange:NSMakeRange(2, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[mac substringWithRange:NSMakeRange(0, 2)] uppercaseString]];
    NSLog(@"解析完成之后%@",macString);
    return macString;

}

/*
 
 @param  type  枚举类型，年月日时分秒
 @desc   根据所传输的枚举类型，获取当天的年月日时分秒
 */
+ (NSString *)jcGetTodayDateByType:(JCGETDATE)type
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |                 NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    NSString  *result;
    switch (type) {
        case JCGETDATEYear:
        {
             result = [NSString stringWithFormat:@"%ld",year];
            break;
        }
        case JCGETDATEMonth:
        {
             result = [NSString stringWithFormat:@"%ld",month];
            break;
        }
        case JCGETDATEDay:
        {
             result = [NSString stringWithFormat:@"%ld",day];
            break;
        }
        case JCGETDATEHour:
        {
             result = [NSString stringWithFormat:@"%ld",hour];
            break;
        }
        case JCGETDATEMinute:
        {
             result = [NSString stringWithFormat:@"%ld",minute];
            break;
        }
        case JCGETDATESecond:
        {
             result = [NSString stringWithFormat:@"%ld",second];
            break;
        }
        default:
            break;
    }
    
    return result;
}

/*
 @param dateStr   原始日期字符串
 @param type      枚举类型，年月日时分秒
 @desc            根据传输的枚举类型，解析原始日期字符串，获取对应的年月日时分秒
 */
+ (NSString *)jcGetHistoryDateByStr:(NSString *)dateStr withType:(JCGETDATE)type
{
    NSString * result;
    if (dateStr.length!=0) {
        
        NSArray *dateArr = [dateStr componentsSeparatedByString:@" "];
        if (dateArr.count == 2) {
            NSString *t1 = dateArr[0];
            NSString *t2 = dateArr[1];
            NSArray *t1Arr = [t1 componentsSeparatedByString:@"-"];
            NSArray *t2Arr = [t2 componentsSeparatedByString:@":"];
            if (t1Arr.count == 3&&t2Arr.count == 3) {
                
                NSString  *year  = t1Arr[0];
                NSString  *month = t1Arr[1];
                NSString  *day   = t1Arr[2];
                NSString  *hour  = t2Arr[0];
                NSString  *minute = t2Arr[1];
                NSString  *second = t2Arr[2];
                
                switch (type) {
                    case JCGETDATEYear:
                    {
                        result = [NSString stringWithFormat:@"%@",year];
                        break;
                    }
                    case JCGETDATEMonth:
                    {
                        result = [NSString stringWithFormat:@"%@",month];
                        break;
                    }
                    case JCGETDATEDay:
                    {
                        result = [NSString stringWithFormat:@"%@",day];
                        break;
                    }
                    case JCGETDATEHour:
                    {
                        result = [NSString stringWithFormat:@"%@",hour];
                        break;
                    }
                    case JCGETDATEMinute:
                    {
                        result = [NSString stringWithFormat:@"%@",minute];
                        break;
                    }
                    case JCGETDATESecond:
                    {
                        result = [NSString stringWithFormat:@"%@",second];
                        break;
                    }
                        
                    default:
                        break;
                }
                return result;
            }
            else
            {
                return nil;
            }
            
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
}

//根据徽章级别，获取徽章分享的图片
+(NSString *)jcGetShareBadgeImgWithMedalLevel:(NSInteger)level
{
    NSArray *imgArr = @[@"JCDYN_level1.png",@"JCDYN_level2.png",@"JCDYN_level3.png",@"JCDYN_level4.png",@"JCDYN_level5.png",@"JCDYN_level6.png",@"JCDYN_level7.png",@"JCDYN_level8.png",@"JCDYN_level9.png",@"JCDYN_level10.png"];
    NSString *jcStr;
    if (level<imgArr.count) {
        jcStr = imgArr[level];
    }
    else
    {
        jcStr = nil;
    }
    return jcStr;
}
@end
