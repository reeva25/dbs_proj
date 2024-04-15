create or replace procedure borrow_book as
bookname BOOK.title%type;
usid users.userid%type;
bid book.bookid%type;
borr borrow.borrowid%type;

cursor c(bid book.bookid%type) is select * from inventory where bookid=bid;

begin

bookname := 'BOOKNAME';
usid := 'USERID';

select bookid into bid from book where title=bookname;

for item in c(bid) loop
if item.available='YES' then 
	update inventory set available='NO' where bookid=item.bookid and InventoryNo=item.InventoryNo;

update book set AvailableQty= AvailableQty-1 where bookid=item.bookid;

	select count(borrowid)+1 into borr from borrow;	

	insert into borrow values( borr, SYSDATE, SYSDATE + INTERVAL '15' DAY, item.InventoryNo,item.bookid,usid,NULL);
	EXIT;
END IF;
end loop;
END;
/
