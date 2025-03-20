-- changed the name of this file, both here and when creating this folder in oracle account
SET ECHO ON
declare
  ret boolean;
  begin
  ret :=dbms_xdb.createfolder('/public/group2m25');
  commit;
end;
/
