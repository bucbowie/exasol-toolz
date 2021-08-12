--Version 1.1 - Improve "LIKE" replace 20200724

WITH FINAL_DISPLAY (FINAL_COMM, FINAL_MODE, FINAL_CNT, FINAL_SQL) AS
(
    --
    -- ROUND_TWO GENERICIZES the SELECT/IN
    --
	WITH ROUND_TWO (R2_COMM, R2_MODE, R2_CNT, R2_SQL) AS
	  (
	    --
	    -- ROUND_ONE GENERICES the SELECT/LIKE
	    --
		WITH ROUND_ONE (R1_COMM, R1_MODE, R1_CNT, R1_SQL) AS 
		(
		    --
		    -- SELECT_ ALL selects and GENERICIZES the SELECT/=
		    --
			WITH ALL_SELECT (ALL_COMM, ALL_MODE, ALL_SQL) AS
			(SELECT 
			 COMMAND_NAME
			,EXECUTION_MODE
			,REGEXP_REPLACE(SQL_TEXT,'(=.?\b\w+[\(a-zA-Z0-9\_)-].+?[\s;\)\z]|=.?(.+|\w+)[\(a-zA-Z0-9_+=%)-]*.+)', '=??? ')
			   FROM EXA_STATISTICS.EXA_DBA_AUDIT_SQL
				WHERE COMMAND_CLASS in ('DQL')
				  and COMMAND_NAME NOT IN ('COMMIT', 'ROLLBACK', 'IMPERSONATE')
				  and SQL_TEXT LIKE ('%SELECT%')
				  and SUBSTR(SQL_TEXT,1,2) NOT = '--' --dont bring back comments
      		 )
			SELECT 
			   ALL_COMM
			  ,ALL_MODE
			  ,COUNT(*)
			  ,ALL_SQL
			FROM ALL_SELECT ASEL
			  --WHERE ALL_SQL LIKE ('%SELECT%=%')
			  WHERE ALL_SQL LIKE ('%SELECT%')
			GROUP BY ALL_SQL
				,ALL_COMM
				,ALL_MODE
				HAVING COUNT(*) > 1
			ORDER BY ALL_SQL
				,ALL_COMM
				,ALL_MODE
			) 
		 SELECT 
		  R1_COMM
		 ,R1_MODE
		 ,R1_CNT
		 ,REGEXP_REPLACE(R1_SQL,'(?i)LIKE.*[- .+\s\(a-zA-Z0-9)\_%)-].*?[\s;\)\z]', 'LIKE ??? ')  FROM ROUND_ONE 
	  )
	SELECT
	  R2_COMM
	 ,R2_MODE
	 ,R2_CNT
	 ,REGEXP_REPLACE(R2_SQL,'[^\w+](?i)IN(.|\(.)+', ' IN ??? ') 
	 FROM ROUND_TWO
	   
	)
SELECT
  FINAL_COMM
 ,FINAL_MODE
 ,FINAL_CNT
 ,FINAL_SQL
 FROM FINAL_DISPLAY
 GROUP BY FINAL_SQL
         ,FINAL_CNT
         ,FINAL_MODE
         ,FINAL_COMM
 ORDER BY FINAL_CNT DESC
         ,FINAL_SQL
         ,FINAL_MODE
         ,FINAL_COMM
 ;