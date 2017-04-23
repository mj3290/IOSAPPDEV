//
//  Rectangle.h
//  MyFirstObjC
//
//  Created by Kim Dong-woo on 2016. 12. 20..
//  Copyright © 2016년 Kim Dong-woo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rectangle : NSObject {
    int height, width;
}


-(int)size;
-(void) setWidth:(int) nW;
-(void) setHeight:(int) nH;

-(void) setWidth:(int) nWidth height:(int) height;

-(int)width;
-(int)height;

-(BOOL)isSqure;
@end



@interface Rectangle2 : NSObject

@property  int nWidth;
@property  int nHeight;
@property (readonly) int size;

-(void) PrintSize;

@end
