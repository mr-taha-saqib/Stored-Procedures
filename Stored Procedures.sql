create database l06
use l06

CREATE TABLE Students (
  studentID INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  rollNo VARCHAR(50),
  major VARCHAR(50)
);

-- Create the Courses table
CREATE TABLE Courses (
  courseID INT IDENTITY(1,1) PRIMARY KEY ,
  courseName VARCHAR(50),
  instructor VARCHAR(50),
  department VARCHAR(50),
  creditHour INT
);

-- Create the Enrollments table
CREATE TABLE Enrollments (
  enrollmentID INT IDENTITY(1,1) PRIMARY KEY ,
  studentID INT,
  courseID INT,
  FOREIGN KEY (studentID) REFERENCES Students(studentID),
  FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);

-- Create the Grades table
CREATE TABLE Grades (
  gradeID INT IDENTITY(1,1) PRIMARY KEY ,
  enrollmentID INT,
  grade DECIMAL(4,2),
  FOREIGN KEY (enrollmentID) REFERENCES Enrollments(enrollmentID)
);

-- Inserting records into the Students table
INSERT INTO Students (name, age, rollNo, major) VALUES ('Giselle Collette', 20, 'l201234', 'Computer Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Emily Davis', 22, 'l212342', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Kaeya Alberich', 21, 'l203451', 'Mathematics');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Florence Nightingale', 23, 'l203452', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Waver Velvet', 21, 'l224324', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Benedict Blue', 21, 'l214984', 'Computer Science');

-- Inserting records into the Courses table
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Database Systems', 'Prof. Smith', 'CS', 4);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Web Development', 'Prof. Jonathan', 'CS', 4);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Theory of Automata', 'Prof. Williams', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Machine Learning', 'Prof. Williams', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Discrete Structures', 'Prof. Horace', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Numeric Computing', 'Prof. Sarah', 'MTH', 3);

-- Inserting records into the Enrollments table
INSERT INTO Enrollments (studentID, courseID) VALUES (1, 1);
INSERT INTO Enrollments (studentID, courseID) VALUES (2, 1);
INSERT INTO Enrollments (studentID, courseID) VALUES (2, 2);
INSERT INTO Enrollments (studentID, courseID) VALUES (3, 3);
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 4);
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 3);
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 6);
INSERT INTO Enrollments (studentID, courseID) VALUES (6, 1);

-- Inserting records into the Grades table
INSERT INTO Grades (enrollmentID, grade) VALUES (1, 3.3);
INSERT INTO Grades (enrollmentID, grade) VALUES (2, 2.7);
INSERT INTO Grades (enrollmentID, grade) VALUES (3, 2.3);
INSERT INTO Grades (enrollmentID, grade) VALUES (4, 4);
INSERT INTO Grades (enrollmentID, grade) VALUES (5, 3.3);
INSERT INTO Grades (enrollmentID, grade) VALUES (6, 3.7);
INSERT INTO Grades (enrollmentID, grade) VALUES (7, 3);
INSERT INTO Grades (enrollmentID, grade) VALUES (8, 3.7);


--Q1
create procedure getUnenrolledStudent
as
begin
select * from Students
where StudentID not in(select StudentID from Enrollments)
end
go
execute getUnenrolledStudent
--Q2
create procedure updateStudentAgss
@studentID int,
@newAge int
as
begin
update Students
set age=@newAge
where studentID=@studentID
end
go

execute updateStudentAgss
@studentID=4,
@newAge=50

select* from Students


--Q3
create procedure deletestudents
@studentID int
as
begin
delete from Grades
where enrollmentID in (select enrollmentID from Enrollments where studentID=@studentID)
delete from Enrollments where studentID=@studentID
delete from Students where studentID=@studentID
end
go
execute deletestudents
@studentID=3
select* from Students


--Q4
create procedure getCourseStudents
@courseID int
as
begin
select * from Students s
join Enrollments e on s.studentID =e.studentID
where e.courseID = @courseID

end
go
execute getCourseStudents
@courseID=2

--Q5
create procedure getStudentInfos
@studentID int
as
begin
select * from Students s
left join Enrollments e on s.studentID=e.studentID
left join Courses c on e.courseID = c.courseID
where s.studentID= @studentID

end
go
execute getStudentInfos
@studentID=1

--Q6
create procedure getMostPopularCourses
  @department varchar(50) = 'CS'
AS
begin
  select top 1 c.courseName, c.instructor, COUNT(e.studentID) AS EC
  from Courses c
  LEFT JOIN Enrollments e ON c.courseID = e.courseID
  where c.department = @department
  group BY c.courseID, c.courseName, c.instructor
  order BY EC DESC;
end

execute getMostPopularCourses

--Q7
create procedure calculateCourseGPAs
  @courseID int,
  @averageGPA decimal(4, 2) OUTPUT
as
begin
  select @averageGPA = AVG(g.grade)
  from Grades g
  JOIN Enrollments e on g.enrollmentID = e.enrollmentID
  where e.courseID = @courseID;
end
execute calculateCourseGPAs
@courseID = 1,
@averageGPA OUTPUT;

--Q8
create procedure calculateCourseGPAs
  @courseID int,
  @averageGPA decimal(4, 2) OUTPUT
as
begin
  select @averageGPA = AVG(g.grade)
  from Grades g
  JOIN Enrollments e on g.enrollmentID = e.enrollmentID
  where e.courseID = @courseID;
end
execute calculateCourseGPAs
@courseID = 1,
@averageGPA OUTPUT;

--Q9

create procedure getCourseEnrollmentCounts
as
begin
select count(*) as enrollmentcount
from Enrollments
where CourseID= courseID
end
execute getCourseEnrollmentCounts

--Q10
create procedure getCourseWithoutGrades
AS
begin
  select c.courseName, c.instructor, c.department
  from Courses c
  where c.courseID NOT IN (select distinct e.courseID from Enrollments e)
end

execute getCourseWithoutGrades
