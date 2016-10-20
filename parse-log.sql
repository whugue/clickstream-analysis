
-- Parse Relevant Data from Log Data and Save in new SQLite Table
-- Raw data contains 1 click (e.g. GET request) per line
-- Raw data is in format: [TIMESTAMPP] "GET/click?article_id=[ARTICLE_ID]&user_id=[USER_ID] HTTP/1.0" [STATUS_CODE] [BYTE_SIZE]


CREATE TABLE clicks AS SELECT * FROM (
	SELECT
		CASE
			WHEN SUBSTR(string,5,3)="Jan" THEN SUBSTR(string,9,4)||"-01-"||SUBSTR(string,2,2)||" "||SUBSTR(string,14,8)
			WHEN SUBSTR(string,5,3)="Feb" THEN SUBSTR(string,9,4)||"-02-"||SUBSTR(string,2,2)||" "||SUBSTR(string,14,8)
			WHEN SUBSTR(string,5,3)="Mar" THEN SUBSTR(string,9,4)||"-03-"||SUBSTR(string,2,2)||" "||SUBSTR(string,14,8)
			WHEN SUBSTR(string,5,3)="Apr" THEN SUBSTR(string,9,4)||"-04-"||SUBSTR(string,2,2)||" "||SUBSTR(string,14,8)
		END AS click_date,
		CAST(SUBSTR(string, (INSTR(string, "article_id=")+11), (INSTR(string, "&")-(INSTR(string, "article_id=")+11))) AS INTEGER) AS article_id,
		CAST(SUBSTR(string, (INSTR(string, "user_id=")+8), (INSTR(string, " HTTP/1.1")-(INSTR(string, "user_id=")+8))) AS INTEGER) AS user_id,
		CAST(SUBSTR(string, (INSTR(string, "HTTP/1.1")+10)) AS INTEGER) AS status_code,
		CAST(SUBSTR(string, (INSTR(string, "HTTP/1.1")+14), 4) AS INTEGER) AS byte_size
	FROM rawclicks
	);

SELECT * FROM clicks LIMIT 10;
