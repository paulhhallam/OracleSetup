/*--------------- CREATING THE SYNONYMS ------------- */

DECLARE
    src_schema    VARCHAR2(20) := 'CENTRAL';
    target_schema VARCHAR2(20) := 'CENTRAL_RO';
    CURSOR src_objects IS
      SELECT object_name AS object_name FROM dba_objects WHERE owner = src_schema and object_type in ('TABLE','VIEW');
BEGIN
    FOR next_row IN src_objects LOOP
        BEGIN
            EXECUTE IMMEDIATE 'CREATE or REPLACE SYNONYM '|| target_schema|| '.'
            ||
            next_row.object_name|| ' for '|| src_schema|| '.'||
            next_row.object_name;
        EXCEPTION
            WHEN OTHERS THEN
              dbms_output.Put_line('ERROR WHILE CREATING SYNONYM FOR: '
                                   || next_row.object_name);
              dbms_output.Put_line(SQLERRM);
        END;
    END LOOP;
END;
/

/*--------------- GRANTING THE PERMISSIONS ------------- */

DECLARE
       src_schema VARCHAR2(20) := 'CENTRAL';
       target_schema VARCHAR2(20) := 'CENTRAL_RO';
        CURSOR src_tab_view IS SELECT object_name AS table_name FROM dba_objects WHERE  owner = src_schema and object_type in ('TABLE' , 'VIEW');
BEGIN
    FOR next_row IN src_tab_view LOOP
        BEGIN
            EXECUTE IMMEDIATE 'GRANT SELECT ON '||src_schema|| '.' ||next_row.table_name|| ' to '|| target_schema;
        EXCEPTION
            WHEN OTHERS THEN
              dbms_output.Put_line('ERROR WHILE GRANTING PERMISSIONS FOR: '|| next_row.table_name);
              dbms_output.Put_line(SQLERRM);
        END;
END LOOP;
END;
/
