//
//  TestFetchRequests.m
//  CoreDataOptimizationExample
//
//  Created by Zack Liston on 1/13/15.
//  Copyright (c) 2015 Zack Liston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "Student.h"
#import "Course.h"
#import "Professor.h"

@interface TestFetchRequests : XCTestCase

@end

@implementation TestFetchRequests

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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY students.grade > 90.0"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[alphaSort]];
    
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 2);
    
    Course *firstCourse = [results firstObject];
    Course *secondCourse = [results objectAtIndex:1];
    
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
    XCTAssertTrue([secondCourse.name isEqualToString:@"CompSci-101"]);
}

- (void)testNONEOperator
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NONE students.grade < 60.0"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[alphaSort]];
    
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 1);
    
    Course *firstCourse = [results firstObject];
    
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
}

- (void)testALLOperator
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ALL students.grade >= 60.0"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[alphaSort]];
    
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 1);
    
    Course *firstCourse = [results firstObject];
    
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
}

- (void)testMultipleConditionSubquery
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SUBQUERY(students, $student, $student.grade >= 90.0 && $student.year == 'senior').@count >0"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[alphaSort]];
    
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 2);
    
    Course *firstCourse = [results firstObject];
    Course *secondCourse = [results objectAtIndex:1];
    
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
    XCTAssertTrue([secondCourse.name isEqualToString:@"CompSci-101"]);
}

- (void)testNestedSubquery
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SUBQUERY(students, $student, SUBQUERY($student.previousCourses, $course, $course.name == 'CompSci-101').@count >0).@count >0"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[alphaSort]];
    
    [request setRelationshipKeyPathsForPrefetching:@[@"students"]];
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 1);
    
    Course *firstCourse = [results firstObject];
    
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
}

- (void)testAverageCollectionOperator
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"students.@avg.grade >= 80"];
    [request setPredicate:predicate];
    
    
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    XCTAssertNil(fetchError);
    
    XCTAssertEqual(results.count, 1);
    
    Course *firstCourse = [results firstObject];
    XCTAssertTrue([firstCourse.name isEqualToString:@"Art"]);
}


- (void)loadDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        Student *aStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        aStudent.name = @"A-studentSenior";
        aStudent.grade = [NSNumber numberWithDouble:93.0];
        aStudent.year = @"senior";
        
        Student *aStudent2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        aStudent2.name = @"A-StudentFreshman";
        aStudent2.grade = [NSNumber numberWithDouble:99.2];
        aStudent2.year = @"freshman";
    
        Student *cStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        cStudent.name = @"C-Student";
        cStudent.grade = [NSNumber numberWithDouble:75.3];
        cStudent.year = @"junior";
        
        Student *failingStudent1 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        failingStudent1.name = @"F-Student1";
        failingStudent1.grade = [NSNumber numberWithDouble:54.0];
        failingStudent1.year = @"freshman";
        
        Student *failingStudent2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        failingStudent2.name = @"F-Student2";
        failingStudent2.grade = [NSNumber numberWithDouble:43.0];
        failingStudent2.year = @"junior";
        
        Course *compSci = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        compSci.name = @"CompSci-101";
        [compSci addStudentsObject:aStudent];
        [compSci addStudentsObject:cStudent];
        [compSci addStudentsObject:failingStudent1];
        [aStudent2 addPreviousCoursesObject:compSci];
        
        Course *art = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        art.name = @"Art";
        [art addStudentsObject:aStudent];
        [art addStudentsObject:aStudent2];
        [art addStudentsObject:cStudent];
        
        Course *reallyHardCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        reallyHardCourse.name = @"CompSci-521";
        [reallyHardCourse addStudentsObject:failingStudent1];
        [reallyHardCourse addStudentsObject:failingStudent2];
        
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
