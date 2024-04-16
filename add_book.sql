
Create or replace procedure add_author(aname author.name%type)  is
	t_auth_id author.authid%type;
	begin
        select count(authid)+1 into t_auth_id from author;
	insert into author values (t_auth_id,aname);
	exception
	  WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Error: Author with ID ' || t_auth_id || ' already exists.');
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;
/

Create or replace procedure add_genre(gname genre.GenreName%type) is
t_gid genre.GenreID%type;
	begin
	select count(genreid)+1 into t_gid from genre;
	insert into genre values (t_gid,gname);
	exception
	  WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Error: Genre with ID ' || t_gid || ' already exists.');
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END;
/
Create or replace procedure add_book(T_TITLE BOOK.TITLE%TYPE,ANAME AUTHOR.NAME%TYPE,GNAME GENRE.GenreName%TYPE) is
	T_BID BOOK.BOOKID%TYPE;
   	T_AUTHID BOOK.AUTHID%TYPE;
	
	
	T_GENREID BOOK.GENREID%TYPE;
	
	T_TOTQTY BOOK.TOTALQTY%TYPE;
    A_QTY BOOK.AvailableQty%TYPE;
	flag int;
    quant BOOK.TOTALQTY%TYPE;
	inventory_id BOOK.TOTALQTY%TYPE;
	cursor c_book is select title from book for update;
	begin
    flag := 0;


	select count(bookid)+1 into t_bid from book;
	

    for item in c_book loop
	if t_title=item.title then
		flag:=1;
		UPDATE Book  SET AvailableQty = AvailableQty + 1
		WHERE title=item.title;
		UPDATE Book  SET TotalQty = TotalQty + 1
		WHERE title=item.title;
      	select TotalQty into quant from book where title = item.title ;
		select bookid into t_bid from book where title=item.title;
		Insert into inventory values(t_bid, quant,'YES');
	end if;
	end loop;

	if flag=0 then
        begin
			select authid into T_AUTHID from author where name=aname;
		EXCEPTION
    		WHEN NO_DATA_FOUND THEN
				add_author(aname);
				select authid into T_AUTHID from author where name=aname;
			
		end;
		begin
			select genreid into t_genreid from genre where GenreName=gname;
		EXCEPTION
    		WHEN NO_DATA_FOUND THEN
				add_genre(gname);
				select genreid into t_genreid from genre where GenreName=gname;
				
		end;
		
		BEGIN
			insert into book values(t_bid,t_authid,t_genreid,t_title,1,1);
			Insert into inventory values(t_bid, 1,'YES');
		EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Error: Book with ID ' || T_BID || ' already exists.');
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            END;
end if;
End;
/


