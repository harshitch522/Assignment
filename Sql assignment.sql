create database classicmodels ;
use classicmodels;

-- Assignment-DAY-3(1)
select *from customers;
select customernumber, customername, state, creditlimit from customers
 where state is not null and creditlimit between 50000 and 100000 order by creditlimit desc;

-- Assignment-DAY-3(2)
select *from productlines;
select distinct productline from productlines where productline like "%cars";

-- Assignment-DAY-4(1)
select *from orders;
select ordernumber,status,COALESCE(comments, '-') from orders where status ="shipped" ; 

-- Assignment-DAY-4(2)
select employeenumber, firstname, jobtitle,
     case 
         when jobtitle = "president" then "P"
         when jobtitle in ("sale manager (EMEA)", "sales manager (APAC)", "Sales manager (NA)") then "SM"
         when jobtitle = "Sales Rep" then "SR"
         when jobtitle like "%vp%" then "VP"
         else "Unknown"
	 end as jobtitle_abbr
     from employees;
     
   -- Assignment-DAY-5(1)  
   select * from payments;
   select year(paymentdate) as year , min(amount) as min_amount from payments group by year order by year;
   
   -- Assignment-DAY-5(2)  
   select* from orders;
   select year (orderdate) as year, 
		concat("Q", Quarter(orderdate)) as Quarter,
        count(distinct ordernumber) as Unique_customer,
        count(ordernumber ) as Total_orders from orders
        group by year,quarter  
        order by year,quarter;
        
        
-- Assignment-DAY-5(3)  
  select * from payments;
  select date_format(paymentdate,"%d") as Month ,
  concat(format(sum(amount) / 1000, 0), "k") as Total_amount
         from payments
		group by  MONTH
        having sum(amount) between 500000 and 1000000 
        order by sum(amount)desc;
        

   -- Assignment-DAY-6(1) 
 create table journey
 (Bus_id int not null , 
  Bus_name char(30) not null, 
  source_station char(40)not null ,
  Destination char(40)not null,
  Email char(100)unique,
  primary key(bus_id));
 select * from journey;
 
  -- Assignment-DAY-6(2) 
 create table vendor 
    (Vendor_id int unique not null,
    Name char(40) not null,
    Email char(100) unique,
    Country char(50) default "NA",
    primary key (vendor_id));
    select *from vendor;
    
     -- Assignment-DAY-6(3) 
     create table Movies
     (Movie_id int unique not null ,
     Name char(40) not null ,
     Release_year char(40) default "-" ,
     Cast char(40) not null   ,
     Gender char (40) check (gender in ( "male", "female")) not null,
     no_of_shows int check (no_of_shows > 0 ) not null);
     
      -- Assignment-DAY-6(4)
    
    -- (B)--
    create table suppliers (
    supplier_id int primary key auto_increment,
    supplier_name char(40),
    location char(100));
    
  -- (A)--
	create table product (
    product_id int primary key auto_increment,
	product_name char (40) not null unique ,
    Description char(200) ,
	supplier_id int ,
	foreign key (supplier_id )references suppliers (supplier_id));

    -- (C)--
    Create table stock(
    id int primary key auto_increment,
    product_id int unique ,
    Balance_stock int unique ,
    foreign key (product_id) References product(product_id));
     
     
  -- Assignment-DAY-7(1)
   select * from customers;
   select * from employees;
   select e.employeeNumber,
       concat(e.firstname," ",e.lastname) as Sales_person,
       count(distinct c.customernumber) as unique_customers
       from employees as e 
       join customers as c on e.employeeNumber = c.salesRepEmployeeNumber
       group by e.employeeNumber, c.salesRepEmployeeNumber
       order by unique_customers desc;
	
    
    -- Assignment-DAY-7(2)
    select * from customers;
	select * from orders;
	select * from product;
	select * from orderedetails;
    select c.customernumber,
           c.customername,
           p.productcode,
           p.productname,
sum(od.quantityOrdered )as order_quantity,
    p.quantityinstock as total_stock,
(p.quantityInStock - sum(od.quantityOrdered))as Left_quantity
from customers as c
join orders as o using (customernumber)
join orderdetails as od using (ordernumber)
join products as p using (productcode)
group by c.customernumber ,p.productcode  order by c.customernumber;


 -- Assignment-DAY-7(3)
create table laptop1(laptop_name char(50) not null);
insert into laptop1 values("Dell"),("Apple"),("Lenovo");
select * from laptop1;

create table colours(colour_name varchar(50) not null);
insert into colours values("White"),("Silver"),("Black");
select * from colours;

select * from laptop1 cross join colours order by laptop_name;


 -- Assignment-DAY-7(4)
 create table Project (Employeeid int,Fullname char(50),Gender char(50),Managerid int );
 INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select * from project;

select e.fullname , m.fullname from project as e join project as m on e.managerid = m.employeeid;


-- Assignment-DAY-8
create table Facility (Facility_ID int,Name varchar(100),State varchar(100),Country varchar(100));
             
Alter table Facility modify Facility_ID int primary key auto_increment; 
Alter table Facility add column City varchar(100) not null after name ;
select * from Facility;
desc Facility;


