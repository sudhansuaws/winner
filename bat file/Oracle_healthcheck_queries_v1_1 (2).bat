@echo off
setlocal EnableDelayedExpansion

:FDATE
set "fdate="
set /p fdate="enter from-date(dd-mm-yyyy):"
if defined fdate (
  echo !fdate! | findstr /R "^[0123][0123456789]-[01][0123456789]-[23456789][0123456789][0123456789][0123456789]" >nul && echo Accepted && GOTO :TDATE || echo Incorrect date format && GOTO :FDATE
)



:TDATE
echo from date is %fdate% 
set yy=%fdate:~-4%
set mm=%fdate:~-7,2%
set dd=%fdate:~-10,2%
set fdate=%mm%-%dd%-%yy%

set "tdate="
set /p tdate="enter to-date(dd-mm-yyyy):"
if defined tdate (
  echo !tdate! | findstr /R "^[0123][0123456789]-[01][0123456789]-[23456789][0123456789][0123456789][0123456789]" >nul && echo Accepted || echo Incorrect date format && GOTO :TDATE
)
set yy=%tdate:~-4%
set mm=%tdate:~-7,2%
set dd=%tdate:~-10,2%
set tdate=%mm%-%dd%-%yy%

:Formatted date mm-dd-yy
set yy=%date:~-4%
set mm=%date:~-7,2%
set dd=%date:~-10,2%
set Cur_date=%mm%-%dd%-%yy%

:Day count-lower limit
echo Wscript.Echo #%Cur_date%# - #%fdate%# >tmp.vbs
for /f %%a in ('cscript /nologo tmp.vbs') do set "Llimit=%%a"
del tmp.vbs
echo The lower limit from %fdate% until %date% is %Llimit%

:Day count-upper limit
echo Wscript.Echo #%Cur_date%# - #%tdate%# >tmp.vbs
for /f %%a in ('cscript /nologo tmp.vbs') do set "Ulimit=%%a"
del tmp.vbs
echo The upper limit from %tdate% until %date% is %Ulimit%

:Work_ID
set "wid="
set /p wid="enter Work_ID:"

echo work_id is %wid%


:loop
ECHO Start of Loop

ECHO CONFIGURATION SHEET
@echo CONFIGURATION SHEET > Oracle_healthcheck_queries_v1_1.txt
@echo --Workers, Online Workers, Bulk Workers count>> Oracle_healthcheck_queries_v1_1.txt
@echo GOTO ../..\Installation\PrimeMatchManager\prop\dbprop\configcustomer.PROPERTIES >> Oracle_healthcheck_queries_v1_1.txt

@echo --Doers count^(Query^)>> Oracle_healthcheck_queries_v1_1.txt
@echo select * from orp_configs where upper^(orpkey^) like '%%DOER%%'; >> Oracle_healthcheck_queries_v1_1.txt

@echo --RAM Allocation>> Oracle_healthcheck_queries_v1_1.txt
@echo GOTO ../..\Installation\bin\services.properties >> Oracle_healthcheck_queries_v1_1.txt

@echo --Database Settings^(Query^) >> Oracle_healthcheck_queries_v1_1.txt
@echo show parameters; >> Oracle_healthcheck_queries_v1_1.txt

@echo --Primematch Rules, Setmatch Rules and Cluster Rules can be found in front-end >> Oracle_healthcheck_queries_v1_1.txt


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO STORAGE DETAILS SHEET
@echo STORAGE DETAILS SHEET >> Oracle_healthcheck_queries_v1_1.txt
@echo --HDD Storage Details >> Oracle_healthcheck_queries_v1_1.txt
@echo In windows, get the details of the drive which Dedupe is installed; >> Oracle_healthcheck_queries_v1_1.txt
@echo In linux, execute below command in putty or terminal; >> Oracle_healthcheck_queries_v1_1.txt
@echo df -kh >> Oracle_healthcheck_queries_v1_1.txt

@echo --PM Object Size^(get the size of cachebean file in below location^) >> Oracle_healthcheck_queries_v1_1.txt
@echo GOTO ../..\Installation\PrimeMatchManager\objects\customer_objects\ >> Oracle_healthcheck_queries_v1_1.txt

