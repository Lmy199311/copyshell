if [ $# -lt 1]
then
	echo $0 user/password@sid
	exit
fi

sqlplus $1 <<!
sqldeclare
  l_TradingDay ExchangeAdmin.t_ExchangeStatus.TradingDay%type;
  l_Owner      dba_tables.owner%type;
  l_TableName  dba_tables.table_name%type;
  cursor c_TableHasTradingDay is
    select distinct owner,table_name 
    from dba_tables a
    where exists (select *
                  from dba_tab_cols b
                  where a.owner = b.owner
                  and   a.table_name = b.table_name
                  and   b.column_name = 'TRADINGDAY')
    and owner in ('CURRSETTLEMENT','CURRFORCECLOSE','CURRSGOPERATION','CURRSGSNAPSHOT','EXCHANGEADMIN','SYNC')
    and a.table_name not like 'TMP_%'
    and a.table_name not like 'T_HIS%'
    order by owner;

  cursor c_operationTables is
  	SELECT table_name
  	from dba_tables
  	where owner = 'CURRSGOPERATION';
begin
	select MAX(TradingDay)
	into l_TradingDay
	from ExchangeAdmin.t_HistoryTradingDay
	where TradingDay < (select tradingday from exchangeadmin.t_exchangestatus);
	
	delete from ExchangeAdmin.t_historybulletin where tradingday > l_TradingDay;
	delete from ExchangeAdmin.t_historyoperationlog where tradingday > l_TradingDay;
	delete from ExchangeAdmin.t_historysettlementsession where tradingday > l_TradingDay;
	delete from ExchangeAdmin.t_historytradingday where tradingday > l_TradingDay;

	open  c_TableHasTradingDay;
	loop
		fetch c_TableHasTradingDay into l_Owner,l_TableName;
		exit when c_TableHasTradingDay%notfound;
		execute 'update ' || trim(l_Owner) || '.' || trim(l_TableName) || ' set TradingDay=''' || trim(l_TradingDay) || ''';');
	end loop;
	close c_TableHasTradingDay;
	
	open c_operationTables;
	loop
	  fetch c_operationTables into l_TableName;
		exit when c_operationTables%notfound;
		execute 'insert into CurrSgOperation.' || l_TableName || ' select * from HistorySettlement.' || l_TableName || ' where TradingDay = ''' || l_TradingDay || ''';';
	end loop;
	close c_operationTables;

	UPDATE CurrSettlement.t_sys_status set status = '11';
	
	commit;
end;
!
