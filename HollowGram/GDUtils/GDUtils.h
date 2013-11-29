//
//  HTUtils.h
//  HT
//
//  Created by Gia on 1/10/13.
//  Copyright (c) 2013 LibiStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef GD_DebugMacro_h
#define GD_DebugMacro_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

extern CGRect CGRectSetX(CGRect rect, CGFloat x);
extern CGRect CGRectSetY(CGRect rect, CGFloat y);
extern CGRect CGRectSetWidth(CGRect rect, CGFloat width);
extern CGRect CGRectSetHeight(CGRect rect, CGFloat height);
extern CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectSetSize(CGRect rect, CGSize size);
extern CGRect CGRectSetZeroOrigin(CGRect rect);
extern CGRect CGRectSetZeroSize(CGRect rect);
extern CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect CGRectAddPoint(CGRect rect, CGPoint point);
extern CGPoint CGPointSetX(CGPoint point, CGFloat x);
extern CGPoint CGPointSetY(CGPoint point, CGFloat y);

typedef enum {
    GDUIUtilsRoundCornersPositionAll = 0,
    GDUIUtilsRoundCornersPositionOnlyTop = 1,
    GDUIUtilsRoundCornersPositionOnlyBottom = 2,
    GDUIUtilsRoundCornersPositionOnlyLeft = 3,
    GDUIUtilsRoundCornersPositionOnlyRight = 4
}GDUIUtilsRoundCornersPosition;


@interface GDUtils : NSObject

+ (id) loadNIB:(NSString*)file;
+ (NSComparisonResult)compareVersionString:(NSString *)versionString1 withVersionString:(NSString *)versionString2;
+ (UIColor *)colorWithHexString:(NSString *)string;
+ (NSString *)hexadecimalStringFromData:(NSData *)data;

+ (NSString *)writePNGImageToDocumentFolder:(UIImage *)image name:(NSString *)name;

+ (NSString *)pathToFileInDocumentFolder:(NSString *)fileName;
+ (NSString *)writeImageToDocumentFolder:(UIImage *)image;
+ (NSString *)writeImageToDocumentFolder:(UIImage *)image name:(NSString *)name;

+ (NSString *)writeImageToDocumentFolder:(UIImage *)image name:(NSString *)name type:(NSString *)type;
+ (NSString *) randomString: (int) len ;

+ (NSString *)filePathInDocumentFolder:(NSString *)fileName;
+ (NSError *)errorWithDescription:(NSString *)description;

+ (double)milesFromMeters:(double)meters;
+ (double)metersFromMiles:(double)miles;

+ (void)openURLStringInSafariApp:(NSString *)urlString;

+ (UITextField *)textField:(UITextField *)textField withPaddingLeft:(CGFloat)paddingLeft;


+ (UIImage *)darkenImage:(UIImage *)image toLevel:(CGFloat)level;
+ (void)showIndicatorImage:(UIImage *)image
                    inView:(UIView *)view
                   timeout:(float)timeout;
+ (UIView *)roundCornerForView:(UIView *)view
                    atPosition:(GDUIUtilsRoundCornersPosition)position
                        radius:(CGFloat)radius;
+ (UIView *)roundCorner:(float)radius forView:(UIView *)view backgroundColor:(UIColor *)color;
+(UIImageView *)roundedCornersForImageView:(UIImageView*)imgV
                                    radius:(float)cornerRadius
                               borderColor:(UIColor *)borderColor
                             andBorderWith:(float)borderWidth;
+ (void)showErrorAlert:(NSString *)title description:(NSString *)description;
+ (NSError *)errorWithDescription:(NSString *)description domain:(NSString *)domain;

+ (UIImage *)imageForView:(UIView *)view rect:(CGRect)rect;
+ (UIImage *)rotate90DegreeImage:(UIImage *)image multiply:(int)multiply;

+ (CGRect)frameForView:(UIView *)view underView:(UIView *)aboveView;
+ (UIView *)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

+ (CGRect)frameForSuperView:(UIView *)view contentView:(UIView *)contentView insets:(UIEdgeInsets)insets;

+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates inView:(UIView *)view;

+ (CGRect)frameForContentView:(UIView *)contentView insets:(UIEdgeInsets)insets;

+ (void)makeView:(UIView *)view leverageWithView:(UIView *)destinationView;

+ (void)setFrameForView:(UIView *)contentView superView:(UIView *)superView insets:(UIEdgeInsets)insets;

+ (UILabel *)setFrameToFit:(UILabel *)label frame:(CGRect)frame;
+ (UILabel *)setFrameToFit:(UILabel *)label width:(float)width;

+ (UITapGestureRecognizer *)addTapForView:(UIView *)view target:(id)target selector:(SEL)selector;
@end
