create database if not exists movieIndustry;

use movieIndustry;

create table Actors(
FirstName varchar(20),
LastNamer varchar(20),
Dob DATE,
Gender ENUM('Male', 'Female', 'Other'),
MaritalStatus ENUM('Married', 'Divorced', 'Single'),
NetWorthInMillions DECIMAL);

show tables;
drop table Actors;

CREATE TABLE if not exists Actors (
Id INT AUTO_INCREMENT,
FirstName VARCHAR(20) NOT NULL,
SecondName VARCHAR(20) NOT NULL,
DoB DATE NOT NULL,
Gender ENUM('Male','Female','Other') NOT NULL,
MaritalStatus ENUM('Married', 'Divorced', 'Single', 'Unknown') DEFAULT "Unknown",
NetWorthInMillions DECIMAL NOT NULL,
PRIMARY KEY (Id));

describe actors;

create temporary table ActorNames ( FirsName Char(20));

describe ActorNames;

show character set;

show collation;

INSERT INTO Actors () VALUES ();
INSERT INTO Actors SET DoB="1950-12-12", FirstName="Rajnikanth", SecondName="",  Gender="Male", NetWorthInMillions=50,  MaritalStatus="Married";

SELECT * from Actors WHERE FirstName LIKE "Jen%";

select * from Actors where FirstName like "_r%";

select * from Actors order by FirstName DESC;

select * from Actors order by NetWorthInMillions DESC , FirstName DESC, SecondName ASC;

select * from Actors order by Binary FirstName;

select * from Actors order by CAST(NetWorthInMillions AS CHAR);

select * from Actors order by NetWorthInMillions DESC limit 3;

select FirstName from Actors order by NetWorthInMillions DESC limit 4 offset 3;

delete from Actors;

truncate Actors;

drop table Actors;

update Actors set NetWorthInMillions = 5 order by FirstName limit 3;

analyze table Actors;
show index from Actors;

show engines;


-- 

use MovieIndustry;
show procedure status;

delimiter **
create procedure Summary()
begin

declare TotalM, totalF int default 0;
declare AvgNetWorth DEC(6,2) default 0.0;

select count(*) into TotalM
from Actors where Gender= 'Male';

select count(*) into totalF
from Actors where Gender= 'Female';

    SELECT AVG(NetWorthInMillions) INTO AvgNetWorth
    FROM Actors;
    
    SELECT TotalM, TotalF, AvgNetWorth;

end**
delimiter ;

call Summary();



select * from Actors;
delimiter **
create procedure GetActorsByNetWorth(in networth int)
begin 

select * from Actors where NetWorthInMillions >= networth;

end **

delimiter ;

call GetActorsByNetWorth(10);


Delimiter **
drop procedure if exists getCountOfActorsByNetwWorth;
create procedure getCountOfActorsByNetwWorth(IN  networth int , out countofActors int )
begin
select count(*) into countofActors from Actors where NetWorthInMillions >= 5;
end **
delimiter ;

call getCountOfActorsByNetwWorth(5, @Actorcount);
select @Actorcount;

delimiter **
drop procedure if exists increasedNetWorth;
create procedure increasedNetWorth( in actorId int, inout updatednetworth int)
begin
declare originalWorth int;
select NetWorthInMillions into originalWorth from Actors where id = actorId;
set updatednetworth = updatednetworth+ originalWorth;

end**
delimiter ;

set @increasingworth= 50;
call increasedNetWorth(4, @increasingworth);
select @increasingworth;

delimiter **
drop procedure if exists PrintMartialStatus;
create procedure PrintMartialStatus( in actorId int, inout actorstatus varchar(30))
begin
declare marriageStatus varchar(30);
select MaritalStatus into marriageStatus from Actors where id = actorId ;
	if marriageStatus  like 'Single' then
		set actorstatus = 'The Actor is single';
	else
		set actorstatus= 'The Actor is married';
	end if;
end **
delimiter ;

set @martialStatusOFBrad = '';
call PrintMartialStatus(1, @martialStatusOFBrad );
select @martialStatusOFBrad;

select * from Actors;

delimiter **
drop procedure if exists PrintMartialStatus2;
create procedure PrintMartialStatus2( in actorId int, inout actorstatus varchar(30))
begin
declare marriageStatus varchar(30);
select MaritalStatus into marriageStatus from Actors where id = actorId ;
	if marriageStatus  like 'Single' then
		set actorstatus = 'The Actor is single';
	elseif marriageStatus like 'Divorced' then
		set actorstatus = 'The Actor is divorcee';
	else
		set actorstatus= 'The Actor is married';
	end if;
end **
delimiter ;

set @martialStatusOFBrad = '';
call PrintMartialStatus2(4, @martialStatusOFBrad );
select @martialStatusOFBrad;


