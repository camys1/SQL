CREATE TABLE Authors (
    AuthorID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    LastName VARCHAR2(50) NOT NULL
);

CREATE TABLE Categories (
    CategoryID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL
);

CREATE TABLE Books (
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(100) NOT NULL, --Titlu
    AuthorID NUMBER NOT NULL, -- Autorr
    CategoryID NUMBER NOT NULL, 
    TotalCopies NUMBER DEFAULT 1,
    AvailableCopies NUMBER DEFAULT 1,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Readers (
    ReaderID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL, -- Prenume
    LastName VARCHAR2(50) NOT NULL, -- Nume de familie
    Email VARCHAR2(100) UNIQUE, -- Email 
    Phone VARCHAR2(15) -- Telefon
);

CREATE TABLE Borrowings (
    BorrowingID NUMBER PRIMARY KEY, -- ID-ul unic al împrumutului
    ReaderID NUMBER NOT NULL, -- Cititorul (legat de tabela Readers)
    BookID NUMBER NOT NULL, -- Cartea (legat de tabela Books)
    BorrowDate DATE DEFAULT SYSDATE, -- Data împrumutului
    ReturnDate DATE, -- Data returnării
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID), -- Legătură cu tabela Readers
    FOREIGN KEY (BookID) REFERENCES Books(BookID) -- Legătură cu tabela Books
);

INSERT INTO Authors (AuthorID, FirstName, LastName) VALUES (1, 'Ion', 'Creangă');
INSERT INTO Authors (AuthorID, FirstName, LastName) VALUES (2, 'Mihai', 'Eminescu');

INSERT INTO Categories (CategoryID, Name) VALUES (1, 'Literatură');
INSERT INTO Categories (CategoryID, Name) VALUES (2, 'Știință');

INSERT INTO Books (BookID, Title, AuthorID, CategoryID, TotalCopies, AvailableCopies)
VALUES (1, 'Amintiri din copilărie', 1, 1, 5, 5);

INSERT INTO Books (BookID, Title, AuthorID, CategoryID, TotalCopies, AvailableCopies)
VALUES (2, 'Luceafărul', 2, 1, 3, 3);

INSERT INTO Readers (ReaderID, FirstName, LastName, Email, Phone)
VALUES (1, 'Maria', 'Popescu', 'maria.popescu@example.com', '0720123456');

INSERT INTO Borrowings (BorrowingID, ReaderID, BookID, BorrowDate)
VALUES (1, 1, 1, SYSDATE);

SELECT Title, AvailableCopies FROM Books WHERE AvailableCopies > 0;

SELECT Title 
FROM Books 
WHERE AuthorID = 1;


SELECT Readers.FirstName, Readers.LastName, Books.Title, Borrowings.BorrowDate
FROM Borrowings
INNER JOIN Readers ON Borrowings.ReaderID = Readers.ReaderID
INNER JOIN Books ON Borrowings.BookID = Books.BookID;

SELECT Readers.FirstName, Readers.LastName, COUNT(Borrowings.BorrowingID) AS TotalBorrowings
FROM Borrowings
INNER JOIN Readers ON Borrowings.ReaderID = Readers.ReaderID
GROUP BY Readers.FirstName, Readers.LastName;

CREATE OR REPLACE PROCEDURE UpdateAvailableCopies (
    p_BookID IN NUMBER,
    p_Change IN NUMBER
) AS
BEGIN
    UPDATE Books
    SET AvailableCopies = AvailableCopies + p_Change
    WHERE BookID = p_BookID;
END;
EXEC UpdateAvailableCopies(1, 3);

SELECT AvailableCopies FROM Books WHERE BookID = 1;


CREATE OR REPLACE FUNCTION BorrowDuration (
    p_BorrowingID IN NUMBER
) RETURN NUMBER AS
    v_Duration NUMBER;
BEGIN
    SELECT ROUND(SYSDATE - BorrowDate)
    INTO v_Duration
    FROM Borrowings
    WHERE BorrowingID = p_BorrowingID;

    RETURN v_Duration;
END;
SELECT BorrowDuration(1) FROM dual;


CREATE OR REPLACE TRIGGER UpdateAvailableCopiesAfterBorrow
AFTER INSERT ON Borrowings
FOR EACH ROW
BEGIN
    UPDATE Books
    SET AvailableCopies = AvailableCopies - 1
    WHERE BookID = :NEW.BookID;
END;

DESCRIBE Readers;
SELECT * FROM Books WHERE BookID = 1;
SELECT * FROM Readers WHERE ReaderID = 1001;
INSERT INTO Readers (READERID, FIRSTNAME, LASTNAME, EMAIL, PHONE)
VALUES (1001, 'Ion', 'Popescu', 'ion.popescu@example.com', '0712345678');

INSERT INTO Borrowings (BorrowingID, BookID, BorrowDate, ReturnDate, ReaderID)
VALUES (2, 1, SYSDATE, SYSDATE + 14, 1001);

INSERT INTO Books (BookID, Title, AuthorID, CategoryID, TotalCopies, AvailableCopies)
VALUES (3, 'Maitreyi', 2, 1, 4, 4);

INSERT INTO Books (BookID, Title, AuthorID, CategoryID, TotalCopies, AvailableCopies)
VALUES (4, 'Ion', 3, 3, 6, 5);

INSERT INTO Authors (AuthorID, Firstname, Lastname)
VALUES (3, 'Liviu', 'Rebreanu');
INSERT INTO Categories (CategoryID, Name)
VALUES (3, 'Roman');


SELECT * FROM Authors;
SELECT * FROM Categories;
SELECT * FROM Books;
SELECT * FROM Readers;
SELECT * FROM Borrowings;



