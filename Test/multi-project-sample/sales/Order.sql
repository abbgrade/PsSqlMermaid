CREATE TABLE [sales].[Order]
(
	[Id] INT NOT NULL , 
    [CustomerId] INT NOT NULL, 
    CONSTRAINT [PK_Order] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_Order_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [customer].[Customer]([Id])
)
