
CREATE TABLE Author (
    AuthID number PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE Genre (
    GenreID NUMERIC(5) PRIMARY KEY,
    GenreName VARCHAR(25)
);

CREATE TABLE Book (
    BookID NUMERIC(5) PRIMARY KEY,
    AuthID NUMERIC(5),
    GenreID NUMERIC(5),
    Title VARCHAR(45),
    TotalQty NUMERIC(5),
    AvailableQty NUMERIC(5),
    FOREIGN KEY (AuthID) REFERENCES Author(AuthID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

CREATE TABLE Inventory (
    BookID NUMERIC(5) ,
    InventoryNo NUMERIC(5) ,
	AVAILABLE varchar(20)
	Check(AVAILABLE in ('YES','NO')),
    PRIMARY KEY (BookID, InventoryNo),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);



CREATE TABLE Subscription (
    SubType VARCHAR(50) PRIMARY KEY,
    Amount numeric(10, 2),
    Check (SubscriptionType in ('PLATINUM','GOLD','SILVER'))
);
insert into Subscription values ('PLATINUM',10000);
insert into Subscription values ('GOLD',7500);
insert into Subscription values ('SILVER',5000);

CREATE TABLE Users (
    UserID int  PRIMARY KEY,
	 Name VARCHAR(45),
    SubscriptionType VARCHAR(50),
   FOREIGN KEY (SubscriptionType) REFERENCES Subscription (SubType),
   Check (SubscriptionType in ('PLATINUM','GOLD','SILVER'))
);

CREATE TABLE Borrow (
    BorrowID INT PRIMARY KEY,
    BorrowDate DATE,
    ReturnDate DATE,
    InventoryID NUMERIC(5) ,
    BookID NUMERIC(5) ,
    UserID NUMERIC(5) ,
    Status VARCHAR(50),
    FOREIGN KEY (BookID,InventoryID) REFERENCES Inventory(BookID, InventoryNo),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Dues (
    DueID NUMERIC(5) PRIMARY KEY,
   Amount numeric(10, 2),
    Method VARCHAR(50),
    Paid VARCHAR(5),
    DateOfIssue DATE,
    DateOfReceipt DATE,
   Check(PAID in ( 'YES', 'No'))
);


CREATE TABLE UsersSubscriptionDues (
    UsersID NUMERIC(5),
    SubType VARCHAR(50),
    DueID NUMERIC(5),
    PRIMARY KEY (UsersID),
    FOREIGN KEY (UsersID) REFERENCES Users(UserID),
    FOREIGN KEY (SubType) REFERENCES Subscription(SubType),
    FOREIGN KEY (DueID) REFERENCES Dues(DueID)
);

CREATE TABLE Borrow_Dues (
    BorrowID NUMERIC(5),
    duesid NUMERIC(5),	
    PRIMARY KEY (BorrowID, duesid),
    FOREIGN KEY (BorrowID) REFERENCES Borrow(BorrowID),
    FOREIGN KEY (duesid) REFERENCES Dues(DueID)
);
