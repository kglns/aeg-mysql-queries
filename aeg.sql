-- Queries
-- Assume that we already know user_id via session

-- Get all activities of a user
SELECT * FROM user_activities WHERE fk_user_activities_user_id = 1;

-- Get a user's income / expenses
-- There are 2 ways to do this
-- Via user_activities table join
-- You can filter and sort by [from_date, to_date, amount, etc]
SELECT * FROM user_activities u
JOIN income_and_expenditure ine ON u.fk_user_activities_ine_id = ine.id;

-- Directly via income_and_expenditure table
-- You can also filter and sort by date_incurred
SELECT * from income_and_expenditure WHERE fk_ine_user_id =1;

-- Get a user's farm's income / expenses
SELECT id from farms WHERE fk_farms_user_id = 1;

SELECT * from income_and_expenditure WHERE fk_ine_farm_id = 1;

-- ================================================================================

-- USER STUFF

-- login Query 
select password from users where full_name = "Admin" and active = true;

-- create user
INSERT INTO users(admin, full_name, password, email, phone, nrc) values(false, "test_user_1","11111111" ,'test_user_1@gmail.com', '09989993774', '12oktn19201'); -- passwords should be hashed in production

-- change password
UPDATE users set password = "22222222" where id = 3;

-- change other parameters
update users set email="test@testmail.com",phone="+95966636965",nrc="test_nrc" where id = 1;

-- give user admin auths (ADMIN OPERATION)
UPDATE users set admin=true where id = 2;

-- delete user (deleting user is not recommended. use inactive instead)
UPDATE users set active = false where id = 3;

-- reactivate user (ADMIN OPERATION)

UPDATE users set active = true where id = 3;



-- ================================================================================

-- FARM STUFF

-- get a farm from user ID, populated with crops
select farms.id,farms.plot_size,farms.growing_time,farms.longitude1,farms.longitude2,farms.latitude1,farms.latitude2,
                    crops.name,crops.zg_name,crops.unicode_name 
                    from farms inner join crops 
                    on crops.id=farms.fk_farms_crop_id AND farms.fk_farms_user_id=1;

-- create a farm from user id
INSERT INTO farms(continent_name, fk_farms_crop_id, plot_size, fk_farms_user_id) values('Asia', 1, '100 acre', 1);

-- update a farm with farm id
UPDATE farms SET fk_farms_crop_id=2,plot_size="0.6",growing_time="30",continent_name="testName",longitude1="95",longitude2="95.01",
latitude1="15",latitude2="15.01",income_and_expenditure_id=1 where id = 3;

-- delete a farm with farm id
DELETE from farms where id = 3;

-- ================================================================================

-- CROP STUFF

-- get all crops
SELECT * from crops;

-- insert a crop
INSERT INTO crops(name,zg_name,unicode_name)  values('potatoes','အာလူး','အာလူး');

-- update a crop
UPDATE crops set name="Potatoes",zg_name='အာလူး',unicode_name='အာလူး' where id = 3;

-- delete a crop ( not recommended since it would mess up the farm table foreign keys. use update whenever possible)

-- ================================================================================

-- INE STUFF

-- insert a new ine entry
INSERT INTO income_and_expenditure(description, amount, type, quantity, fk_ine_farm_id, fk_ine_user_id) values('Rice Sale', 10000000, 'income', '10 bags', 1, 2);

-- delete an ine entry
delete from income_and_expenditure where id = 5;

-- update an ine entry
-- I think ine entries should not be updated. Just delete and create a new one.

-- select ine by user
select * from income_and_expenditure where fk_ine_user_id = 2;

--select ine by user and month
select * from income_and_expenditure where fk_ine_user_id = 2 and month(created_at) = 11;

-- ==================================================================================