delimiter **
-- drop procedure if exists test_proc;
create procedure test_proc()
begin


declare current_crm_org_uuid_name varchar(100);

-- declare cursor_get_crm_org_metadata_ids CURSOR FOR SELECT integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.id from integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata where integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.object_error_count > 0 order by integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.id;

set current_crm_org_uuid_name ='integration_ff8080817168b9590171d3e2449511c9';

-- set @sql = concat( 'declare cursor_get_crm_org_metadata_ids CURSOR FOR SELECT ' , current_crm_org_uuid_name, '.crm_error_metadata.id from ' , current_crm_org_uuid_name,  '.crm_error_metadata where ', current_crm_org_uuid_name , '.crm_error_metadata.object_error_count > 0 order by ',  current_crm_org_uuid_name, '.crm_error_metadata.id');
-- select @sql;
-- PREPARE stmt FROM @sql;
-- execute stmt;
-- deallocate prepare stmt;




end**
delimiter ;

call test_proc();

SELECT integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.id from integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata where integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.object_error_count > 0 order by integration_ff8080817168b9590171d3e2449511c9.crm_error_metadata.id



--  

delimiter **
drop procedure if exists PrintMaleActors;
create procedure PrintMaleActors( out str varchar(25))
begin

declare totalrows int default 0;
declare currentrow int;
declare fname varchar(25);
declare lname varchar(25);
declare gen varchar(10);

set currentrow =1;
set str= '';

select count(*) into totalrows from Actors;

printloop: loop
	if currentrow > totalrows then
	leave printloop;
    end if;

	select Gender into gen from Actors where id = currentrow;
	if gen not like 'Male' then
		 set currentrow = currentrow+1;
		 iterate printloop;
	else
		 select FirstName into fname from Actors where id = currentrow;
		 select SecondName into lname from Actors where id = currentrow;
		 set str= concat(str, fname, ' ', lname, ' ,');
		 set currentrow= currentrow+1;
	end if;
end loop printloop;
 
end **
delimiter ;

set @maleactordata = '';
call PrintMaleActors( @maleactordata);
select @maleactordata;

delimiter **
create procedure PrintMaleActoesViaCursor( out str varchar(255))
begin

declare fname varchar(25);
declare lname varchar(25);
declare lastRowFetched int default 0;
-- declaring cursor
declare cur_maleActors cursor for 
	select FirstName, SecondName from Actors where Gender like 'Male';
    
-- declaring what happens if the cursor reaches the end of select rows
declare continue handler for not found
	set lastRowFetched =1;
    
set str= '';

-- now we will open the cursor to execute the corresponfing select query
open cur_maleActors;
printloop: loop
	fetch cur_maleActors into fname, lname;
    if lastRowFetched = 1 then
		leave printloop;
	end if;
    set str= concat(str, ' ', fname, ' ',  lname, ',');
end loop printloop;
close cur_maleActors;
set lastRowFetched =0;

end**
delimiter ;

call PrintMaleActoesViaCursor(@maleactordata);
select @maleactordata;

delimiter **
-- drop procedure if exists proc1;
create procedure proc1()
begin
declare procedure_name varchar(100) ;

declare continue handler for 1048
begin
	GET DIAGNOSTICS CONDITION 1 
    @p1 = MYSQL_ERRNO, @p2 = RETURNED_SQLSTATE, @p3=MESSAGE_TEXT,@p5= SCHEMA_NAME, @p4=TABLE_NAME;
    select concat('Failed with null not allowed- ',@p1,@p2,@p3, @p4, @p5) as message;
end;

declare continue handler for 1062
begin
	GET DIAGNOSTICS CONDITION 1 
    @p1 = MYSQL_ERRNO, @p2 = RETURNED_SQLSTATE, @p3=MESSAGE_TEXT,@p5= SCHEMA_NAME, @p4=TABLE_NAME;
    select concat('Failed with duplicate key - ',@p1,@p2,@p3, @p4, @p5 ) as message;
end;

 
INSERT INTO DigitalAssets(URL, AssetType, ActorID) VALUES(null, null, null);
INSERT INTO DigitalAssets(ActorID, URL,  AssetType) VALUES(10, 'https://instagram.com/iamsrk','Instagram');
INSERT INTO DigitalAssets(ActorID, URL,  AssetType) VALUES(10, 'https://instagram.com/iamsrk','Instagram');
end**
delimiter ;

delimiter **
drop procedure if exists proc2;
create procedure proc2()
begin
INSERT INTO DigitalAssets(URL, AssetType, ActorID) VALUES(null, null, null);
INSERT INTO DigitalAssets(ActorID, URL,  AssetType) VALUES(10, 'https://instagram.com/iamsrk','Instagram');
INSERT INTO DigitalAssets(ActorID, URL,  AssetType) VALUES(10, 'https://instagram.com/iamsrk','Instagram');
end**
delimiter ;

