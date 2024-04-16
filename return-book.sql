create or replace procedure return_book(borrid borrow.borrowid%type,p_method Dues.Method%TYPE) is

bid book.bookid%type;
invid inventory.inventoryno%type;
Flag int;
p_DueID  Dues.DueID%TYPE;
diff int;
fine int;


cursor c(borrid borrow.borrowid%type) is select * from borrow where borrowid=borrid;

begin

Flag := 0;

select bookid into bid from borrow where borrowid=borrid;

select inventoryid into invid from borrow where borrowid=borrid;


for item in c(borrid) loop

if sysdate> item.returndate then 

FLAG := 1;

SELECT count(dueid)+1 INTO p_DueID FROM dues; 

diff := item.borrowdate-item.returndate;

fine := diff*50;

insert into dues values 
(p_dueid,fine,NULL,'No',sysdate,NULL);

insert into borrow_dues values
(item.borrowid, p_dueid);

moneyreceived('FINE',borrid,p_method);

end if;
End loop;

If flag=0 then
update book set AvailableQty= AvailableQty+1 where bookid=bid;

update inventory set available='YES' where bookid=bid and inventoryno=invid;
update borrow set status='received' where bookid=bid and borrowid=borrid;
End if;

end;
/
