
Create or replace procedure moneyreceived(purpose varchar2)
As


u_id users.userid%type;
did dues.dueid%type;
p_method Dues.Method%TYPE;

bid book.bookid%type;
borrid borrow.borrowid%type;
invid borrow.inventoryid%type;

Begin 

u_id := '&USERID';
p_method := '&paymentmethod';

If purpose='SUBSCRIPTION' then
Select dueid into did from UsersSubscriptionDues where usersid=u_id;
Update dues set DateOfReceipt=sysdate where dueid=did;
Update dues set Paid ='YES' where dueid=did;
Update dues set method=p_method where dueid=did;

ELSE
borrid := '&BORROWID';

Select duesid into did from borrow_dues where borrowid=borrid;
select bookid into bid from borrow where borrowid=borrid;

select inventoryid into invid from borrow where borrowid=borrid;



update dues set 
dateOfReceipt=sysdate where dueid=did;

Update dues set Paid ='YES' where dueid=did;

update dues set method=p_method where dueid=did;

update book set AvailableQty= AvailableQty+1 where bookid=bid;

update inventory set available='YES' where bookid=bid and inventoryno=invid;


end if;

End;
/
