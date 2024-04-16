create or replace procedure borrow_book as
bookname BOOK.title%type;
usid users.userid%type;
bid book.bookid%type;
borr borrow.borrowid%type;
Stype subscription.subtype%type;

flag int;

cursor c(bid book.bookid%type) is select * from inventory where bookid=bid;

begin
flag := 0;
bookname := 'BOOKNAME';
usid := 'USERID';

select bookid into bid from book where title=bookname;

for item in c(bid) loop
if item.available='YES' then 
    flag :=1;
	update inventory set available='NO' where bookid=item.bookid and InventoryNo=item.InventoryNo;

update book set AvailableQty= AvailableQty-1 where bookid=item.bookid;

	select count(borrowid)+1 into borr from borrow;	
	select subtype into stype from UsersSubscriptionDues where usersid=usid;
	if stype='GOLD' then
		insert into borrow values( borr, SYSDATE, SYSDATE + INTERVAL '15' DAY, item.InventoryNo,item.bookid,usid,'borrowed');
	elsif stype='SILVER' then
		insert into borrow values( borr, SYSDATE, SYSDATE + INTERVAL '10' DAY, item.InventoryNo,item.bookid,usid,'borrowed');
	elsif stype='PLATINUM' then
		insert into borrow values( borr, SYSDATE, SYSDATE + INTERVAL '25' DAY, item.InventoryNo,item.bookid,usid,'borrowed');
	end if;
	EXIT;
END IF;
end loop;

if flag=0 then
    dbms_output.put_line('book unavailable');
end if;
END;
/

set serveroutput on;
begin
    borrow_book;
end;
/
select * from inventory;
select * from borrow;
