WHENEVER SQLERROR EXIT SQL.SQLCODE

CREATE INDEX APP_TABLE_IDX001
  ON C##TMP_USER.APP_TABLE (CREATED_DATE)