@echo --Objects Defragmentation Status^(query^) >> Oracle_healthcheck_queries_v1_1.txt
@echo select count ^(^*^) from p_cdap_app where col12='0'; >> Oracle_healthcheck_queries_v1_1.txt
@echo OR  >> Oracle_healthcheck_queries_v1_1.txt
@echo select count ^(^*^) from p_cdap_app where col12=0; >> Oracle_healthcheck_queries_v1_1.txt

@echo --DBA_USER TABLE DETAILS^(query^) >> Oracle_healthcheck_queries_v1_1.txt
@echo     select ^* from dba^_users where username in ^(select table_owner from user_indexes where table_name=^'PSX_CUST_DG_BULK_TRG_T^'^); >> Oracle_healthcheck_queries_v1_1.txt

@echo --TABLESPACE DETAILS^(query^) >> Oracle_healthcheck_queries_v1_1.txt
@echo SELECT DF^.TABLESPACE_NAME ^"Tablespace Name^", tu^.TOTALSPACE ^"Used MB^",^(DF^.TOTALSPACE ^- TU^.TOTALSPACE^) ^"Free MB^",DF^.TOTALSPACE ^"Total MB^",ROUND^(100^*^(^(DF^.TOTALSPACE ^- TU^.TOTALSPACE^)/DF^.TOTALSPACE^)^) ^"Pct^.Free^" FROM ^(SELECT TABLESPACE^_NAME, ROUND^(SUM^(BYTES^)/^(1024^*1024^)^) TOTALSPACE FROM DBA^_DATA^_FILES group by tablespace_name^) df, ^(SELECT TABLESPACE^_NAME, ROUND^(SUM^(BYTES^)/^(1024^*1024^)^) TOTALSPACE FROM DBA^_SEGMENTS GROUP BY TABLESPACE_NAME^) TU WHERE DF^.TABLESPACE^_NAME^=TU^.TABLESPACE^_NAME; >> Oracle_healthcheck_queries_v1_1.txt

@echo --DATABASE PROPERTIES >> Oracle_healthcheck_queries_v1_1.txt
@echo select * from DATABASE^_PROPERTIES where PROPERTY^_NAME like '%%DEFAULT%%'; >> Oracle_healthcheck_queries_v1_1.txt

@echo --TABLE INDEX DETAILS >> Oracle_healthcheck_queries_v1_1.txt
@echo select table_name,INDEX_NAME,INDEX_TYPE,LAST^_ANALYZED from USER^_INDEXES order by LAST^_ANALYZED; >> Oracle_healthcheck_queries_v1_1.txt


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO DATA VOLUMES SHEET
@echo DATA VOLUMES SHEET >> Oracle_healthcheck_queries_v1_1.txt
@echo --Base Volumes(Query) >> Oracle_healthcheck_queries_v1_1.txt
@echo select ^'psx^_cust^_dg^_stg^_t' as ^"table name^",count^(^*^) from psx^_cust^_dg^_stg^_t union all select ^'psx^_cust^_addr^_stg^_t^',count^(^*^) from psx^_cust^_addr^_stg^_t union all select ^'psx^_cust^_contact^_stg^_t^',count^(^*^) from psx^_cust^_contact^_stg^_t union all select ^'psx^_cust^_dg^_bulk^_trg^_t^',count^(^*^) from psx^_cust^_dg^_bulk^_trg^_t union all select ^'psx^_cust^_addr^_bulk^_trg^_t^',count^(^*^) from psx^_cust^_addr^_bulk^_trg^_t union all select ^'psx^_cust^_contact^_bulk^_trg^_t^',count^(^*^) from psx^_cust^_contact^_bulk^_trg^_t union all select ^'psx^_request^_t^',count^(^*^) from psx^_request^_t  union all select ^'psx^_cust^_dg^_req^_t^',count^(^*^) from psx^_cust^_dg^_req^_t union all select ^'psx^_cust^_addr^_req^_t^',count^(^*^) from psx^_cust^_addr^_req^_t union all select ^'psx^_cust^_contact^_req^_t^',count^(^*^) from psx^_cust^_contact^_req^_t union all select ^'p^_cdap^_app^',count^(^*^) from p^_cdap^_app union all select ^'p^_cdap^_primematch^_online^',count^(^*^) from p^_cdap^_primematch^_online union all select ^'psx^_results^',count^(^*^) from psx^_results; >> Oracle_healthcheck_queries_v1_1.txt

