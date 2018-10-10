IF OBJECT_ID('C##TMPUSER.PROC_INSERT_APP', 'P') IS NOT NULL
  DROP PROCEDURE C##TMPUSER.PROC_INSERT_APP;
GO

CREATE PROCEDURE C##TMPUSER.PROC_INSERT_APP (
	@I_APP_ID C##TMPUSER.APP_TABLE.APP_ID, 
	@I_APP_DESCRIPTION VARCHAR(4000) /* Use -meta option C##TMPUSER.APP_TABLE.APP_DESCRIPTION%TYPE */
)
AS
BEGIN
SET NOCOUNT ON;
	
	INSERT INTO C##TMPUSER.APP_TABLE (APP_ID, APP_DESCRIPTION)
	VALUES (@I_APP_ID, @I_APP_DESCRIPTION);

END;