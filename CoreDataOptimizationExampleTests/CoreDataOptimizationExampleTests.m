//
//  CoreDataOptimizationExampleTests.m
//  CoreDataOptimizationExampleTests
//
//  Created by Zack Liston on 1/9/15.
//  Copyright (c) 2015 Zack Liston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "Student.h"
#import "Course.h"
#import "Professor.h"

@interface CoreDataOptimizationExampleTests : XCTestCase

@end

@implementation CoreDataOptimizationExampleTests

- (void)setUp {
    [super setUp];
    [self loadDatabase];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testANYOperator
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
}

- (void)testB
{
    XCTAssertFalse(NO);
}

- (void)loadDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        Student *aStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        aStudent.name = @"A-student1";
        aStudent.grade = [NSNumber numberWithDouble:93.0];
        
        Student *aStudent2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        aStudent2.name = @"A-Student2";
        aStudent2.grade = [NSNumber numberWithDouble:99.2];
        
        Student *cStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        cStudent.name = @"C-Student";
        cStudent.grade = [NSNumber numberWithDouble:75.3];
        
        Student *failingStudent1 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        failingStudent1.name = @"F-Student1";
        failingStudent1.grade = [NSNumber numberWithDouble:54.0];
        
        Student *failingStudnet2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        failingStudnet2.name = @"F-Student2";
        failingStudnet2.grade = [NSNumber numberWithDouble:43.0];
        
        Course *compSci = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        compSci.name = @"CompSci-101";
        [compSci addStudentsObject:aStudent];
        [compSci addStudentsObject:cStudent];
        [compSci addStudentsObject:failingStudent1];
        
        Course *art = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        art.name = @"Art";
        [art addStudentsObject:aStudent];
        [art addStudentsObject:aStudent2];
        [art addStudentsObject:cStudent];
        
        Professor *hawkins = [NSEntityDescription insertNewObjectForEntityForName:@"Professor" inManagedObjectContext:context];
        hawkins.name = @"Stephen Hawkins";
        [hawkins addCoursesObject:compSci];
        
        NSError *saveError;
        [context save:&saveError];
        if (saveError) {
            NSLog(@"Error saving context");
        }
    });
}

@end
