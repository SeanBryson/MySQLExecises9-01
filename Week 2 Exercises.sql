/* Create below mentioned table and insert data into it, while creating include relationship into
them using Primary key and Foreign key and add on update and on delete cascading as well.
EmployeeInfo Table:
EmpID EmpFname EmpLname Department Project Address DOB Gender
1 Sanjay Mehra HR P1 Hyderabad(HYD) 01/12/1976 M
2 Ananya Mishra Admin P2 Delhi(DEL) 02/05/1968 F
3 Rohan Diwan Account P3 Mumbai(BOM) 01/01/1980 M
4 Sonia Kulkarni HR P1 Hyderabad(HYD) 02/05/1992 F
5 Ankit Kapoor Admin P2 Delhi(DEL) 03/07/1994 M
EmployeePosition Table:
EmpID EmpPosition DateOfJoining Salary
1 Manager 01/05/2022 500000
2 Executive 02/05/2022 75000
3 Manager 01/05/2022 90000
2 Lead 02/05/2022 85000
1 Executive 01/05/2022 300000 */
use practice;

drop table EmployeePosition;
drop table EmployeeInfo;
create table if not exists EmployeeInfo (
	EmpID int primary key auto_increment,
    EmpFname varchar(30),
    EmpLname varchar(30),
    Department varchar(15),
    Project varchar(3),
    Address varchar(30),
    DOB date,
    Gender char(1) default 'x'
					check (gender IN ('M','F','X'))
);

create table if not exists EmployeePosition (
	EmpID int,
    EmpPosition varchar(30),
    DateOfJoining date,
    Salary int,
  #  primary key (Salary),
    foreign key (EmpID) references
		EmployeeInfo (EmpID)
		on delete cascade
        on update cascade
);

insert into EmployeeInfo values(1, "Sanjay", "Mehra", "HR", "P1", "Hyderabad(HYD)", '1976-12-01', "M");
insert into EmployeeInfo values(2, "Ananya", "Mishra", "Admin", "P2", "Delhi(DEL)", '1968-05-02', "F");
insert into EmployeeInfo values(3, "Rohan", "Diwan", "Account", "P3", "Mumbai(BOM)", '1980-01-01', "M");
insert into EmployeeInfo values(4, "Sonia", "Kulkarni", "HR", "P1", "Hyderabad(HYD)", '1992-05-02', "F");
insert into EmployeeInfo values(5, "Ankit", "Kapoor", "Admin", "P2", "Delhi(DEL)", '1994-07-03', "M");

insert into EmployeePosition values(1, "Manager", '2022-05-01', 500000);
insert into EmployeePosition values(2, "Executive", '2022-05-02', 75000);
insert into EmployeePosition values(3, "Manager", '2022-05-01', 90000);
insert into EmployeePosition values(2, "Lead", '2022-05-02', 85000);
insert into EmployeePosition values(1, "Executive", '2022-05-01', 300000);

select * from EmployeeInfo;
select * from EmployeePosition;

/*
1. Write a query to fetch the EmpFname from the EmployeeInfo table in the upper case and use
the ALIAS name as EmpName. 
*/

select upper(EmpFname) as EmpName from EmployeeInfo;

/*
2. Write a query to fetch the number of employees working in the department ‘HR’.
*/

select Department, count(*) from EmployeeInfo where Department = "HR";

/*
3. Write a query to get the current date.
*/

select now();
select curdate();

/*
4. Write a query to retrieve the first four characters of EmpLname from the EmployeeInfo table.
*/

select substring(EmpLname, 1, 4) from EmployeeInfo;

/*
5. Write a query to fetch only the place name(string before brackets) from the Address column of
EmployeeInfo table.
*/

select substring(Address, 1, length(Address) - 5) from EmployeeInfo;

/*
6. Write a query to create a new table that consists of data and structure copied from the other
table.
*/

create table Info2 like EmployeeInfo;
insert Info2 select * from EmployeeInfo;
select * from Info2;

/*
7. Write a query to find all the employees whose salary is between 50000 to 100000.
*/

select EmpFname, EmpLname, sum(Salary) as TotalSalary from EmployeeInfo
left join EmployeePosition on EmployeeInfo.EmpID = EmployeePosition.EmpID
group by EmployeeInfo.EmpID having sum(Salary) between 50000 and 100000;

/*
8. Write a query to find the names of employees that begin with ‘S’
*/

select EmpFname, EmpLname from EmployeeInfo where EmpFname like "s%";

/*
9. Write a query to fetch top N records.
*/

select * from EmployeeInfo limit 2;

/*
10. Write a query to retrieve the EmpFname and EmpLname in a single column as “FullName”. The
first name and the last name must be separated with space.
*/

select concat(EmpFname, " ", EmpLname) as FullName from EmployeeInfo;

/*
11. Write a query find number of employees whose DOB is between 02/05/1970 to 31/12/1975
and are grouped according to gender.
*/

