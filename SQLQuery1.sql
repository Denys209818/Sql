CREATE DATABASE Academy

use Academy

CREATE TABLE Departments (
Id int NOT NULL IDENTITY PRIMARY KEY,
Financing money NOT NULL CHECK (Financing >= 0) DEFAULT 0,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE,
FacultyId int NOT NULL FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
)
 
CREATE TABLE Faculties (
Id int NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE
)

CREATE TABLE Groups (
Id int NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(10) NOT NULL CHECK(LEN(Name) > 0) UNIQUE,
Year int NOT NULL CHECK (Year >= 1 AND Year <= 5),
DepartmentId int NOT NULL FOREIGN KEY (DepartmentId) REFERENCES Departments(Id),
Students int NOT NULL CHECK (Students > 0)
)

CREATE TABLE GroupsLectures (
Id int NOT NULL IDENTITY PRIMARY KEY,
GroupId int NOT NULL FOREIGN KEY (GroupId) REFERENCES Groups(Id),
LectureId int NOT NULL FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
)

CREATE TABLE Lectures (
Id int NOT NULL IDENTITY PRIMARY KEY,
[DayOfWeek] int NOT NULL CHECK([DayOfWeek] >= 1 AND [DayOfWeek] <= 7),
LectureRoom nvarchar(MAX) NOT NULL CHECK(LEN(LectureRoom) > 0),
SubjectId int NOT NULL FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
TeacherId int NOT NULL FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

CREATE TABLE Subjects (
Id int NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(100) NOT NULL CHECK(LEN(Name) > 0) UNIQUE
)

CREATE TABLE Teachers (
Id int NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name) > 0),
Salary money NOT NULL CHECK(Salary > 0),
Surname nvarchar(MAX) NOT NULL CHECK(LEN(Surname)>0)
)

INSERT INTO Teachers (Name, Salary, Surname) VALUES ('Vasja', 1000, 'Petrov')
INSERT INTO Teachers (Name, Salary, Surname) VALUES ('Jack', 10000, 'Underhill')
INSERT INTO Teachers (Name, Salary, Surname) VALUES ('Dave', 2500, 'McQueen')

INSERT INTO Subjects (Name) VALUES ('�����������')
INSERT INTO Subjects (Name) VALUES ('������������� �����')
INSERT INTO Subjects (Name) VALUES ('�����������')

INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES (2, 'D222', 2, 2)
INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES (4, 'D201', 1, 1)
INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES (6, 'D111', 3, 3)
INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES (1, 'D298', 3, 3)

INSERT INTO Faculties (Name) VALUES ('��������')
INSERT INTO Faculties (Name) VALUES ('������������')
INSERT INTO Faculties (Name) VALUES ('Computer Science')

INSERT INTO Departments (Financing, Name, FacultyId) VALUES (1000, 'Software Development', 1)
INSERT INTO Departments (Financing, Name, FacultyId) VALUES (10000, '�����������', 2)
INSERT INTO Departments (Financing, Name,  FacultyId) VALUES (5000, '�������', 3)

INSERT INTO Groups (Name, Year, DepartmentId, Students) VALUES ('GROUP123', 3, 2, 15)
INSERT INTO Groups (Name, Year, DepartmentId, Students) VALUES ('GROUP243', 2, 1, 14)
INSERT INTO Groups (Name, Year, DepartmentId, Students) VALUES ('GROUP111', 1, 2, 17)
INSERT INTO Groups (Name, Year, DepartmentId, Students) VALUES ('GROUP987', 5, 3, 20)

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (1, 2)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (2, 3)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (3, 3)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (4, 2)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (6, 5)
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (7, 1)

--	1. ������� ���������� �������������� ������� �Software Development�.
SELECT DISTINCT t.Name, t.Surname, t.Salary FROM Departments as dep, Groups as g, GroupsLectures as gl, Lectures as l, Teachers as t
WHERE g.DepartmentId = dep.Id AND  gl.GroupId = g.Id AND gl.LectureId = l.Id AND l.TeacherId = t.Id AND dep.Name = 'Software Development' 

