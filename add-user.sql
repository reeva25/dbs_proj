Create or replace procedure add_user is
t_user_id users.userid%type;
t_name users.name%type;
t1_Subscription users.SubscriptionType%type;



Begin
SELECT count(userid)+1 INTO t_user_id  FROM users;
t_name := '&user_name' ;
t1_Subscription := 'sub_type' ;

insert into users values(t_user_id,t_name,t1_Subscription);

moneyreceived('SUBSCRIPTION');

exception
 WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Error: USER with ID ' || t_user_id || ' already exists.');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


Create or replace trigger user_subscription_dues 
After insert on users
For each row
Declare
p_DueID  Dues.DueID%TYPE;
p_Amount Dues.Amount%TYPE;

Begin     
SELECT count(DueID)+1 INTO p_DueID FROM dues;
SELECT Amount INTO p_amount from subscription where :NEW.SubscriptionType = SubType;
Insert into dues values(p_dueid,p_amount,NULL,'No',sysdate,NULL);
Insert into UsersSubscriptionDues values( :NEW.userid, :NEW.SubscriptionType,p_dueID);
End;
/
