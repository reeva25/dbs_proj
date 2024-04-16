-- ADD BOOK 
Create or replace procedure add_book is
	T_BID BOOK.BOOKID%TYPE;
   	T_AUTHID BOOK.AUTHID%TYPE;
	ANAME AUTHOR.NAME%TYPE;
	GNAME GENRE.GenreName%TYPE;
	T_GENREID BOOK.GENREID%TYPE;
	T_TITLE BOOK.TITLE%TYPE;
	T_TOTQTY BOOK.TOTALQTY%TYPE;
    A_QTY BOOK.AvailableQty%TYPE;
	flag number:=0;
    quant number ;
	inventory_id number;
	cursor c_book is select title from book for update;
	begin
	t_bid:='&book_id' ;
	t_title:='&book_title';
	aname:='&author_name';
	gname:='&genre_name';

    for item in c_book loop
	if t_title=item.title then
		flag:=1;
		UPDATE Book  SET AvailableQty = AvailableQty + 1
		WHERE title=item.title;
		UPDATE Book  SET TotalQty = TotalQty + 1
		WHERE title=item.title;
        select TotalQty into quant from book where title = item.title ;
		Insert into inventory values(t_bid, quant,'YES');
	end if;
	end loop;

	if flag=0 then
		select authid into T_AUTHID from author where name=aname;
		select genreid into t_genreid from genre where GenreName=gname;
		if t_authid is null then
			add_author(aname);
		end if;
		if t_genreid is null then
			add_genre(gname);
		end if;
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
-- Create or replace procedure add_author(aname author.name%type)  is
-- 	t_auth_id author.authid%type;
-- 	begin
-- 	t_auth_id := '&authorid';
-- 	insert into author values (t_auth_id,aname);
-- 	exception
-- 	  WHEN DUP_VAL_ON_INDEX THEN
--                     DBMS_OUTPUT.PUT_LINE('Error: Author with ID ' || t_auth_id || ' already exists.');
--                 WHEN OTHERS THEN
--                     DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
--     END;
-- /

-- Create or replace procedure add_genre(gname genre.GenreName%type) is
-- t_gid genre.GenreID%type;
-- 	begin
-- 	t_gid := '&genreid';
-- 	insert into genre values (t_gid,gname);
-- 	exception
-- 	  WHEN DUP_VAL_ON_INDEX THEN
--                     DBMS_OUTPUT.PUT_LINE('Error: Genre with ID ' || t_gid || ' already exists.');
--                 WHEN OTHERS THEN
--                     DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
--         END;
-- /