--	2. ������� ���������� ������, ������� ������ ������������� �Dave McQueen�.
SELECT COUNT(l.Id) as [���������� ������] FROM Lectures as l, Teachers as t WHERE l.TeacherId = t.Id AND t.Name = 'Dave' AND t.Surname = 'McQueen'

--	3. ������� ���������� �������, ���������� � ��������� �D201�
SELECT COUNT(Lectures.Id) as [������� ������] FROM Lectures WHERE Lectures.LectureRoom = 'D201'

--	4. ������� �������� ��������� � ���������� ������, ���������� � ���.
SELECT LectureRoom, COUNT(Lectures.Id) as [���������� ������]
FROM Lectures
GROUP BY LectureRoom

--	5. ������� ���������� ���������, ���������� ������ ������������� �Jack Underhill�.
SELECT DISTINCT SUM(Students) as [ʳ������ ��������, �� ������� �� ����� Jack Underhill] FROM Lectures, Teachers,Groups, GroupsLectures
WHERE Lectures.TeacherId = Teachers.Id AND Teachers.Name = 'Jack' AND Teachers.Surname = 'Underhill'
AND GroupsLectures.LectureId = Lectures.Id AND GroupsLectures.GroupId = Groups.Id

--	6. ������� ������� ������ �������������� ���������� �Computer Science�.
SELECT AVG(Salary) FROM Teachers as t
join Lectures as l on l.TeacherId = t.Id
join GroupsLectures as gs on gs.LectureId = l.Id
join Groups as g on gs.GroupId = g.Id
join Departments as d on g.DepartmentId = d.Id
join Faculties as f on d.FacultyId = f.Id
where f.Name = 'Computer Science'

--	7. ������� ����������� � ������������ ���������� ��������� ����� ���� �����.
SELECT MIN(Students) as [̳������� ������� ��������], MAX(Students) as [����������� ������� ��������] FROM Groups

--	8. ������� ������� ���� �������������� ������.
SELECT AVG(Financing) as [C������ ���� �������������� ������] FROM Departments

--	9. ������� ������ ����� �������������� � ���������� �������� ��� ���������.
SELECT (SELECT (Name + ' ' + Surname)
FROM Teachers 
WHERE Id = TeacherId) as [����� ��'�], COUNT(DISTINCT SubjectId) as [ʳ������ ������� �������� ��������] FROM Lectures
GROUP BY TeacherId 


--	10. ������� ���������� ������ � ������ ���� ������.
SELECT DayOfWeek, COUNT(Id) as [ʳ������ ������ �� ���� �����] FROM Lectures
GROUP BY DayOfWeek


--	11. ������� ����� ��������� � ���������� ������, ��� ������ � ��� ��������.
SELECT LectureRoom, COUNT(d.Name) as [���������� ������, ��� ������ � ��� ��������]  FROM Lectures as l
join GroupsLectures as gs on gs.LectureId = l.Id
join Groups as g on gs.GroupId = g.Id
join Departments as d on g.DepartmentId = d.Id
GROUP BY LectureRoom

--	12.	������� �������� ����������� � ���������� ���������, ������� �� ��� ��������.
SELECT f.Name, COUNT(s.Id) [���������� ���������, ������� �������� �� �����������] FROM Faculties as f
join Departments as d on f.Id = d.FacultyId
join Groups as g on g.DepartmentId = d.Id
join GroupsLectures as gs on gs.GroupId = g.Id
join Lectures as l on gs.LectureId = l.Id
join Subjects as s on l.SubjectId = s.Id
GROUP BY f.Name



--	13.	������� ���������� ������ ��� ������ ���� �������������-���������.
SELECT t.Name + ' - ' + l.LectureRoom  as [��������-��������], COUNT(l.Id) as [ʳ������ ������]
FROM Lectures as l, Teachers as t WHERE l.TeacherId = t.Id
GROUP BY l.LectureRoom, t.Name
