

create table Countries(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50)
)

insert into Countries([Name])
values('Azerbaycan'),
	  ('Turkiye'),
	  ('Yaponiya'),
	  ('Rusiya')


create table Cities(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50),
	[CountryId] int,
	foreign key (CountryId) references Countries(Id)
)

insert into Cities([Name],[CountryId])
values('Baki',1),
	  ('Sumqayit',1),
	  ('Tokiyo',3),
	  ('Moskva',4)


create table Students(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50),
	[Surname] nvarchar(50),
	[Age] int,
	[Emial] nvarchar(100),
	[Address] nvarchar(100),
	[CityId] int,
	foreign key (CityId) references Cities(Id)
)

insert into Students([Name],[Surname],[Age],[Emial],[Address],[CityId])
values('Nihat','Soltanov',17,'nihat@gmail.com','Ecemi',1),
	  ('Ferdi','Ismayilzade',18,'ferdi@gmail.com','Ecemi',2),
	  ('Eldar','Ehmedov',19,'eldar@gmail.com','Bileceri',2),
	  ('Tukezban','Gulmemmedova',19,'tukezban@gmail.com','Puskinskaya',4)


create table EducationPrice(
	[Id] int primary key identity(1,1),
	[Value] nvarchar(100)
)

insert into EducationPrice([Value])
values(5000),
	  (4000),
	  (3500),
	  (3000),
	  (6000)


create table Educations(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[EducationPriceId] int,
	foreign key (EducationPriceId) references EducationPrice(Id)
)

insert into Educations([Name],[EducationPriceId])
values('BackEnd programlasdirma',1),
	  ('FrontEnd programlsdirma', 2),
	  ('FullStack programlasdirma',5),
	  ('Design',3)


create table Groups(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[EducationId] int,
	foreign key (EducationId) references Educations(Id)
)

insert into Groups([Name],[EducationId])
values('PB102',1),
	  ('PB205',1),
	  ('PF302',2),
	  ('P99',3)


create table StudentGroups(
	[Id] int primary key identity(1,1),
	[StudentId] int,
	[GroupId] int,
	foreign key (StudentId) references Students(Id),
	foreign key (GroupId) references Groups(Id)
)



insert into StudentGroups([StudentId],[GroupId])
values(1,1),
	  (2,1),
	  (3,2),
	  (4,4)


create table Teachers(
	[Id] int primary key identity (1,1),
	[FullName] nvarchar(100),
	[Address] nvarchar(100),
	[Email] nvarchar(100),
	[Salary] decimal,
	[EducationId] int,
	foreign key (EducationId) references Educations(Id)
)
select * from Educations

insert into Teachers([FullName],[Address],[Email],[Salary],[EducationId])
values('Cavid Bashirov','Ecemi','cavid@gmail.com',4000.00,3),
	  ('Kubra Memmedova','Nesimim','kubra@gmail.com',2000.00,2),
	  ('Namiq Qaracuxurlu','Elmler akademiyasi','namiq@gmail.com',1000.00,1),
	  ('Elza Seyidcahan','28 may','elza@gmail.com',7000.00,4)

create table TeacherGroups(
	[Id] int primary key identity(1,1),
	[GroupId] int,
	[TeacherId] int,
	foreign key (TeacherId) references Teachers(Id),
	foreign key (GroupId) references Groups(Id)
)

select * from Groups
select * from Teachers

insert into TeacherGroups([GroupId],[TeacherId])
values(1,1),
	  (2,2),
	  (3,1),
	  (4,3)


--Course databazasi olacaq. Students table (Id, Name,Surname,Age,Email,Address) yaradirsiz, Student table-dan hansisa data silinende    
--silinmish data  StudentArchives table-na  yazilmalidir. Silinme prosesini procedure sekilinde yazmalisiz.   
--Qeyd : Butun her sheyi kodlar vasitesile yazirsiz, butun sorgular faylda olsun. (Databaza yaratmaq daxil olmaq shertile)


create table StudentArchives(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(100),
	[Surname] nvarchar(100),
	[Age] int,
	[Email] nvarchar(100),
	[Address] nvarchar(100),
	[Date] datetime
)


create procedure usp_DeletedeStudents
@id int
as
	delete from StudentGroups where [StudentId] = @id
	delete from Students where [Id] = @id


create trigger trg_AddDeletedStudents
on Students
after delete
as
	insert into StudentArchives([Name],[Surname],[Age],[Email],[Address],[Date])
	select d.[Name], d.[Surname], d.[Age], d.[Emial], d.[Address], GETDATE() from deleted d


exec usp_DeletedeStudents 1

select * from StudentArchives