@echo --Year Wise Data Growth Details(Query) >> Oracle_healthcheck_queries_v1_1.txt
@echo select to^_char^(lchg_time, ^'YYYY^'^),count^(^*^) from psx^_cust^_dg^_bulk^_trg^_t group by to^_char^(lchg^_time,^'YYYY^'^); >> Oracle_healthcheck_queries_v1_1.txt

@echo --Source System Wise Count Details In Base(Query) >> Oracle_healthcheck_queries_v1_1.txt
@echo select count^(^*^), feed^_sys^_id from psx^_cust^_dg^_bulk^_trg^_t group by feed^_sys^_id; >> Oracle_healthcheck_queries_v1_1.txt
@echo OR >> Oracle_healthcheck_queries_v1_1.txt
@echo select count^(^*^), source^_sys^_id from psx^_cust^_dg^_bulk^_trg^_t group by source^_sys^_id; >> Oracle_healthcheck_queries_v1_1.txt


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO EOD DATA COUNTS SHEET
@echo EOD DATA COUNTS SHEET >> Oracle_healthcheck_queries_v1_1.txt

@echo --Premerge ^& Postmerge counts >> Oracle_healthcheck_queries_v1_1.txt
@echo  Paste the contents of below file to a spreadsheet >> Oracle_healthcheck_queries_v1_1.txt
@echo  GOTO ../..\Installation\PrimeMatchManager\objects\customer_objects\cachestats >> Oracle_healthcheck_queries_v1_1.txt

@echo --EOD Data,Updates,Deletes(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select (select count(1) from psxids_dt_2_hashing where dui_flag='I' and psx_batch_id in  (select request_id from psx_bpm_process_flow_t where work_id=%wid% and is_final_service='Y' and trunc(log_insert_ts) = trunc(sysdate-%%G)))I, (select count(1) from psxids_dt_2_hashing where dui_flag='CO' and psx_batch_id in  (select request_id from psx_bpm_process_flow_t where work_id=%wid% and is_final_service='Y' and trunc(log_insert_ts) = trunc(sysdate-%%G)))CO, (select count(1) from psxids_dt_2_hashing where dui_flag='D' and psx_batch_id in  (select request_id from psx_bpm_process_flow_t where work_id=%wid% and is_final_service='Y' and trunc(log_insert_ts) = trunc(sysdate-%%G)))D from dual; >> Oracle_healthcheck_queries_v1_1.txt 

@echo --EOD Start_time,End_time,Total_time(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select a^.start_time ,b^.end_time , b^.end_time-a^.start_time from psx_bpm_process_flow_t a join psx_bpm_process_flow_t b on a^.request_id=b^.request_id and a^.current_service_stage='1' and b^.IS_FINAL_SERVICE='Y' and trunc(a^.log_insert_ts)=trunc(sysdate-%%G) and a^.WORK_ID=%wid% order by a^.START_TIME;     >> Oracle_healthcheck_queries_v1_1.txt 


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO EOD TIMINGS SHEET
@echo EOD TIMINGS SHEET >> Oracle_healthcheck_queries_v1_1.txt

@echo --EOD Timings(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select current_service_id ,start_time, end_time, end_time-start_time from psx_bpm_process_flow_t where request_id in (select request_id from psx_bpm_process_flow_t where work_id=%wid% and trunc(log_insert_ts)=trunc(sysdate-%%G) and is_final_Service='Y') order by start_time,PSX_ID; >> Oracle_healthcheck_queries_v1_1.txt 


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO THROUGHPUT SHEET
@echo THROUGHPUT SHEET >> Oracle_healthcheck_queries_v1_1.txt

@echo --95 Percentile(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select req_time from (select row_number() over (order by processed_time) sl ,processed_time/1000 req_time from psx_request_t where processed_time is not null and request_status='C' and trunc(insert_ts)=trunc(sysdate-%%G) order by 2) a where sl in (select round(count(*)*(95/100)) from (select row_number() over (order by processed_time) sl ,processed_time/1000 req_time from psx_request_t where processed_time is not null and request_status='C' and trunc(insert_ts)=trunc(sysdate-%%G) order by 2));   >> Oracle_healthcheck_queries_v1_1.txt 

@echo --Avg Req Processing Time in sec(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select avg^(processed_time/1000^) from psx_request_t where trunc^(insert_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C'; >> Oracle_healthcheck_queries_v1_1.txt 

@echo --Throughput(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO @echo  select (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^<1)PTIME_Less_Then_One_sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=1 and FLOOR(PROCESSED_TIME/1000)^<2)PTIME_BTW_1_and_2_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=2 and FLOOR(PROCESSED_TIME/1000)^<3)PTIME_BTW_2_and_3_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=3 and FLOOR(PROCESSED_TIME/1000)^<4)PTIME_BTW_3_and_4_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=4 and FLOOR(PROCESSED_TIME/1000)^<5)PTIME_BTW_4_and_5_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=5 and FLOOR(PROCESSED_TIME/1000)^<10 )PTIME_BTW_5_and_10_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=10 and FLOOR(PROCESSED_TIME/1000)^<20 )PTIME_BTW_10_and_20_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=20 and FLOOR(PROCESSED_TIME/1000)^<30)PTIME_BTW_20_and_30_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=30 and FLOOR(PROCESSED_TIME/1000)^<60)PTIME_BTW_30_and_60_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=60 and FLOOR(PROCESSED_TIME/1000)^<120)PTIME_BTW_60_and_120_Sec, (SELECT COUNT(*) FROM PSX_REQUEST_T WHERE REQUEST_STATUS='C' AND trunc(insert_ts)=trunc(sysdate-%%G) AND FLOOR(PROCESSED_TIME/1000)^>=120)More_Then_120_Sec from dual; >> Oracle_healthcheck_queries_v1_1.txt 