-- Assignment-DAY-9
create table University(ID int,Name varchar(50));
insert into University values
			(1,"  Pune        University   "),
            (2,"  Mumbai      University   "),
            (3,"  Delhi    University  "),
            (4,"Madras University"),
            (5,"Nagpur University");    
update university set name = trim(REGEXP_REPLACE(Name," +"," "));  
set sql_safe_updates = 0;     
select * from university;


-- Assignment-DAY-10
select * from products;
select * from orders;

Create view Product_Status as
select year(o.orderdate) as Year, count(od.productcode) as Total_Products_Sold,
sum(od.quantityordered*od.priceeach) as Total_Value,
concat(count(od.productcode),"(",concat(round((count(productcode)/(select count(productcode)from orderdetails))*100),"%"),")") 
as "Value" from orders o join orderdetails od on o.ordernumber=od.ordernumber
group by Year order by Year;
select Year, Value from Product_Status;


-- Assignment-Day-11(1)
select * from customers;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Getcustomerlevel`(customer_number int)
BEGIN
select customernumber ,case 
when creditlimit >100000 then "platinum"
when creditlimit  between 25000 and  100000 then "Gold"
when creditlimit < 25000 then "silver"
end as "customerlevel " from customers 
where customerNumber = Customer_Number;
END;


-- Assignment-Day-11(2)

select * from payments;
select * from customers;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(input_year varchar(20) ,Country_name varchar(50))
BEGIN
select year (paymentdate) as year ,country,
concat(round(sum(amount)/1000),"k") as "total amount "
 from customers join payments using (customernumber )  where year(paymentdate)= input_year and country =country_name
group by country ,year (paymentdate);
END;


-- Assignment-Day-12(1)
select * from orders;
select Year(orderdate) as Year, date_format(orderdate, '%b') as Month, count(*) as "Total Orders",
ifnull(concat(round(((count(*) - lag(count(*)) over (order by Year(orderdate), Month(orderdate))) / 
lag(COUNT(*)) over (order by Year(orderdate), Month(orderdate))) * 100),'%'),'N/A') as "% YoY Change"
from Orders group by Year, Month, Year(orderdate), Month(orderdate)
order by Year, Month(orderdate);


-- Assignment-Day-12(2)
create table emp_udg(Empid int primary key auto_increment,Name char(30), Dob date );
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select *from emp_udg;

CREATE DEFINER=`root`@`localhost` FUNCTION `Calculate_Age`(DOB date) RETURNS varchar(50) CHARSET latin1
BEGIN
DECLARE months INT;
DECLARE age VARCHAR(255);
DECLARE years INT;  

SET years = (TIMESTAMPDIFF(YEAR, DOB, CURDATE()));
SET months = (TIMESTAMPDIFF(MONTH, DOB, CURDATE()) % 12);
    
RETURN CONCAT(years, ' years ', months, ' months');
END; -- semicolon is added so that below queries are executed


-- Assignment-Day-13(1)
select customernumber ,customername from customers where customerNumber not in 
(select distinct customerNumber from orders);

-- Assignment-Day-13(2)
select c.customerNumber, c.customerName, COUNT(o.orderNumber) as totalOrders
from customers c left join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName union
select c.customerNumber, c.customerName, COUNT(o.orderNumber) AS totalOrders
from customers c right join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName;


-- Assignment-Day-13(3)
select * from orderdetails;

with RankQuantity as (select ordernumber, quantityOrdered, dense_rank() 
over(partition by ordernumber order by quantityOrdered desc) as rnk from orderdetails)
select distinct(ordernumber), quantityordered from RankQuantity where rnk=2;


-- Assignment-Day-13(4)
select * from orderdetails;

select max(Total) as "MAX(Total)", min(Total) as "MIN(Total)"
       from (select orderNumber, count(productCode) as Total
       from Orderdetails
       group by orderNumber) as abc;
       
       
       
     
 -- Assignment-Day-13(5)    
select * from productlines;
select * from products;

select productline, avg(buyprice) from products group by productline;      

select productline, count(productline) as Total 
       from products where buyprice > (select avg(buyprice) from products)
       group by productLine order by Total desc;
       
-- Assignment-Day-14

Create table Emp_EH(EmpID int primary key, EmpName varchar(30), EmailAddress varchar(30));

CREATE DEFINER=`root`@`localhost` PROCEDURE `EMP_EH`(IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        SELECT 'Error occurred' AS Message;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);
    
    SELECT 'Record Inserted Successfully' AS Message;
END
    
-- Assignment-Day-15

Create table Emp_BIT(Name varchar(30), Occupation varchar(20), Working_Date date, Working_Hours int);
Insert into Emp_BIT values 
                    ("Robin", "Scientist", '2020-10-04', 12), 
                    ("Warner", "Engineer", '2020-10-04', 10), 
                    ("Peter", "Actor", '2020-10-04', 13), 
                    ("Marco", "Doctor", '2020-10-04', 14), 
                    ("Antonio", "Business", '2020-10-04', 11);

CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.working_hours<0 then
set new.working_hours=-(new.working_hours);
end if;
END; -- semicolon is added so that below queries are executed

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES ("Gerard", "Bodyguard", '2020-10-04', -20);
select * from Emp_BIT;       