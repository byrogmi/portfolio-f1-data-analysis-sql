-- Aus welchem Land kommen die meisten Formel 1 Fahrer? 
-- Which Country has the most Formula 1 Drivers?

SELECT
	d.nationality,
	COUNT(*) AS NumberOfDrivers
FROM F1_Project.drivers d
GROUP BY d.nationality
ORDER BY NumberOfDrivers DESC


-- Gibt es Länder, welche nur einen einzigen Formel 1 Fahrer jemals hatten? 
-- Are there any countries that have ever had only one Formula 1 driver?

SELECT
	d.nationality,
	COUNT(*) AS NumberOfDrivers
FROM F1_Project.drivers d
GROUP BY nationality
HAVING NumberOfDrivers = 1


-- Auf welcher Rennstrecke fanden die meisten Rennen statt?
-- Which racetrack hosted the most races?

SELECT
	c.name,
	COUNT(*) AS NumberOfRaces
FROM F1_Project.races r
JOIN F1_Project.circuits c ON r.circuitId = c.circuitId
GROUP BY c.name
ORDER BY NumberOfRaces DESC


-- In welchem Land wurden die meisten Rennen gefahren?
-- In which country were the most races held?
	
SELECT
	c.country,
	COUNT(*) AS NumberOfRaces
FROM F1_Project.races r
JOIN F1_Project.circuits c ON r.circuitId = c.circuitId
GROUP BY c.country
ORDER BY NumberOfRaces DESC


-- Welches Land hat die meisten Rennstrecken?
-- Which country has the most racetracks?

SELECT
	c.country,
	COUNT(*) AS CircuitsInCountry
FROM F1_Project.circuits c
GROUP BY c.country
ORDER BY CircuitsInCountry DESC


-- Länder mit nur einer Rennstrecke
-- Countries with only one racetrack

SELECT
	c.country,
	COUNT(DISTINCT c.name) AS NumberUniqueCircuits
FROM F1_Project.races r
JOIN F1_Project.circuits c ON r.circuitId = c.circuitId
GROUP BY c.country
HAVING NumberUniqueCircuits = 1

-- Position 21 "United States" ist ein fehler in dem Datensatz. Es gibt schon das Land "USA".


-- Welches Team hat die meisten "Rennsiege"? (Team-Erfolg)
-- Which team has the most “race wins”? (Team success)

SELECT
	c.name,
	COUNT(*) AS TeamMostRaceWins
FROM F1_Project.results r
JOIN F1_Project.constructors c ON r.constructorId = c.constructorId
WHERE r.position  = '1'
GROUP BY c.name 
ORDER BY TeamMostRaceWins DESC


-- Welches Team hat die meisten verschiedenen Sieger?
-- Which team has the most different winners?

SELECT
	c.name,
	COUNT(DISTINCT r.driverId) AS MostDifferentWinners
FROM F1_Project.results r
JOIN F1_Project.constructors c ON r.constructorId = c.constructorId
WHERE r.position  = '1'
GROUP BY c.name 
ORDER BY MostDifferentWinners DESC


-- Welcher Fahrer hat für die meisten verschiedenen Teams gewonnen?
-- Which driver has won for the most different teams?

SELECT
	d.forename,
	d.surname,
	COUNT(DISTINCT r.constructorId) AS WinsForDifferentConstructor
FROM F1_Project.results r
JOIN F1_Project.drivers d ON r.driverId = d.driverId
WHERE r.position = 1
GROUP BY d.driverId, d.surname, d.forename
ORDER BY WinsForDifferentConstructor DESC


-- Wer war der älteste Formel 1 Sieger und wie alt war er?
-- Who was the oldest Formula 1 winner, and how old was he?

SELECT 
    d.forename AS Forename, 
    d.surname AS Surname, 
    r.name AS Grand_Prix, 
    c.location AS City,
    c.country AS Country,
    r.date AS Racedate,
    TIMESTAMPDIFF(YEAR, d.dob, r.date) AS Age_at_Victory
FROM F1_Project.results res
JOIN F1_Project.races r ON res.raceId = r.raceId
JOIN F1_Project.drivers d ON res.driverId = d.driverId
JOIN F1_Project.circuits c ON r.circuitId = c.circuitId -- Der neue Join
WHERE res.position = 1
ORDER BY Age_at_Victory DESC
LIMIT 1