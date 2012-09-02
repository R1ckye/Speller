//
//  main.m
//  Betűző
//
//  Created by Richard Murvai (Rickye) on 2012.09.01..
//

#import <Foundation/Foundation.h>
#import "stdlib.h"
#import "stdio.h"
#import "time.h"

static NSDictionary *dict;

void setup(NSString *nevekFajl) {
    if (!nevekFajl) {
        nevekFajl = @"./nevek.txt";
    }
    NSString *content = [[NSString alloc]initWithContentsOfFile:nevekFajl encoding:NSUTF8StringEncoding error:nil];
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *sorok = (NSMutableArray *) [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [sorok removeObject:[sorok lastObject]];
    for (NSString *sor in sorok) {
        NSString *elsoBetu = [sor substringWithRange:NSMakeRange(0,1)];
        NSMutableArray *a = [mutDict objectForKey:elsoBetu];
        if (!a) {
            a = [[NSMutableArray alloc]init];
        }
        [a addObject:sor];
        [mutDict setObject:a forKey:elsoBetu];
        //NSString *substr = [sor substringWithRange:NSMakeRange(0,1)];
    }
    dict = mutDict;
}

NSArray* nevekBetuhoz (NSString* betu) {
    betu = [betu capitalizedString];
    return [dict objectForKey:betu];
}

NSString* nevLekero (NSString* betu) {
    NSArray *nevek = nevekBetuhoz(betu);
    if (!nevek) {
        return betu;
    }
    return [nevek objectAtIndex:(rand() % [nevek count])];
    srand(time(NULL));
}

void usage() {
    printf("Használat: Betuzo <Betűzendő szó> [-nevek] [/path/to/name/list]\n");
}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        if (argc > 1) {
            if (argc > 3) {
                setup([NSString stringWithCString:argv[3] encoding:NSUTF8StringEncoding]);
            }
            else {
                setup(nil);
            }
            NSString *szoveg = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            for (int i = 0; i < [szoveg length]; i++)
            {
                NSString *substr = [szoveg substringWithRange:NSMakeRange(i,1)];
                if ([substr isEqualToString:@" "]) {
                    printf("\n");
                }
                else {
                    NSString *nev = nevLekero(substr);
                    if([nev isEqualToString:[substr lowercaseString]] || [nev isEqualToString:[substr capitalizedString]]) {
                        printf("Nincs szó "); printf([substr UTF8String]); printf(" betűvel!\n");
                    }
                    else {
                        printf([nev UTF8String]);
                        printf("\n");
                    }
                }
            } 
        }
        else {
            usage();
            return 1;
        }
    }
    return 0;
}


