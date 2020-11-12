SET sql_mode = '';

DROP TABLE IF EXISTS `user_activities`;
DROP TABLE IF EXISTS `income_and_expenditure`;
DROP TABLE IF EXISTS `services_and_products`;
DROP TABLE IF EXISTS `farm_economics`;
DROP TABLE IF EXISTS `farms`;
DROP TABLE IF EXISTS `crops`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `weather_stations`;

CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `active` boolean DEFAULT TRUE,
  `admin` boolean,
  `full_name` varchar(255),
  `email` varchar(255),
  `phone` varchar(255),
  `nrc` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `farms` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fk_farms_user_id` int NOT NULL,
  `crop_name` varchar(255),
  `plot_size` varchar(255),
  `growing_time` varchar(255), -- not sure about this one. Should it belong to farm_economics?
  `continent_name` varchar(255),
  `longitude` varchar(255),
  `latitude` varchar(255),
  `income_and_expenditure_id` int,
  `created_at` timestamp,
  CONSTRAINT fk_farms_user_id
  FOREIGN KEY (fk_farms_user_id) 
  REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE `services_and_products` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `type` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `income_and_expenditure` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fk_ine_farm_id` int, -- we want to track expenses by farm
  `fk_ine_user_id` int, -- we want to track expense by user and quickly query these
  `type` varchar(255),
  `description` varchar(255),
  `amount` varchar(255),
  `quantity` varchar(255),
  `date_incurred` timestamp,
  `created_at` timestamp,
  CONSTRAINT fk_ine_farm
  FOREIGN KEY (fk_ine_farm_id) 
  REFERENCES farms(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_ine_user
  FOREIGN KEY (fk_ine_user_id) 
  REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- The main purpose of this table is to keep track of a user's expenses and usage of services & products
-- and to provide time series and historical reports
-- activity_name can be customized
-- the activity can be tied to income, expenses, services, or products
CREATE TABLE `user_activities` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fk_user_activities_user_id` int NOT NULL,
  `fk_user_activities_snp_id` int NULL, -- this is for time series of service & product usage
  `fk_user_activities_ine_id` int NULL, -- this is for time series of expenses
  `activity_name` varchar(255),
  `from_date` timestamp,
  `to_date` timestamp,
  `created_at` timestamp,
  CONSTRAINT fk_user_activities_user
  FOREIGN KEY (fk_user_activities_user_id) 
  REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_user_activities_snp
  FOREIGN KEY (fk_user_activities_snp_id) 
  REFERENCES services_and_products(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_user_activities_ine
  FOREIGN KEY (fk_user_activities_ine_id) 
  REFERENCES income_and_expenditure(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- Not used. May need modification
CREATE TABLE `crops` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `unicode_name` varchar(255),
  `zg_name` varchar(255),
  `created_at` timestamp
);

-- Not used. May need modification
CREATE TABLE `farm_economics` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `farm_id` int,
  `moisture_percent` varchar(255),
  `recorded_date` timestamp,
  `recorded_time` varchar(255),
  `recorded_person` varchar(255),
  `recorded_method` varchar(255),
  `sell_price` varchar(255),
  `market_price` varchar(255),
  `created_at` timestamp
);


CREATE TABLE `weather_stations` (
	`id` int PRIMARY KEY AUTO_INCREMENT,
	`user_id` int,
	`longitude` varchar(255),
	`latitude` varchar(255),
    constraint fk_user_id_in_weather_stations
    foreign key(user_id)
    references users(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


-- Populate users
INSERT INTO users(admin, full_name, email, phone, nrc) values(true, "Admin", 'admin@aeg.com', '09989993774', '12oktn19201');
INSERT INTO users(admin, full_name, email, phone, nrc) values(false, "User", 'user@aeg.com', '09989993775', '12oktn19201');

-- Populate Services & Products
INSERT INTO services_and_products(name, type)  values('Tractor', 'service');
INSERT INTO services_and_products(name, type)  values('Seeds', 'product');


-- Add farm to user
INSERT INTO farms(continent_name, crop_name, plot_size, fk_farms_user_id) values('Asia', 'rice', '100 acre', 1);
INSERT INTO farms(continent_name, crop_name, plot_size, fk_farms_user_id) values('Asia', 'potato', '100 acre', 2);

-- Add income / expense to user
INSERT INTO income_and_expenditure(description, amount, type, quantity, fk_ine_farm_id, fk_ine_user_id) values('Rice Sale', '10 lakhs', 'income', '10 bags', 1, 1);
INSERT INTO income_and_expenditure(description, amount, type, quantity, fk_ine_farm_id, fk_ine_user_id) values('Utility Bill', '1.5 lakhs', 'expense', '500 kW', 1, 1);
INSERT INTO income_and_expenditure(description, amount, type, quantity, fk_ine_farm_id, fk_ine_user_id) values('Potato Sale', '10 lakhs', 'income', '10 bags', 2, 2);
INSERT INTO income_and_expenditure(description, amount, type, quantity, fk_ine_farm_id, fk_ine_user_id) values('Utility Bill', '2.5 lakhs', 'expense', '1000 kW', 2, 2);

-- Add user activity
INSERT INTO user_activities(activity_name, from_date, to_date, fk_user_activities_user_id, fk_user_activities_snp_id) values('Tractor Rental', '2020-06-01 00:00:01', '2020-12-31 23:59:00', 1, 1);
INSERT INTO user_activities(activity_name, from_date, to_date, fk_user_activities_user_id, fk_user_activities_snp_id) values('Tractor Rental', '2020-06-01 00:00:01', '2020-12-31 23:59:00', 2, 1);
INSERT INTO user_activities(activity_name, from_date, fk_user_activities_user_id, fk_user_activities_ine_id) values('Sold Rice', '2020-11-01 00:00:01', 1, 1);
INSERT INTO user_activities(activity_name, from_date, fk_user_activities_user_id, fk_user_activities_ine_id) values('Utility Bill', '2020-10-01 00:00:01', 1, 2);
INSERT INTO user_activities(activity_name, from_date, fk_user_activities_user_id, fk_user_activities_ine_id) values('Sold Rice', '2020-10-01 00:00:01', 1, 2);

-- populating weather_station table
INSERT INTO weather_stations(user_id,latitude,longitude) values(1,"16.84","96.17");
INSERT INTO weather_stations(user_id,latitude,longitude) values(2,"16.85","96.18");

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