call proc1();

select * from DigitalAssets;

-- 

drop table DigitalAssets;
create table DigitalAssets(
ActorID int ,
AssetType varchar(25),
URL varchar(100),
primary key (ActorID)
);

delimiter **
drop procedure if exists InsertDigitalAssets;
create procedure InsertDigitalAssets( in id int, in Asset varchar(100), in Type varchar(25))
begin

declare continue handler for 1062
begin
select 'duplicate key error occurred' AS message;
end;

INSERT INTO DigitalAssets(URL, AssetType, ActorID) VALUES(Asset, Type, Id);

select count(*) as digitalAseetCounter from  DigitalAssets where ActorID = id;

end **
delimiter ;

CALL InsertDigitalAssets(10, 'https://instagram.com/iamsrk','Instagram');
CALL InsertDigitalAssets(10, 'https://instagram.com/iamsrk','Instagram');


delimiter **
drop procedure if exists handlerscope;
create procedure handlerscope()
begin
	begin
		declare continue handler for  1048
			select 'values cannot be null' as message;
    end;
    INSERT INTO DigitalAssets(URL, AssetType, ActorID) VALUES(null);

end **
delimiter ;

CALL handlerscope();


-- 

INSERT INTO Actors ( 
FirstName, SecondName, DoB, Gender, MaritalStatus, NetworthInMillions) 
VALUES ("Brad", "Pitt", "1963-12-18", "Male", "Single", 240.00);

-- Query 2
INSERT INTO Actors ( 
FirstName, SecondName, DoB, Gender, MaritalStatus, NetworthInMillions) 
VALUES 
("Jennifer", "Aniston", "1969-11-02", "Female", "Single", 240.00),
("Angelina", "Jolie", "1975-06-04", "Female", "Single", 100.00),
("Johnny", "Depp", "1963-06-09", "Male", "Single", 200.00);

-- Query 3
INSERT INTO Actors 
VALUES (DEFAULT, "Dream", "Actress", "9999-01-01", "Female", "Single", 000.00);

-- Query 4
INSERT INTO Actors VALUES (NULL, "Reclusive", "Actor", "1980-01-01", "Male", "Single", DEFAULT);

--


delimiter **
-- drop procedure if exists delete_orphan_error_records_for_all_active_orgs;
create procedure delete_orphan_error_records_for_all_active_orgs()
begin

declare current_crm_org_uuid varchar(100);
declare current_crm_org_uuid_name varchar(200);
declare active_crm_org_counter INT Default 0;
declare total_active_orgs_with_di_enabled int default 0;
declare stored_procedure_name varchar(100);

-- declaring cursor for fetching all the activce crm_org_uuids
declare cursor_get_active_crm_org_uuids cursor for select integration_common.crm_org_managed_status.crm_org_uuid from integration_common.crm_org_managed_status where integration_common.crm_org_managed_status.active=1 order by integration_common.crm_org_managed_status.crm_org_uuid;
-- declaring handlers
declare exit handler for SQLException
begin
	GET DIAGNOSTICS CONDITION 1 
    @error_detail_number = MYSQL_ERRNO, @error_detail_message =MESSAGE_TEXT ,@error_detail_schema = SCHEMA_NAME, @error_detail_table =TABLE_NAME, @error_cursor_name= CURSOR_NAME;
    set stored_procedure_name= 'delete_orphan_error_records_for_all_active_orgs';
    insert into integration_common.stored_procedure_error_logs(mysql_procedure_name, mysql_cursor_name, mysql_schema_name, mysql_table_name, mysql_error_number, mysql_error_message)
    values(stored_procedure_name, @error_cursor_name, @error_detail_schema, @error_detail_table, @error_detail_number, @error_detail_message );
end;

insert into integration_common.stored_procedure_logs(message) values('started delete_orphan_error_records_for_all_active_orgs');
set total_active_orgs_with_di_enabled = (select count(*) from integration_common.crm_org_managed_status where integration_common.crm_org_managed_status.active =1);
-- now open the cursor and loop through all these ids
open cursor_get_active_crm_org_uuids;
	loop_active_crm_org_uuids: while active_crm_org_counter < total_active_orgs_with_di_enabled do
		fetch cursor_get_active_crm_org_uuids into current_crm_org_uuid;
        
        -- now we will declare another cursor that will hover over the crm_error_metadata in this particluar org
        set current_crm_org_uuid_name= concat('integration_' , current_crm_org_uuid);
        insert into integration_common.stored_procedure_logs(message) values( concat('starting to execute queries for ', current_crm_org_uuid_name ));
        call delete_orphan_error_records_for_given_crm_org(current_crm_org_uuid_name, current_crm_org_uuid );
        insert into integration_common.stored_procedure_logs(message) values( concat('succesfuly executed queries for ', current_crm_org_uuid_name));
        set active_crm_org_counter = active_crm_org_counter+ 1;
        
	end while loop_active_crm_org_uuids;
