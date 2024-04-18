#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"



n=`$PSQL "SELECT COUNT(service_id) FROM services;"`


display_services(){
  echo -e "Hello! Here are all of our services: \n"
  n=`expr $n + 1`
  i=1

  while [ $i -lt $n ]
  do
    service_name=`$PSQL "SELECT name FROM services WHERE service_id=$i;"`
    echo "$i) $service_name"
    i=`expr $i + 1`
  done

 n=`expr $n - 1`
  echo "Please enter a service_id."
  read SERVICE_ID_SELECTED
}

display_services
re='^[0-9]+$'
if ! [[ $SERVICE_ID_SELECTED =~ $re ]];then
  display_services
fi

while  [ $SERVICE_ID_SELECTED -gt $n  ] || [ $SERVICE_ID_SELECTED -lt 1 ] do
  

  display_services
done







echo "please enter your phone number"

read CUSTOMER_PHONE

count1=`$PSQL "SELECT COUNT(phone) FROM customers WHERE phone = '$CUSTOMER_PHONE';"`

if [ $count1 -lt 1 ]; then
  echo " please enter your name."
  read CUSTOMER_NAME
  $PSQL "INSERT INTO customers (phone, name) VALUES( '$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
  
fi

echo "please enter the time of your service"
read SERVICE_TIME
CUSTOMER_ID=`$PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';"`
CUSTOMER_NAME2=`$PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID;"`


$PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED);"
SERVICE_NAME=`$PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;"`
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME2."