if [ $# -eq 0 ]
then
echo "OrderCount          TradeCount          ClientPostion"
echo "==========          ==========          ============="
grep OrderSize ./Syslog.log |tail -1|awk '{printf "\n%10d",$8}'
grep TradeSize ./Syslog.log |tail -1|awk '{printf "%10s%10d","         ",$8}'
grep ClientPosition ./Syslog.log |tail -1|awk '{printf "%10s%10d\n","          ",$8}'
else
echo "OrderCount          TradeCount          ClientPostion"
echo "==========          ==========          ============="
grep OrderSize /home/PTrade/$1/dump/Syslog.log |tail -1|awk '{printf "\n%10d",$8}'
grep TradeSize /home/PTrade/$1/dump/Syslog.log |tail -1|awk '{printf "%10s%10d","          ",$8}'
grep ClientPosition /home/PTrade/$1/dump/Syslog.log |tail -1|awk '{printf "%10s%10d\n","          ",$8}'
fi