close cursor_get_active_crm_org_uuids;
insert into integration_common.stored_procedure_logs(message) values('completed delete_orphan_error_records_for_all_active_orgs');
end**
delimiter ;

delete from stored_procedure_error_logs;
delete from stored_procedure_logs;
call delete_orphan_error_records_for_all_active_orgs();
select * from stored_procedure_error_logs;
select * from stored_procedure_logs;
drop table stored_procedure_error_logs;



-- 

delimiter **
-- drop procedure if exists delete_orphan_error_records_for_given_crm_org;
create procedure delete_orphan_error_records_for_given_crm_org(in current_crm_org_uuid_name varchar(200), current_crm_org_uuid varchar(100) )
begin

declare sql_statement nvarchar(5000);
declare crm_error_metadata_ids_counter int default 0;
declare current_crm_error_metadata_id varchar(100);


set @sql = concat( 'select count(*) into @total_crm_error_metadata_ids from ', current_crm_org_uuid_name, '.', 'crm_error_metadata where crm_error_metadata.object_error_count > 0' ); 
PREPARE stmt FROM @sql;
execute stmt;
deallocate prepare stmt;


-- declaring cursor to fetch all crm_error_meatdata ids
set @sql = concat( 'declare cursor_get_crm_org_metadata_ids CURSOR FOR SELECT ' , current_crm_org_uuid_name, '.crm_error_metadata.id from ' , current_crm_org_uuid_name,  '.crm_error_metadata where ', current_crm_org_uuid_name , '.crm_error_metadata.object_error_count > 0 order by ',  current_crm_org_uuid_name, '.crm_error_metadata.id');
prepare stmt from @sql;
execute stmt;

open cursor_get_crm_org_metadata_ids;
	loop_crm_error_metadata_ids: while crm_error_metadata_ids_counter < @total_crm_error_metadata_ids do
		fetch cursor_get_crm_org_metadata_ids into current_crm_error_metadata_id;
        
        
        set crm_error_metadata_ids_counter = crm_error_metadata_ids_counter+1;
		
        
	end while loop_crm_error_metadata_ids;
close cursor_get_crm_org_metadata_ids;


end**
delimiter ;

call delete_orphan_error_records_for_given_crm_org('integration_ff8080817168b9590171d3e2449511c9', 'ff8080817168b9590171d3e2449511c');

--

create database if not exists integration_common;
use integration_common;
show tables;

create database if not exists integration_ff8080817784cd17017788daa1180060;
use integration_ff8080817784cd17017788daa1180060;

delete from integration_ff8080817784cd17017788daa1180060.crm_object_error where id in ( select cid from (  select ocoe.id as cid from integration_ff8080817784cd17017788daa1180060.crm_object_error ocoe  left join  integration_ff8080817784cd17017788daa1180060.crm_object_error coe  join  integration_ff8080817784cd17017788daa1180060.crm_executive_mapping m on coe.crm_executive_mapping_id = m.uuid  join  integration_ff8080817784cd17017788daa1180060.dynamic_query_executive_results d
 on d.crm_object_error_id=coe.id on ocoe.id= coe.id  where ocoe.crm_error_metadata_id= 'ff808081788701f30178b7ffcebf5d18' and
 coe.id is null and coe.dynamic_query_id is null and ( ocoe.entity_type like 'contact' or ocoe.entity_type like 'lead') ) AS c) ;

create database if not exists integration_ff8080817168b9590171d3e2449511c9;
use integration_ff8080817168b9590171d3e2449511c9;

select * from integration_common.crm_org_managed_status;
delete from integration_common.crm_org_managed_status where crm_org_uuid NOT in ( 'ff8080817168b9590171d3e2449511c9', 'ff8080817784cd17017788daa1180060' );

use integration_common;
drop table stored_procedure_error_logs;
create table stored_procedure_error_logs(
mysql_procedure_name varchar(100),
mysql_cursor_name varchar(100),
mysql_schema_name varchar(100),
mysql_table_name varchar(100),
mysql_error_number integer,
mysql_error_message varchar(1024)
);


create table stored_procedure_logs(
message varchar(250)
);


CALL deleteOrphanErrorRecords();

use movieIndustry;
select * from  crm_object_error;

select * from crm_error_metadata; 

select sm.SCHEMA_NAME from integration_common.crm_org_managed_status  coms
join INFORMATION_SCHEMA.SCHEMATA sm
on
sm.SCHEMA_NAME = concat('integration_', coms.crm_org_uuid);