@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO BENCHMARK SHEET
@echo BENCHMARK SHEET >> Oracle_healthcheck_queries_v1_1.txt

@echo --Benchmark part1(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO (
echo Query1
@echo select max^(cnt^) max_insert from ^(SELECT TO_CHAR^(INSERT_TS,'HH24:mi'^)HOUR, COUNT^(*^) cnt FROM PSX_REQUEST_T WHERE trunc^(insert_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C' group by  TO_CHAR^(INSERT_TS,'HH24:mi'^) order by 2 desc^)^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query1 completed.

echo Query2
@echo select max^(cnt^) max_insert24 from ^(SELECT TO_CHAR^(INSERT_TS,'HH24'^)HOUR, COUNT^(*^) cnt FROM PSX_REQUEST_T WHERE trunc^(insert_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C' group by TO_CHAR^(INSERT_TS,'HH24'^) order by 1^)^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query2 completed.

echo Query3
@echo select max^(cnt^) max_insert from ^(SELECT TO_CHAR^(processed_ts,'HH24:mi'^)HOUR, COUNT^(*^) cnt FROM PSX_REQUEST_T WHERE trunc^(processed_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C' group by TO_CHAR^(processed_ts,'HH24:mi'^) order by 2 desc^)^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query3 completed.

echo Query4
@echo select max^(cnt^) max_insert24 from ^(SELECT TO_CHAR^(processed_ts,'HH24'^)HOUR, COUNT^(*^)cnt FROM PSX_REQUEST_T WHERE trunc^(processed_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C' group by  TO_CHAR^(processed_ts,'HH24'^) order by 1^)^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query4 completed.

echo Query5
@echo select ^'next_line^' from dual^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query5 completed.
)

@echo --Benchmark part2(Query) >> Oracle_healthcheck_queries_v1_1.txt
FOR /L %%G IN (%Llimit%,-1,%Ulimit%) DO (
echo Query1
@echo select count^(1^) from psx_request_t where trunc^(insert_ts^)=trunc^(sysdate-%%G^) and request_status='C'^; >>Oracle_healthcheck_queries_v1_1.txt
echo Query1 completed

echo Query2
@echo select 'min^:^: ^>'^|^|min^(processed_time^)/1000^|^|'sec and max^:^:'^|^|max^(processed_time^)/1000^|^|'SEC' from psx_request_t where trunc^(insert_ts^)=trunc^(sysdate-%%G^) and request_status='C'^; >>Oracle_healthcheck_queries_v1_1.txt
echo Query2 completed

echo Query3
@echo select cnt ^|^| '^('^|^|match_type^|^|'^)' from ^(select count^(*^)cnt, match_type from psx_results where srccol11 in ^(select psx_id from psx_request_t where trunc^(insert_ts^)=trunc^(sysdate-%%G^) and request_status='C'^)  group by match_type order by 1 desc^) where rownum =1^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query3 completed

echo Query4
@echo select 'psx_id^: '^|^|psx_id^|^| '  Max_match_count:' ^|^|cnt from  ^(select match_count cnt, psx_id from psx_request_t where trunc^(insert_ts^)=trunc^(sysdate-%%G^) and request_status='C' order by 1 desc^) where rownum=1^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query4 completed

echo Query5
@echo select 'Peak Hour^: '^|^|Hour from ^(SELECT TO_CHAR^(INSERT_TS,'HH24'^)HOUR, COUNT^(*^)Insert_Time_Per_Hour FROM PSX_REQUEST_T WHERE trunc^(insert_ts^)=trunc^(sysdate-%%G^) and REQUEST_STATUS='C' group by  TO_CHAR^(INSERT_TS,'HH24'^) order by 2 desc^) where rownum ^<4^;>>Oracle_healthcheck_queries_v1_1.txt
echo Query5 completed

echo Query6
@echo select 'next_line' from dual^; >>Oracle_healthcheck_queries_v1_1.txt
echo Query6 completed
)



@echo. >> Oracle_healthcheck_queries_v1_1.txt
@echo. >> Oracle_healthcheck_queries_v1_1.txt


ECHO DEFRAGMENTATION DETAILS SHEET
@echo DEFRAGMENTATION DETAILS SHEET >> Oracle_healthcheck_queries_v1_1.txt

@echo --Fragmentation Query>> Oracle_healthcheck_queries_v1_1.txt
@echo   select owner,table_name,blocks,num_rows,avg_row_len,round(((blocks*8/1024)),2)^|^|'MB' ^"TOTAL_SIZE^", round((num_rows*avg_row_len/1024/1024),2)^|^|'Mb' ^"ACTUAL_SIZE^", round(((blocks*8/1024)-(num_rows*avg_row_len/1024/1024)),2) ^|^|'MB' ^"FRAGMENTED_SPACE^", round((((blocks*8/1024)-(num_rows*avg_row_len/1024/1024))/((blocks*8/1024)))*100,2) ^"FRAGMENTATIO_PERCENTAGE^" from dba_tables where owner in(select distinct table_owner from user_indexes where table_name ='PSX_CUST_DG_BULK_TRG_T') and round(((blocks*8/1024)-(num_rows*avg_row_len/1024/1024)),2)^> 100 order by 9 desc; >>Oracle_healthcheck_queries_v1_1.txt
@echo --Temp Tablespace Query>> Oracle_healthcheck_queries_v1_1.txt
@echo   select ^'Temp^',sum^(bytes_used^/1024^/1024^/1024^) used_gb,sum^(bytes_free^/1024^/1024^/1024^) free_gb from V$temp_space_header; >>Oracle_healthcheck_queries_v1_1.txt
@echo --Fragmentation Query without sys privilege>> Oracle_healthcheck_queries_v1_1.txt
@echo   SELECT TABLE_NAME,BLOCKS,NUM_ROWS,AVG_ROW_LEN,ROUND(((BLOCKS*8/1024)),2)^|^|'MB' ^"TOTAL_SIZE^", ROUND((NUM_ROWS*AVG_ROW_LEN/1024/1024),2)^|^|'Mb' ^"ACTUAL_SIZE^", ROUND(((BLOCKS*8/1024)-(NUM_ROWS*AVG_ROW_LEN/1024/1024)),2)^"FRAGMENTED_SPACE^" ,round(ROUND(((BLOCKS*8/1024)-(NUM_ROWS*AVG_ROW_LEN/1024/1024)),2)/ROUND(((BLOCKS*8/1024)),2) *100,2) fragmentated_per  FROM  USER_TABLES  WHERE ROUND(((BLOCKS*8/1024)-(NUM_ROWS*AVG_ROW_LEN/1024/1024)),2) ^> 100 ORDER BY 8 DESC; >>Oracle_healthcheck_queries_v1_1.txt





ECHO Completed...



PAUSE