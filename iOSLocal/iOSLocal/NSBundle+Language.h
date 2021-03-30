//
//  NSBundle+Language.h
//  iOSLocal
//
//  Created by 李欣欣 on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

+ (NSBundle *)getCurrentBundle;

@end

NS_ASSUME_NONNULL_END
