--LOOKING AT THE REFEREES AND THE MATCHES THEY OFFICIATED DURING THE COMPETITION.

SELECT *
FROM soccer_country;

SELECT *
FROM referee_mast;

SELECT *
FROM match_mast;

-- inner joining both tables together (soccer_country and referee_mast)

SELECT RF.ID, referee_name, RF.country_id, country_abbr, country_name,
	   match_no, play_stage, results, play_date, goal_score, venue_id,plr_of_match, stop1_sec, stop2_sec
from referee_mast RF
inner join soccer_country SC ON RF.country_id = SC. country_id
inner join match_mast MM ON RF. referee_id = MM.referee_id
ORDER BY country_abbr ASC;


--attempting joint using the parent-child relationship

SELECT RF.ID, referee_name, RF.country_id, country_abbr, country_name,
	   match_no, play_stage, results, play_date, goal_score, venue_id,plr_of_match, stop1_sec, stop2_sec
FROM referee_mast RF,
	 soccer_country SC,
	 match_mast MM
WHERE RF.country_id
	= SC.country_id
AND	  RF. referee_id
	= MM. referee_id;

-- to create new table from the above query for use outside of sql

CREATE TABLE Referee(
ID int, 
referee_name varchar (50),
country_id int,
country_abbr varchar (5), 
country_name varchar (50),
match_no int, play_stage varchar (5), results varchar (10),
play_date datetime, goal_score char (10) , venue_id int,
plr_of_match int, stop1_sec int, stop2_sec int);

INSERT INTO Referee
SELECT RF.ID, referee_name, RF.country_id, country_abbr, country_name,
	   match_no, play_stage, results, play_date, goal_score, venue_id,plr_of_match, stop1_sec, stop2_sec
FROM referee_mast RF,
	 soccer_country SC,
	 match_mast MM
WHERE RF.country_id
	= SC.country_id
AND	  RF. referee_id
	= MM. referee_id;

SELECT *
FROM Referee;

--TO SEE WHAT COUNTRY PRODUCED THE HIGHEST NUMBER OF REFEREE FOR THE COMPETITION.

SELECT country_name, COUNT(country_name) AS No_of_Ref
FROM referee_mast RF
INNER JOIN soccer_country SC
ON RF. country_id = SC . country_id
GROUP BY country_name;


SELECT *
FROM player_booked;

--changing NULLs and Y TO YES OR NO

UPDATE player_booked
SET sent_off= ISNULL (sent_off, 'NO')
FROM player_booked
SELECT sent_off, 
CASE
	 WHEN sent_off = 'Y' THEN 'YES'
	 END 
FROM player_booked
UPDATE player_booked
SET sent_off = 
CASE WHEN sent_off = 'Y' THEN 'YES'
END

SELECT *
FROM player_booked;


SELECT *
FROM soccer_venue SV
INNER JOIN match_mast MM
ON SV. venue_id = MM. venue_id;

--CHANGING PLAY DATE

SELECT *
FROM match_mast;


SELECT play_date, CONVERT (DATE, Play_date) as 'date'
FROM match_mast;

UPDATE match_mast
SET play_date  = CONVERT (DATE, Play_date);


--LOOKING AT GAME VENUES, CAPACITY AND THE AUDENCE PRESENT FOR EACH GAME, CONSIDERING LOGISTICS FOR FUTURE GAMES PREPARATION.

SELECT MM.ID, MM.venue_id, venue_name, aud_capacity, match_no, audence
FROM soccer_venue SV
INNER JOIN match_mast MM
ON MM.venue_id = SV.venue_id;



--to see goals scored within standard 90 min of play

SELECT *
FROM goal_details
WHERE goal_time <= 90;

/*Matches that ended goalless in the group stage*/

SELECT *
FROM match_mast
where play_stage = 'G'
	AND results = 'Draw';

--Matches with narrow victories--

SELECT *
FROM match_mast
WHERE goal_score = '1-0'
	OR	goal_score = '0-1';

--Determining players subbtituition--

SELECT PL.ID, PL.match_no, PL.in_out, PL.time_in_out, 
		MM.play_stage, PM.player_id,PM.jersey_no, 
		PM.player_name, PM.posi_to_play, PM.age, PM.playing_club
FROM player_in_out PL
INNER JOIN match_mast MM ON PL.match_no = MM.match_no
INNER JOIN player_mast PM ON PL.player_id = PM.player_id
ORDER BY MM.match_no ASC;

-- Top 5 Team performance based on goal scored--

SELECT 
TOP 5
ST.ID, SC.country_id, SC.country_name, SC.country_abbr, SUM(won) AS TotWoN,
		SUM(draw) AS Totdraw, SUM(lost) AS Totlost, SUM(goal_for) AS scored, 
		SUM(goal_agnst) AS conceded, SUM(goal_diff) AS diff
FROM Soccer_team ST
INNER JOIN goal_details GD ON ST.team_id = GD.team_id 
INNER JOIN soccer_country SC ON ST.team_id = SC.country_id
GROUP BY ST.ID, SC.country_id,SC.country_name, SC.country_abbr
ORDER BY scored DESC;


--Most utillized venue

SELECT *
FROM soccer_venue SV
INNER JOIN match_mast MM
ON SV.venue_id = MM.venue_id;


SELECT SV.ID, SV.venue_id, venue_name, COUNT(venue_name) AS matchesplayed, 
		AVG(aud_capacity) AS capacity
FROM soccer_venue SV
INNER JOIN match_mast MM
ON SV.venue_id = MM.venue_id
GROUP BY SV.ID,
		 SV.venue_id,
		 venue_name,
		 aud_capacity
ORDER BY matchesplayed DESC;



--TOP GOAL SCORERS--

SELECT *
FROM goal_details GD
INNER JOIN player_mast PM ON GD.player_id = PM.player_id
INNER JOIN soccer_country SC ON PM.team_id = SC.country_id;

SELECT GD.ID, player_name, GD.player_id,
	   country_name, playing_club, COUNT(GD.player_id) AS goals
FROM goal_details GD
INNER JOIN player_mast PM ON GD.player_id = PM.player_id
INNER JOIN soccer_country SC ON PM.team_id = SC.country_id
GROUP BY GD.ID,  
		player_name,
	    country_name, 
		playing_club,
		GD.player_id
ORDER BY goals DESC;
		