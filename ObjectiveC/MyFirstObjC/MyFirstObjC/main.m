//
//  main.m
//  MyFirstObjC
//
//  Created by Kim Dong-woo on 2016. 12. 20..
//  Copyright © 2016년 Kim Dong-woo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "Square.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
    
        Rectangle2* rc2  = [[Rectangle2 alloc] init];
        rc2.nHeight = 100;
        rc2.nWidth = 100;
       
        [rc2 PrintSize];
        
        
        
    }
    return 0;
}