select EmpFname, EmpLname, DOB, Gender from EmployeeInfo 
where DOB between '1970-05-02' and '1975-12-31' order by Gender;

/*
12. Write a query to fetch all the records from the EmployeeInfo table ordered by EmpLname in
descending order and Department in the ascending order.
*/

select * from EmployeeInfo order by Department asc, EmpLname desc;

/*
13. Write a query to fetch details of employees whose EmpLname ends with an alphabet ‘A’ and
contains five alphabets.
*/

select * from EmployeeInfo where EmpLname like '____a';

/*
14. Write a query to fetch details of all employees excluding the employees with first names,
“Sanjay” and “Sonia” from the EmployeeInfo table.
*/

select * from EmployeeInfo where EmpFname != "Sanjay" and EmpFname != "Sonia";

/*
15. Write a query to fetch details of employees with the address as “DELHI(DEL)”.
*/

Select * from EmployeeInfo where Address = "DELHI(DEL)";

/*
16. Write a query to fetch all employees who also hold the managerial position.
*/

select EmpFname, EmpLname, EmpPosition from EmployeeInfo 
join EmployeePosition on EmployeeInfo.EmpID = EmployeePosition.EmpID
where EmpPosition = "Manager";

/*
17. Write a query to fetch the department-wise count of employees sorted by department’s count in
ascending order.
*/

select Department, count(*) as Count from EmployeeInfo group by Department 
having Count order by Count asc;

/*
18. Write a query to calculate the even and odd records from a table.
*/

select * from (select count(*) as Even from EmployeeInfo where EmpID mod 2 = 0) as A
join (select count(*) as Odd from EmployeeInfo where EmpID mod 2 = 1) as B;

/*
19. Write a SQL query to retrieve employee details from EmployeeInfo table who have a date of
joining in the EmployeePosition table.
*/

select * from EmployeeInfo join 
(select EmployeeInfo.EmpID from EmployeeInfo join EmployeePosition 
using(EmpID) group by EmployeeInfo.EmpID) as B using(EmpID);

/*
20. Write a query to retrieve two minimum and maximum salaries from the EmployeePosition
table.
*/

select Salary from (select Salary from EmployeePosition order by Salary desc limit 2) a
union
select Salary from (select Salary from EmployeePosition order by Salary asc limit 2) b order by Salary desc;

/*
21. Write a query to find the Nth highest salary from the table without using TOP/limit keyword.
*/

select Salary from EmployeePosition as a 
# where n - 1
where 1 - 1 = (
	select count(Salary)
	from EmployeePosition b 
	where b.Salary > a.Salary) order by Salary desc;

/*
22. Write a query to retrieve duplicate records from a table.
*/

# Finds duplicate EmployeeInfo from the joined table of EmployeeInfo and EmployeePosition
# These employees have more than one position and salary
select *, count(*) from 
(select * from EmployeeInfo join EmployeePosition using (EmpID)) a 
group by EmpID having count(*) > 1;


/*
23. Write a query to retrieve the list of employees working in the same department.
*/

select * from EmployeeInfo where Department in 
(select Department from EmployeeInfo group by Department having count(*) > 1)
order by Department asc;

/*
24. Write a query to retrieve the last 3 records from the EmployeeInfo table.
*/

select * from (select * from 
(select * from EmployeeInfo order by EmpID desc) a 
limit 3) b order by EmpID asc;

/*
25. Write a query to find the third-highest salary from the EmpPosition table.
*/

select * from (select * from 
(select * from EmployeePosition order by Salary desc limit 3) a 
order by Salary asc) b limit 1;

/*
26. Write a query to display the first and the last record from the EmployeeInfo table.
*/

select * from (select * from EmployeeInfo order by EmpID asc limit 1) a
union
select * from (select * from EmployeeInfo order by EmpID desc limit 1) b order by EmpID asc;

/*
27. Write a query to add email validation to your database
*/

# Make changes to table to prepare for email validation
alter table EmployeeInfo add Email varchar(255);
set sql_safe_updates = 0;
update EmployeeInfo set Email = concat(EmpFname, EmpLname, "@gmail.com");
select * from EmployeeInfo where Email like '%.com' and Email like '%@%';

# Add email validation
alter table EmployeeInfo add check (Email like '%.com' and Email like '%@%');

/*
28. Write a query to retrieve Departments who have less than 2 employees working in it
*/

select Department from EmployeeInfo group by Department having count(*) < 2;

/*
29. Write a query to retrieve EmpPostion along with total salaries paid for each of them.
*/

select * from (select EmpID, sum(Salary) as TotalSalaries 
from EmployeePosition group by EmpID having sum(Salary)) as A 
right join EmployeePosition using (EmpID);

/*
30. Write a query to fetch 50% records from the EmployeeInfo table.
*/

set @count = (select round(count(*)/2) as count from EmployeeInfo); 
set @sentence = concat('select * from EmployeeInfo limit ', @count);
prepare q from @sentence;
execute q;
deallocate prepare q;