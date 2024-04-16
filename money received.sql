
Create or replace procedure moneyreceived(purpose varchar2, id users.UserID%type, p_method Dues.Method%TYPE) As

did dues.dueid%type;


bid book.bookid%type;
invid borrow.inventoryid%type;

Begin 


If purpose='SUBSCRIPTION' then
Select dueid into did from UsersSubscriptionDues where usersid=id;
Update dues set DateOfReceipt=sysdate where dueid=did;
Update dues set Paid ='YES' where dueid=did;
Update dues set method=p_method where dueid=did;

ELSE

Select duesid into did from borrow_dues where borrowid=id;
select bookid into bid from borrow where borrowid=id;

select inventoryid into invid from borrow where borrowid=id;



update dues set 
dateOfReceipt=sysdate where dueid=did;

Update dues set Paid ='YES' where dueid=did;

update dues set method=p_method where dueid=did;

update book set AvailableQty= AvailableQty+1 where bookid=bid;

update inventory set available='YES' where bookid=bid and inventoryno=invid;


end if;

End;
/
