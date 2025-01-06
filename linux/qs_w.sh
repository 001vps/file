#!/bin/bash
PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:/home/xishan/bin
export PATH
ck()
{
ip=$(curl -sL -4 ip.sb)



hostname=$(hostname)
today=$(date +"%Y-%m-%d_%H:%M:%S")
#data=$(/usr/bin/free -m | grep Mem | awk '{print $3":"$4}')
data=$(df -h | grep -E '^Filesystem|/dev/|default' | awk 'NR==2 {print $2"_"$4}')
loada=$(uptime | awk -F' *,? *' '{print $(NF-2) "_" $(NF-1) "_" $NF "_" $4 "D"}')

url=http://123.haodianxin.cn

# Check if the website is reachable
if curl -s --head $url --max-time 2 | grep "200 OK" &> /dev/null; then
  echo "Website is reachable."
else
  echo "Website is not reachable."

  # Set the url variable to the new value
  url=123.haodianxin.workers.dev
fi

ipinfo="${url}/ip.php/${ip}"
ip=$(curl -sL ${ipinfo})

url2=http://www.baidu.com
code=`curl -o /dev/null -s -m 15 -w %{http_code} $url2`
if [ $code == "200" ]
then
	message="ok"
	urls=${url}"/l.php?s="${message}"--"${hostname}${ip}"--"${loada}"--"${data}"--"${today}"&p=qshuai"
	code=`curl -s -o /dev/null $urls`
	echo "$code";

	echo "$urls";

else
	message="no-ok"
	urls=${url}"/l.php?s="${message}"--"${hostname}"--"${loada}"--"${data}"--"${today}"&p=qshuai"
	code=`curl -s -o /dev/null $urls`
	echo "$code";

	echo "$urls";


fi
}
ck
