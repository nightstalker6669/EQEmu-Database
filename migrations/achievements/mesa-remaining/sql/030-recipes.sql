-- Researched Mesa recipe migration.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _mesa_recipes_guard;
CREATE TEMPORARY TABLE _mesa_recipes_guard(label VARCHAR(100)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _mesa_recipes_guard VALUES('explicit_review',COALESCE(@mesa_remaining_recipes_reviewed,0)=1);
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_0',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041001 AND NOT(name='Liviu''s Dark Stout' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_1',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=87167 AND recipe_id<>3041001)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_2',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041002 AND NOT(name='Liviu''s Finest Brew' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_3',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=87168 AND recipe_id<>3041002)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_4',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041003 AND NOT(name='Tudor''s Aged Merlot' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_5',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=87169 AND recipe_id<>3041003)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_6',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041004 AND NOT(name='Tudor''s Stormwater Whiskey' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_7',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=87170 AND recipe_id<>3041004)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_8',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041005 AND NOT(name='Glowing Green Silver' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_9',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97740 AND recipe_id<>3041005)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_10',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041006 AND NOT(name='Glowing Emerald Pendant' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_11',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97739 AND recipe_id<>3041006)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_12',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041007 AND NOT(name='Spider Silk Filter' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_13',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97745 AND recipe_id<>3041007)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_14',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041008 AND NOT(name='Chilled Pure Water' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_15',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97728 AND recipe_id<>3041008)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_16',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041009 AND NOT(name='Spiced Wind Willow Acorns' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_17',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97744 AND recipe_id<>3041009)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_18',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041010 AND NOT(name='Forest Green Silk Swatch' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_19',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97738 AND recipe_id<>3041010)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_20',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041011 AND NOT(name='Shimmering Dryad Dress' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_21',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97743 AND recipe_id<>3041011)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_22',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041012 AND NOT(name='Envenomed Steel' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_23',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97733 AND recipe_id<>3041012)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_24',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041013 AND NOT(name='Envenomed Steel Blade' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_25',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97734 AND recipe_id<>3041013)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_26',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041014 AND NOT(name='Envenomed Athame' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_27',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97732 AND recipe_id<>3041014)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_28',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041015 AND NOT(name='Fine White Clay' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_29',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97737 AND recipe_id<>3041015)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_30',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041016 AND NOT(name='Unfired Fine Green Perfume Bottle' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_31',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97746 AND recipe_id<>3041016)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_32',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041017 AND NOT(name='Fine Green Perfume Bottle' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_33',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97736 AND recipe_id<>3041017)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_34',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041018 AND NOT(name='Ciodaru''s Gift Box Parts' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_35',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97731 AND recipe_id<>3041018)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_36',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041019 AND NOT(name='Petrified Spider Eyes' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_37',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97741 AND recipe_id<>3041019)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_38',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041020 AND NOT(name='Ciodaru''s Gift Box' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_39',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97729 AND recipe_id<>3041020)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_40',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041021 AND NOT(name='Ciodaru''s Gift Box (sealed)' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_41',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=97730 AND recipe_id<>3041021)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_42',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041022 AND NOT(name='Spider Silk Thread' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_43',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88117 AND recipe_id<>3041022)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_44',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041023 AND NOT(name='Spool of Spider Silk Thread' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_45',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88118 AND recipe_id<>3041023)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_46',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041024 AND NOT(name='Wolf Canine Bead' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_47',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88146 AND recipe_id<>3041024)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_48',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041025 AND NOT(name='Snake Fang Bead' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_49',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88147 AND recipe_id<>3041025)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_50',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041026 AND NOT(name='String of Teeth' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_51',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88148 AND recipe_id<>3041026)));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_52',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe WHERE id=3041027 AND NOT(name='Folded Silkfang Pack' AND notes='May2013 Mesa researched recipe overlay'))));
INSERT INTO _mesa_recipes_guard VALUES('recipe_identity_53',(NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE successcount>0 AND item_id=88112 AND recipe_id<>3041027)));
INSERT INTO _mesa_recipes_guard VALUES('input_output_identities',((SELECT COUNT(*)FROM items WHERE (id=9650 AND Name='Celestial Essence') OR (id=10029 AND Name='Emerald') OR (id=10064 AND Name='Sewing Needle') OR (id=10300 AND Name='Lightstone') OR (id=10468 AND Name='Small Brick of High Quality Ore') OR (id=12089 AND Name='Backpack Pattern') OR (id=13006 AND Name='Water Flask') OR (id=13041 AND Name='Spider Silk') OR (id=13425 AND Name='Spices') OR (id=16482 AND Name='Silk Swatch') OR (id=16486 AND Name='Silk Thread') OR (id=16590 AND Name='Barley') OR (id=16591 AND Name='Hops') OR (id=16595 AND Name='Malt') OR (id=16598 AND Name='Bottle') OR (id=16908 AND Name='High Quality Firing Sheet') OR (id=22075 AND Name='Thin Blade Mold') OR (id=22104 AND Name='Dark Green Dye') OR (id=29355 AND Name='Glaze Lacquer') OR (id=29742 AND Name='Butter') OR (id=51850 AND Name='Spider Fang') OR (id=58280 AND Name='Garlic') OR (id=87151 AND Name='Fresh Mesa Streamwater') OR (id=87154 AND Name='Indigenous Mesa Yeast') OR (id=87157 AND Name='Worn Cask') OR (id=87158 AND Name='Rawhide Canteen') OR (id=87161 AND Name='Griffon Feather Spores') OR (id=87162 AND Name='Dromrek Barbera Grapes') OR (id=87163 AND Name='Tanglewood Seed Pod') OR (id=87164 AND Name='Lingering Dryad Skull') OR (id=87165 AND Name='Goru`kar Oakwood Barrel') OR (id=87166 AND Name='Flask of Mesa Stormwater') OR (id=87167 AND Name='Liviu''s Dark Stout') OR (id=87168 AND Name='Liviu''s Finest Brew') OR (id=87169 AND Name='Tudor''s Aged Merlot') OR (id=87170 AND Name='Tudor''s Stormwater Whiskey') OR (id=88112 AND Name='Folded Silkfang Pack') OR (id=88113 AND Name='Recluse Spider Fang') OR (id=88114 AND Name='Wolf Canine') OR (id=88115 AND Name='Supple Wolf Pelt') OR (id=88117 AND Name='Spider Silk Thread') OR (id=88118 AND Name='Spool of Spider Silk Thread') OR (id=88121 AND Name='Snake Skin') OR (id=88146 AND Name='Wolf Canine Bead') OR (id=88147 AND Name='Snake Fang Bead') OR (id=88148 AND Name='String of Teeth') OR (id=97194 AND Name='Faceted Lightstone') OR (id=97228 AND Name='Earthen Ooze Slime') OR (id=97229 AND Name='Large Snake Fang') OR (id=97230 AND Name='Mesa Recluse Spinneret') OR (id=97231 AND Name='Section of Mesa Snake Pancreas') OR (id=97233 AND Name='Raw Silver') OR (id=97234 AND Name='Recluse Venom Sac') OR (id=97235 AND Name='Spider Eye') OR (id=97236 AND Name='Windwillow Acorn') OR (id=97237 AND Name='Windwillow Branch') OR (id=97728 AND Name='Chilled Pure Water') OR (id=97729 AND Name='Ciodaru''s Gift Box') OR (id=97730 AND Name='Ciodaru''s Gift Box') OR (id=97731 AND Name='Ciodaru''s Gift Box Parts') OR (id=97732 AND Name='Envenomed Athame') OR (id=97733 AND Name='Envenomed Steel') OR (id=97734 AND Name='Envenomed Steel Blade') OR (id=97735 AND Name='Everchilled Flask') OR (id=97736 AND Name='Fine Green Perfume Bottle') OR (id=97737 AND Name='Fine White Clay') OR (id=97738 AND Name='Forest Green Silk Swatch') OR (id=97739 AND Name='Glowing Emerald Pendant') OR (id=97740 AND Name='Glowing Green Silver') OR (id=97741 AND Name='Petrified Spider Eyes') OR (id=97742 AND Name='Pond Water') OR (id=97743 AND Name='Shimmering Dryad Dress') OR (id=97744 AND Name='Spiced Wind Willow Acorns') OR (id=97745 AND Name='Spider Silk Filter') OR (id=97746 AND Name='Unfired Fine Green Perfume Bottle') OR (id=97747 AND Name='Earthen Perfume') OR (id=97753 AND Name='Fine Green Perfume Bottle Sketch'))=77));
START TRANSACTION;
DELETE FROM tradeskill_recipe_entries WHERE recipe_id IN(3041001,3041002,3041003,3041004,3041005,3041006,3041007,3041008,3041009,3041010,3041011,3041012,3041013,3041014,3041015,3041016,3041017,3041018,3041019,3041020,3041021,3041022,3041023,3041024,3041025,3041026,3041027);
DELETE FROM tradeskill_recipe WHERE id IN(3041001,3041002,3041003,3041004,3041005,3041006,3041007,3041008,3041009,3041010,3041011,3041012,3041013,3041014,3041015,3041016,3041017,3041018,3041019,3041020,3041021,3041022,3041023,3041024,3041025,3041026,3041027);
INSERT INTO tradeskill_recipe(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`) VALUES
(3041001,'Liviu''s Dark Stout',65,0,172,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041002,'Liviu''s Finest Brew',65,0,210,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041003,'Tudor''s Aged Merlot',65,0,250,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041004,'Tudor''s Stormwater Whiskey',65,0,290,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041005,'Glowing Green Silver',68,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041006,'Glowing Emerald Pendant',68,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041007,'Spider Silk Filter',61,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041008,'Chilled Pure Water',65,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041009,'Spiced Wind Willow Acorns',60,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041010,'Forest Green Silk Swatch',61,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041011,'Shimmering Dryad Dress',61,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041012,'Envenomed Steel',63,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041013,'Envenomed Steel Blade',63,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041014,'Envenomed Athame',63,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041015,'Fine White Clay',69,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041016,'Unfired Fine Green Perfume Bottle',69,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041017,'Fine Green Perfume Bottle',69,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041018,'Ciodaru''s Gift Box Parts',64,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041019,'Petrified Spider Eyes',68,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041020,'Ciodaru''s Gift Box',64,0,190,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041021,'Ciodaru''s Gift Box (sealed)',75,0,0,1,1,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041022,'Spider Silk Thread',61,0,50,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041023,'Spool of Spider Silk Thread',61,0,50,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041024,'Wolf Canine Bead',61,0,50,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041025,'Snake Fang Bead',61,0,50,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041026,'String of Teeth',61,0,92,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1),
(3041027,'Folded Silkfang Pack',61,0,170,0,0,'May2013 Mesa researched recipe overlay',0,0,0,1,-1,-1);
INSERT INTO tradeskill_recipe_entries(`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3041001,87151,0,0,1,0,0),
(3041001,16591,0,0,1,0,0),
(3041001,87154,0,0,1,0,0),
(3041001,16595,0,0,1,0,0),
(3041001,87167,1,0,0,0,0),
(3041001,19,0,0,0,0,1),
(3041001,17179,0,0,0,0,1),
(3041001,17521,0,0,0,0,1),
(3041002,16590,0,0,1,0,0),
(3041002,16591,0,0,1,0,0),
(3041002,87157,0,0,1,0,0),
(3041002,87158,0,0,1,0,0),
(3041002,87168,1,0,0,0,0),
(3041002,19,0,0,0,0,1),
(3041002,17179,0,0,0,0,1),
(3041002,17521,0,0,0,0,1),
(3041003,16598,0,1,1,0,0),
(3041003,87162,0,0,1,0,0),
(3041003,87161,0,0,1,0,0),
(3041003,13006,0,0,1,0,0),
(3041003,87169,1,0,0,0,0),
(3041003,19,0,0,0,0,1),
(3041003,17179,0,0,0,0,1),
(3041003,17521,0,0,0,0,1),
(3041004,87166,0,0,1,0,0),
(3041004,87165,0,0,1,0,0),
(3041004,87164,0,0,1,0,0),
(3041004,87163,0,0,1,0,0),
(3041004,87170,1,0,0,0,0),
(3041004,19,0,0,0,0,1),
(3041004,17179,0,0,0,0,1),
(3041004,17521,0,0,0,0,1),
(3041005,97233,0,0,1,0,0),
(3041005,10300,0,0,1,0,0),
(3041005,97231,0,0,1,0,0),
(3041005,97740,1,0,0,0,0),
(3041005,20,0,0,0,0,1),
(3041005,17187,0,0,0,0,1),
(3041005,17764,0,0,0,0,1),
(3041005,17912,0,0,0,0,1),
(3041005,62480,0,0,0,0,1),
(3041006,97740,0,0,1,0,0),
(3041006,10029,0,0,1,0,0),
(3041006,97739,1,0,0,0,0),
(3041006,20,0,0,0,0,1),
(3041006,17187,0,0,0,0,1),
(3041006,17764,0,0,0,0,1),
(3041006,17912,0,0,0,0,1),
(3041006,62480,0,0,0,0,1),
(3041007,9650,0,0,1,0,0),
(3041007,97230,0,0,1,0,0),
(3041007,13041,0,0,2,0,0),
(3041007,97745,1,0,0,0,0),
(3041007,16,0,0,0,0,1),
(3041007,17165,0,0,0,0,1),
(3041007,17768,0,0,0,0,1),
(3041007,17863,0,0,0,0,1),
(3041007,17880,0,0,0,0,1),
(3041007,17966,0,0,0,0,1),
(3041008,97735,0,1,1,0,0),
(3041008,97742,0,0,1,0,0),
(3041008,97745,0,0,1,0,0),
(3041008,97728,1,0,0,0,0),
(3041008,19,0,0,0,0,1),
(3041008,17179,0,0,0,0,1),
(3041008,17521,0,0,0,0,1),
(3041009,29742,0,0,1,0,0),
(3041009,97228,0,0,1,0,0),
(3041009,58280,0,0,1,0,0),
(3041009,13425,0,0,1,0,0),
(3041009,97236,0,0,4,0,0),
(3041009,97744,1,0,0,0,0),
(3041009,15,0,0,0,0,1),
(3041010,22104,0,0,1,0,0),
(3041010,16482,0,0,2,0,0),
(3041010,16486,0,0,2,0,0),
(3041010,97738,1,0,0,0,0),
(3041010,16,0,0,0,0,1),
(3041010,17165,0,0,0,0,1),
(3041010,17768,0,0,0,0,1),
(3041010,17863,0,0,0,0,1),
(3041010,17880,0,0,0,0,1),
(3041010,17966,0,0,0,0,1),
(3041011,97738,0,0,1,0,0),
(3041011,97230,0,0,1,0,0),
(3041011,88121,0,0,4,0,0),
(3041011,97743,1,0,0,0,0),
(3041011,16,0,0,0,0,1),
(3041011,17165,0,0,0,0,1),
(3041011,17768,0,0,0,0,1),
(3041011,17863,0,0,0,0,1),
(3041011,17880,0,0,0,0,1),
(3041011,17966,0,0,0,0,1),
(3041012,97228,0,0,1,0,0),
(3041012,97234,0,0,1,0,0),
(3041012,10468,0,0,1,0,0),
(3041012,97733,1,0,0,0,0),
(3041012,17,0,0,0,0,1),
(3041013,97733,0,0,1,0,0),
(3041013,22075,0,0,1,0,0),
(3041013,97734,1,0,0,0,0),
(3041013,17,0,0,0,0,1),
(3041014,97734,0,0,1,0,0),
(3041014,97229,0,0,2,0,0),
(3041014,88121,0,0,1,0,0),
(3041014,97732,1,0,0,0,0),
(3041014,17,0,0,0,0,1),
(3041015,97228,0,0,1,0,0),
(3041015,97230,0,0,1,0,0),
(3041015,51850,0,0,8,0,0),
(3041015,97737,1,0,0,0,0),
(3041015,21,0,0,0,0,1),
(3041016,97194,0,0,1,0,0),
(3041016,97753,0,0,1,0,0),
(3041016,97737,0,0,1,0,0),
(3041016,97746,1,0,0,0,0),
(3041016,21,0,0,0,0,1),
(3041017,29355,0,0,1,0,0),
(3041017,16908,0,0,1,0,0),
(3041017,97746,0,0,1,0,0),
(3041017,97736,1,0,0,0,0),
(3041017,22,0,0,0,0,1),
(3041018,97237,0,0,6,0,0),
(3041018,97731,1,0,0,0,0),
(3041018,18,0,0,0,0,1),
(3041018,17189,0,0,0,0,1),
(3041018,17762,0,0,0,0,1),
(3041018,17910,0,0,0,0,1),
(3041019,97228,0,0,1,0,0),
(3041019,97235,0,0,2,0,0),
(3041019,97741,1,0,0,0,0),
(3041019,20,0,0,0,0,1),
(3041019,17187,0,0,0,0,1),
(3041019,17764,0,0,0,0,1),
(3041019,17912,0,0,0,0,1),
(3041019,62480,0,0,0,0,1),
(3041020,97731,0,0,1,0,0),
(3041020,97229,0,0,4,0,0),
(3041020,97741,0,0,1,0,0),
(3041020,97729,1,0,0,0,0),
(3041020,18,0,0,0,0,1),
(3041020,17189,0,0,0,0,1),
(3041020,17762,0,0,0,0,1),
(3041020,17910,0,0,0,0,1),
(3041021,97728,0,0,1,0,0),
(3041021,97747,0,0,1,0,0),
(3041021,97732,0,0,1,0,0),
(3041021,97739,0,0,1,0,0),
(3041021,97743,0,0,1,0,0),
(3041021,97744,0,0,1,0,0),
(3041021,97730,1,0,0,0,0),
(3041021,97729,0,0,0,0,1),
(3041022,13041,0,0,8,0,0),
(3041022,88117,1,0,0,0,0),
(3041022,16,0,0,0,0,1),
(3041022,17165,0,0,0,0,1),
(3041022,17768,0,0,0,0,1),
(3041022,17863,0,0,0,0,1),
(3041022,17880,0,0,0,0,1),
(3041022,17966,0,0,0,0,1),
(3041023,88113,0,0,1,0,0),
(3041023,88117,0,0,3,0,0),
(3041023,88118,1,0,0,0,0),
(3041023,16,0,0,0,0,1),
(3041023,17165,0,0,0,0,1),
(3041023,17768,0,0,0,0,1),
(3041023,17863,0,0,0,0,1),
(3041023,17880,0,0,0,0,1),
(3041023,17966,0,0,0,0,1),
(3041024,10064,1,1,1,0,0),
(3041024,88114,0,0,1,0,0),
(3041024,88146,1,0,0,0,0),
(3041024,16,0,0,0,0,1),
(3041024,17165,0,0,0,0,1),
(3041024,17768,0,0,0,0,1),
(3041024,17863,0,0,0,0,1),
(3041024,17880,0,0,0,0,1),
(3041024,17966,0,0,0,0,1),
(3041025,10064,1,1,1,0,0),
(3041025,97229,0,0,1,0,0),
(3041025,88147,1,0,0,0,0),
(3041025,16,0,0,0,0,1),
(3041025,17165,0,0,0,0,1),
(3041025,17768,0,0,0,0,1),
(3041025,17863,0,0,0,0,1),
(3041025,17880,0,0,0,0,1),
(3041025,17966,0,0,0,0,1),
(3041026,88147,0,0,5,0,0),
(3041026,88117,0,0,1,0,0),
(3041026,88146,0,0,4,0,0),
(3041026,88148,1,0,0,0,0),
(3041026,16,0,0,0,0,1),
(3041026,17966,0,0,0,0,1),
(3041027,12089,0,0,1,0,0),
(3041027,88118,0,0,1,0,0),
(3041027,88148,0,0,1,0,0),
(3041027,88115,0,0,1,0,0),
(3041027,88112,1,0,0,0,0),
(3041027,16,0,0,0,0,1),
(3041027,17165,0,0,0,0,1),
(3041027,17768,0,0,0,0,1),
(3041027,17863,0,0,0,0,1),
(3041027,17880,0,0,0,0,1),
(3041027,17966,0,0,0,0,1);
COMMIT;
