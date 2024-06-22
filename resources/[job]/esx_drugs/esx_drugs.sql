USE `essentialmode`;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	
	
	('chemicals', 'Hoá chất thần thánh', 100, 0, 1),
	('chemicalslisence', 'Chemicals license', 1, 0, 1),
	('moneywash', 'MoneyWash License', 1, 0, 1),
	('coca_leaf', 'Lá coca', 400, 0, 1),
	
	('poppyresin', 'Hoa anh túc', 100, 0, 1),
	('heroin', 'Bột mì', 100, 0, 1),
	('lsa', 'LSA', 100, 0, 1),
	('lsd', 'LSD', 100, 0, 1),
	
	('hydrochloric_acid', 'HydroChloric Acid', 100, 0, 1),
	('sodium_hydroxide', 'Sodium Hydroxide', 100, 0, 1),
	('sulfuric_acid', 'Sulfuric Acid', 100, 0, 1),
	('thionyl_chloride', 'Thionyl Chloride', 100, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weed_processing', 'Weed Processing License')
	('chemicalslisence', 'Chemicals license')
;