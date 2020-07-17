Create Table Utilisateur
(
	Id int not null IDENTITY,
	Nom nvarchar(50) not null,
	Prenom nvarchar(50) not null,
	Email nvarchar(320) not null,
	Passwd binary(64) not null
	CONSTRAINT PK_Utilisateur Primary Key (Id),
	CONSTRAINT UK_Utilisateur_Email Unique (Email),
)

Create Table Livreur
(
	Id int not null,
	ChampLivreur nvarchar(50) not null,
	CONSTRAINT PK_Livreur Primary Key (Id),
	Constraint FK_Livreur_Utilisateur Foreign Key (Id) References Utilisateur(Id)
)

Create Table Client
(
	Id int not null,
	ChampClient nvarchar(50) not null,
	CONSTRAINT PK_Client Primary Key (Id),
	Constraint FK_Client_Utilisateur Foreign Key (Id) References Utilisateur(Id)
)
Go

Create View V_Livreur
As
Select U.Id, Nom, Prenom, Email, ChampLivreur
From Utilisateur U
Join Livreur L on U.Id = L.Id;
Go

Create View V_Client
As
Select U.Id, Nom, Prenom, Email, ChampClient
From Utilisateur U
Join Client C on U.Id = C.Id;
Go

Create Procedure RegisterLivreur
@Nom nvarchar(50),
@Prenom nvarchar(50),
@Email nvarchar(320),
@Passwd nvarchar(20),
@ChampLivreur nvarchar(50)
As
Begin	
	Insert into Utilisateur(Nom, Prenom, Email, Passwd) values (@Nom, @Prenom, @Email, HASHBYTES('SHA2_512', @Passwd));
	Set nocount on;
	Declare @Id int = Scope_Identity();
	Insert into Livreur (Id, ChampLivreur) values (@Id, @ChampLivreur);
End
Go

Create Procedure AddLivreurRole
@Id int,
@ChampClient nvarchar(50)
As
Begin	
	Insert into Livreur (Id, ChampLivreur) values (@Id, @ChampClient);
End
Go

Create Procedure RegisterClient
@Nom nvarchar(50),
@Prenom nvarchar(50),
@Email nvarchar(320),
@Passwd nvarchar(20),
@ChampClient nvarchar(50)
As
Begin	
	Insert into Utilisateur(Nom, Prenom, Email, Passwd) values (@Nom, @Prenom, @Email, HASHBYTES('SHA2_512', @Passwd));
	Set nocount on;
	Declare @Id int = Scope_Identity();
	Insert into Client (Id, ChampClient) values (@Id, @ChampClient);
End
Go

Create Procedure AddClientRole
@Id int,
@ChampClient nvarchar(50)
As
Begin	
	Insert into Client (Id, ChampClient) values (@Id, @ChampClient);
End
Go

Create Function GetRoles(@Id int)
returns int
As
Begin
	Declare @Result int = 0
	If exists(select Id from Client where Id = @Id)
		Set @Result += 1;

	If exists(select Id from Livreur where Id = @Id)
		Set @Result += 2;

	--Si Maraîcher
		--Set @Result += 4;

	--Si Admin
		--Set @Result += 8;

	--Si Super Admin
		--Set @Result += 16;
	return @Result;
End
Go

Alter Procedure CheckUser
@Email nvarchar(320),
@Passwd nvarchar(20)
As
Begin
	Select	Id,
			Nom, 
			Prenom, 
			Email, 
			dbo.GetRoles(Id) Roles
	From Utilisateur U where Email = @Email and Passwd = HASHBYTES('SHA2_512', @Passwd);
End
Go





Exec RegisterLivreur @Nom = N'Morre', @Prenom = N'Thierry', @Email = N'thierry.morre@cognitic.be', @Passwd = N'Test1234=', @ChampLivreur = 'Lorem ipsum dolor sit amet';
Exec AddClientRole @Id = 1,  @ChampClient = 'Far Far Away...';
Exec RegisterClient @Nom = N'Person', @Prenom = N'Michael', @Email = N'michael.person@cognitic.be',  @Passwd = N'Test1234=', @ChampClient = 'Once upon a time...';


Select * from V_Livreur
Select * From Utilisateur

exec CheckUser @Email = N'thierry.morre@cognitic.be', @Passwd = N'Test1234=';
exec CheckUser @Email = N'michael.person@cognitic.be', @Passwd = N'Test1234=';

