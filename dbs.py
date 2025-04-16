
import cx_Oracle
con = cx_Oracle.connect('dbs_proj/****')
print(con.version)

# cursor2 = con.cursor()
# cursor2.callproc("add_user", ["Aditya", "SILVER","CARD"])
# cursor3 = con.cursor()
# cursor3.callproc("add_book", ["Lord of the Rings", "John Ronald","Fiction"])
# cursor4 = con.cursor()
# cursor4.callproc("borrow_book", ["Percy Jackson", "2"])
# cursor = con.cursor()
# cursor.callproc("return_book", ["1", "CARD"])
# cursor5=con.cursor()
# cursor5.callproc("add_author",["Magnus"])
# cursor6=con.cursor()
# cursor6.callproc("add_genre",["Horror"])

def display (a):
    if type(a) == list:
        for tup in a:
            display(tup)
        return

    for item in a :
        print(item , end=' | ')
    print()
print("LIBRARY ADMIN PORTAL ")
menu = """
1. Add user 
2. Display User Information 
3. Show Revenue from Subscriptions 
4. Add a new book 
5. Add a new Author
6. Display all Authors
7. Add a new Genre 
8. Display all available Genres
9. Display all payments 
10.Display all book transactions 
11.Display Inventory
12. Borrow a book 
13. Show  all book details 
14. Return a Book   
15. Show late returned book revenue  
16. To commit changes made 
-1. Exit 
"""
inp=5
while inp!=-1:
    inp = int(input("What would you like to do, Enter 20 to see the menu again"))
    cursor = con.cursor()
    if inp ==1:
        arr = input("Enter Name, Membership Type, Payment Method").split(", ")
        print(arr)
        cursor.callproc("add_user",arr)
    elif inp==2:
        cursor.execute("select * from users join Subscription on SubType = SubscriptionType")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==3:
        cursor.execute("select * from userssubscriptiondues natural join Dues ")
        column_titles = [desc[0] for desc in cursor.description]
        print( column_titles)

        display(cursor.fetchall())
    elif inp==4:
        arr = input("Enter Book Title, Author Name, Genre").split(", ")
        cursor.callproc("add_book", arr)

    elif inp==5:
        nm = input("Enter authors name")
        cursor.callproc("add_author",[nm])
    elif inp==6:
        cursor.execute("select * from author  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==7:
        nm = input("Enter Genre name")
        cursor.callproc("add_genre", [nm])
    elif inp==8:
        cursor.execute("select * from genre  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp == 9 :
        cursor.execute("select * from dues  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp ==10:
        cursor.execute("select * from borrow  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==11:
        cursor.execute("select * from inventory  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==12:
        arr = input("Enter name of book , UserId of user to borrow").split(", ")
        cursor.callproc("borrow_book", arr)
    elif inp==13:
        cursor.execute("select * from book natural join genre natural  join author ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==14:
        arr = input("Enter BorrowId , Payment method to be used if Late ").split(", ")
        cursor.callproc("return_book", arr)
    elif inp==15:
        cursor.execute("select * from borrow_dues  ")
        column_titles = [desc[0] for desc in cursor.description]
        print("Column Titles:", column_titles)

        display(cursor.fetchall())
    elif inp==16 :
        con.commit()
    else :
        print(menu)






con.commit()
con.close()

