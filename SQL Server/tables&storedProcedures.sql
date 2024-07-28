create procedure CreateUser
	@Username Nvarchar(50),
	@Email Nvarchar(100),
	@PasswordHash Nvarchar(255),
	@Status int,
	@AddressLine1 Nvarchar(100),
	@AddressLine2 Nvarchar(100),
	@City Nvarchar(50), 
	@State Nvarchar(50),
	@PostalCode Nvarchar(10),
	@CountryID int
AS
BEGIN
	insert into Users(Username,Email,PasswordHash,Status,AddressLine1,AddressLine2,City,State,PostalCode,CountryID)
	values(@Username,@Email,@PasswordHash,@Status,@AddressLine1,@AddressLine2,@City, @State,@PostalCode,@CountryID)
END;
GO
------------------------------------------------------
create procedure UpdateUserStatus
	@UserID int,
	@status int
as
begin
	update Users
	set Status=@status
	where UserID=@UserID
end;
Go
--------------------------------------------------------

create procedure CreateItem
	@SellerID int,
	@CategoryID int,
	@Title nvarchar(100),
	@Description nvarchar(100),
	@StartingPrice decimal(18,2),
	@CurrentPrice decimal(18,2),
	@StartDate date,
	@EndDate date,
	@ImageURL varchar(max)
as
begin
	insert into Items(SellerID,CategoryID,Title,Description,StartingPrice,CurrentPrice,StartDate,EndDate,ImageURL)
	values(@SellerID,@CategoryID,@Title,@Description,@StartingPrice,@CurrentPrice,@StartDate,@EndDate,@ImageURL)
end;

Go
----------------------------------------------------------------
create procedure PlaceBid
	@ItemID int,
	@UserID int,
	@BidAmount decimal(18,2)
as
begin
	insert into Bids(ItemID,UserID,BidAmount,BidTime)
	values(@ItemID,@UserID,@BidAmount,GETDATE())

	update Items
	set CurrentPrice=@BidAmount
	where ItemID=@ItemID
end
Go
---------------------------------------------------------------
--Retrieve all items along with their respective seller information.
select I.*,u.Username 
from Items I join Users U 
on U.UserID=I.SellerID


--Retrieve all users along with their items, if they have any.
select * from Users u
left join Items I on u.UserID=i.SellerID

--Retrieve all users and their items, showing all users and all items, even if there is no match.
select * from Users u 
full outer join Items i
on u.UserID=i.SellerID

--Retrieve items with the number of bids each item has received.
select i.ItemID,count(BidAmount) NumberOfBids from items i
join bids b on i.ItemID=b.ItemID
group by i.ItemID

--Retrieve users and the total amount they have spent on orders.
select  u.UserID,sum(o.TotalAmount) TotalAmount from Users u
join orders o on u.UserID=o.BuyerID
group by u.UserID

--Retrieve items along with their category names.
select i.*,c.CategoryID from Items i
join Categories c
on i.CategoryID=c.CategoryID
