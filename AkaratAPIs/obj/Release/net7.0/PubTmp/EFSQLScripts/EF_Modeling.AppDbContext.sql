IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Apartments] (
        [Id] int NOT NULL IDENTITY,
        [Address] nvarchar(max) NOT NULL,
        [City] nvarchar(max) NOT NULL,
        [Price] float NOT NULL,
        [Rooms Count] int NOT NULL,
        [Kitchens Count] int NOT NULL,
        [Bathrooms Count] int NOT NULL,
        CONSTRAINT [PK_Apartments] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetRoles] (
        [Id] nvarchar(450) NOT NULL,
        [Name] nvarchar(256) NULL,
        [NormalizedName] nvarchar(256) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Enterprises] (
        [Id] int NOT NULL IDENTITY,
        [TaxRecordImagePath] nvarchar(max) NOT NULL,
        [Tax Record Number] nchar(9) NOT NULL,
        [Email] nvarchar(max) NOT NULL,
        [Phone Number] nvarchar(15) NOT NULL,
        [Location] nvarchar(max) NOT NULL,
        [IsVerified] bit NOT NULL,
        CONSTRAINT [PK_Enterprises] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [ApartmentImagePath] (
        [Id] int NOT NULL,
        [Image Path] nvarchar(450) NOT NULL,
        [ApartmentId] int NULL,
        CONSTRAINT [PK_ApartmentImagePath] PRIMARY KEY ([Id], [Image Path]),
        CONSTRAINT [FK_ApartmentImagePath_Apartments_ApartmentId] FOREIGN KEY ([ApartmentId]) REFERENCES [Apartments] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Buildings] (
        [Id] int NOT NULL IDENTITY,
        [Has Elevator] bit NOT NULL,
        [Flats Count] int NOT NULL,
        [Floors Count] int NOT NULL,
        [PropertyFeaturesId] int NOT NULL,
        CONSTRAINT [PK_Buildings] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Buildings_Apartments_PropertyFeaturesId] FOREIGN KEY ([PropertyFeaturesId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Properties] (
        [Id] int NOT NULL IDENTITY,
        [FloorNumber] int NOT NULL,
        [IsFurnished] bit NOT NULL,
        [IsVitalSite] bit NOT NULL,
        [PropertyFeaturesId] int NOT NULL,
        CONSTRAINT [PK_Properties] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Properties_Apartments_PropertyFeaturesId] FOREIGN KEY ([PropertyFeaturesId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Villas] (
        [Id] int NOT NULL IDENTITY,
        [HasSwimmingPool] bit NOT NULL,
        [VillaFeaturesId] int NOT NULL,
        CONSTRAINT [PK_Villas] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Villas_Apartments_VillaFeaturesId] FOREIGN KEY ([VillaFeaturesId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetRoleClaims] (
        [Id] int NOT NULL IDENTITY,
        [RoleId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetUsers] (
        [Id] nvarchar(450) NOT NULL,
        [FirstName] nvarchar(max) NOT NULL,
        [LastName] nvarchar(max) NOT NULL,
        [Address] nvarchar(max) NOT NULL,
        [type] int NOT NULL,
        [isPhoneNumberVerified] bit NOT NULL,
        [CardId] int NOT NULL,
        [EnterpriseId] int NULL,
        [UserName] nvarchar(256) NULL,
        [NormalizedUserName] nvarchar(256) NULL,
        [Email] nvarchar(256) NULL,
        [NormalizedEmail] nvarchar(256) NULL,
        [EmailConfirmed] bit NOT NULL,
        [PasswordHash] nvarchar(max) NULL,
        [SecurityStamp] nvarchar(max) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [PhoneNumber] nvarchar(max) NULL,
        [PhoneNumberConfirmed] bit NOT NULL,
        [TwoFactorEnabled] bit NOT NULL,
        [LockoutEnd] datetimeoffset NULL,
        [LockoutEnabled] bit NOT NULL,
        [AccessFailedCount] int NOT NULL,
        CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUsers_Enterprises_EnterpriseId] FOREIGN KEY ([EnterpriseId]) REFERENCES [Enterprises] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Advertisements] (
        [Id] int NOT NULL IDENTITY,
        [Date] datetime2 NOT NULL,
        [Description] nvarchar(140) NOT NULL,
        [Title] nvarchar(140) NOT NULL,
        [ApartmentId] int NOT NULL,
        [UserId] nvarchar(450) NULL,
        CONSTRAINT [PK_Advertisements] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Advertisements_Apartments_ApartmentId] FOREIGN KEY ([ApartmentId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Advertisements_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetUserClaims] (
        [Id] int NOT NULL IDENTITY,
        [UserId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetUserLogins] (
        [LoginProvider] nvarchar(450) NOT NULL,
        [ProviderKey] nvarchar(450) NOT NULL,
        [ProviderDisplayName] nvarchar(max) NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetUserRoles] (
        [UserId] nvarchar(450) NOT NULL,
        [RoleId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [AspNetUserTokens] (
        [UserId] nvarchar(450) NOT NULL,
        [LoginProvider] nvarchar(450) NOT NULL,
        [Name] nvarchar(450) NOT NULL,
        [Value] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Card] (
        [Id] nvarchar(450) NOT NULL,
        [CVV] nchar(3) NOT NULL,
        [Expiration Date] datetime2 NOT NULL,
        [Card Number] nchar(16) NOT NULL,
        [Owner Id] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_Card] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Card_AspNetUsers_Owner Id] FOREIGN KEY ([Owner Id]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Messages] (
        [Id] int NOT NULL IDENTITY,
        [SenderId] nvarchar(450) NOT NULL,
        [ReceiverId] nvarchar(450) NOT NULL,
        [MessageContent] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_Messages] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Messages_AspNetUsers_ReceiverId] FOREIGN KEY ([ReceiverId]) REFERENCES [AspNetUsers] ([Id]),
        CONSTRAINT [FK_Messages_AspNetUsers_SenderId] FOREIGN KEY ([SenderId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [RefreshTokens] (
        [Id] int NOT NULL IDENTITY,
        [ExpiresOn] datetime2 NOT NULL,
        [CreatedOn] datetime2 NOT NULL,
        [RevokedOn] datetime2 NOT NULL,
        [Token] nvarchar(max) NOT NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_RefreshTokens] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_RefreshTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Reports] (
        [Id] int NOT NULL IDENTITY,
        [Date] datetime2 NOT NULL,
        [Description] nvarchar(max) NOT NULL,
        [ComplainerId] nvarchar(450) NOT NULL,
        [ComplaineeId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_Reports] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Reports_AspNetUsers_ComplaineeId] FOREIGN KEY ([ComplaineeId]) REFERENCES [AspNetUsers] ([Id]),
        CONSTRAINT [FK_Reports_AspNetUsers_ComplainerId] FOREIGN KEY ([ComplainerId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE TABLE [Transcations] (
        [Id] int NOT NULL IDENTITY,
        [Rental Cost] float NOT NULL,
        [Date] datetime2 NOT NULL,
        [State] int NOT NULL,
        [InitiatorId] nvarchar(450) NOT NULL,
        [ReceiverId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_Transcations] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Transcations_AspNetUsers_InitiatorId] FOREIGN KEY ([InitiatorId]) REFERENCES [AspNetUsers] ([Id]),
        CONSTRAINT [FK_Transcations_AspNetUsers_ReceiverId] FOREIGN KEY ([ReceiverId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Advertisements_ApartmentId] ON [Advertisements] ([ApartmentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Advertisements_UserId] ON [Advertisements] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_ApartmentImagePath_ApartmentId] ON [ApartmentImagePath] ([ApartmentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_AspNetUsers_EnterpriseId] ON [AspNetUsers] ([EnterpriseId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Buildings_PropertyFeaturesId] ON [Buildings] ([PropertyFeaturesId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE UNIQUE INDEX [IX_Card_Owner Id] ON [Card] ([Owner Id]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Messages_ReceiverId] ON [Messages] ([ReceiverId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Messages_SenderId] ON [Messages] ([SenderId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Properties_PropertyFeaturesId] ON [Properties] ([PropertyFeaturesId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_RefreshTokens_UserId] ON [RefreshTokens] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Reports_ComplaineeId] ON [Reports] ([ComplaineeId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Reports_ComplainerId] ON [Reports] ([ComplainerId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE UNIQUE INDEX [IX_Transcations_InitiatorId] ON [Transcations] ([InitiatorId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE UNIQUE INDEX [IX_Transcations_ReceiverId] ON [Transcations] ([ReceiverId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    CREATE INDEX [IX_Villas_VillaFeaturesId] ON [Villas] ([VillaFeaturesId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230226201101_InitDB')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230226201101_InitDB', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230306000326_AddActivationToRefreshToken')
BEGIN
    ALTER TABLE [RefreshTokens] ADD [IsActive] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230306000326_AddActivationToRefreshToken')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230306000326_AddActivationToRefreshToken', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230309074439_RemoveIsActiveColumnFromRefreshTokensTable')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[RefreshTokens]') AND [c].[name] = N'IsActive');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [RefreshTokens] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [RefreshTokens] DROP COLUMN [IsActive];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230309074439_RemoveIsActiveColumnFromRefreshTokensTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230309074439_RemoveIsActiveColumnFromRefreshTokensTable', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230321145400_AddingImagePathToUsersTable')
BEGIN
    ALTER TABLE [AspNetUsers] ADD [ImagePath] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230321145400_AddingImagePathToUsersTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230321145400_AddingImagePathToUsersTable', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    ALTER TABLE [Advertisements] DROP CONSTRAINT [FK_Advertisements_Apartments_ApartmentId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    DROP INDEX [IX_Advertisements_ApartmentId] ON [Advertisements];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Advertisements]') AND [c].[name] = N'ApartmentId');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Advertisements] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [Advertisements] DROP COLUMN [ApartmentId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    ALTER TABLE [Apartments] ADD [AdvertisementId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    CREATE UNIQUE INDEX [IX_Apartments_AdvertisementId] ON [Apartments] ([AdvertisementId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    ALTER TABLE [Apartments] ADD CONSTRAINT [FK_Apartments_Advertisements_AdvertisementId] FOREIGN KEY ([AdvertisementId]) REFERENCES [Advertisements] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330212140_UpdateDirectionOfAdAndApartment')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230330212140_UpdateDirectionOfAdAndApartment', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Buildings] DROP CONSTRAINT [FK_Buildings_Apartments_PropertyFeaturesId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Properties] DROP CONSTRAINT [FK_Properties_Apartments_PropertyFeaturesId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Villas] DROP CONSTRAINT [FK_Villas_Apartments_VillaFeaturesId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Villas].[VillaFeaturesId]', N'ApartmentId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Villas].[IX_Villas_VillaFeaturesId]', N'IX_Villas_ApartmentId', N'INDEX';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Properties].[PropertyFeaturesId]', N'ApartmentId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Properties].[IX_Properties_PropertyFeaturesId]', N'IX_Properties_ApartmentId', N'INDEX';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Buildings].[PropertyFeaturesId]', N'ApartmentId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    EXEC sp_rename N'[Buildings].[IX_Buildings_PropertyFeaturesId]', N'IX_Buildings_ApartmentId', N'INDEX';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Buildings] ADD CONSTRAINT [FK_Buildings_Apartments_ApartmentId] FOREIGN KEY ([ApartmentId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Properties] ADD CONSTRAINT [FK_Properties_Apartments_ApartmentId] FOREIGN KEY ([ApartmentId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    ALTER TABLE [Villas] ADD CONSTRAINT [FK_Villas_Apartments_ApartmentId] FOREIGN KEY ([ApartmentId]) REFERENCES [Apartments] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330214553_AddApartmentForeignKey')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230330214553_AddApartmentForeignKey', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Apartments] DROP CONSTRAINT [FK_Apartments_Advertisements_AdvertisementId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Buildings] DROP CONSTRAINT [FK_Buildings_Apartments_ApartmentId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Villas] DROP CONSTRAINT [FK_Villas_Apartments_ApartmentId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DROP TABLE [ApartmentImagePath];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DROP TABLE [Properties];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DROP INDEX [IX_Apartments_AdvertisementId] ON [Apartments];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Apartments]') AND [c].[name] = N'Address');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Apartments] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [Apartments] DROP COLUMN [Address];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DECLARE @var3 sysname;
    SELECT @var3 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Apartments]') AND [c].[name] = N'AdvertisementId');
    IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Apartments] DROP CONSTRAINT [' + @var3 + '];');
    ALTER TABLE [Apartments] DROP COLUMN [AdvertisementId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DECLARE @var4 sysname;
    SELECT @var4 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Apartments]') AND [c].[name] = N'Bathrooms Count');
    IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [Apartments] DROP CONSTRAINT [' + @var4 + '];');
    ALTER TABLE [Apartments] DROP COLUMN [Bathrooms Count];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DECLARE @var5 sysname;
    SELECT @var5 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Apartments]') AND [c].[name] = N'City');
    IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [Apartments] DROP CONSTRAINT [' + @var5 + '];');
    ALTER TABLE [Apartments] DROP COLUMN [City];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    DECLARE @var6 sysname;
    SELECT @var6 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Apartments]') AND [c].[name] = N'Price');
    IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Apartments] DROP CONSTRAINT [' + @var6 + '];');
    ALTER TABLE [Apartments] DROP COLUMN [Price];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Villas].[ApartmentId]', N'HouseBaseId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Villas].[IX_Villas_ApartmentId]', N'IX_Villas_HouseBaseId', N'INDEX';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Buildings].[ApartmentId]', N'HouseBaseId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Buildings].[IX_Buildings_ApartmentId]', N'IX_Buildings_HouseBaseId', N'INDEX';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Apartments].[Rooms Count]', N'HouseBaseId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    EXEC sp_rename N'[Apartments].[Kitchens Count]', N'FloorNumber', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Apartments] ADD [IsFurnished] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Apartments] ADD [IsVitalSite] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    CREATE TABLE [HousesBase] (
        [Id] int NOT NULL IDENTITY,
        [Address] nvarchar(max) NOT NULL,
        [City] nvarchar(max) NOT NULL,
        [Price] float NOT NULL,
        [Rooms Count] int NOT NULL,
        [Kitchens Count] int NOT NULL,
        [Bathrooms Count] int NOT NULL,
        [AdvertisementId] int NOT NULL,
        CONSTRAINT [PK_HousesBase] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_HousesBase_Advertisements_AdvertisementId] FOREIGN KEY ([AdvertisementId]) REFERENCES [Advertisements] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    CREATE TABLE [HouseBaseImagePath] (
        [Id] int NOT NULL,
        [Image Path] nvarchar(450) NOT NULL,
        [HouseBaseId] int NULL,
        CONSTRAINT [PK_HouseBaseImagePath] PRIMARY KEY ([Id], [Image Path]),
        CONSTRAINT [FK_HouseBaseImagePath_HousesBase_HouseBaseId] FOREIGN KEY ([HouseBaseId]) REFERENCES [HousesBase] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    CREATE INDEX [IX_Apartments_HouseBaseId] ON [Apartments] ([HouseBaseId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    CREATE INDEX [IX_HouseBaseImagePath_HouseBaseId] ON [HouseBaseImagePath] ([HouseBaseId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    CREATE UNIQUE INDEX [IX_HousesBase_AdvertisementId] ON [HousesBase] ([AdvertisementId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Apartments] ADD CONSTRAINT [FK_Apartments_HousesBase_HouseBaseId] FOREIGN KEY ([HouseBaseId]) REFERENCES [HousesBase] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Buildings] ADD CONSTRAINT [FK_Buildings_HousesBase_HouseBaseId] FOREIGN KEY ([HouseBaseId]) REFERENCES [HousesBase] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    ALTER TABLE [Villas] ADD CONSTRAINT [FK_Villas_HousesBase_HouseBaseId] FOREIGN KEY ([HouseBaseId]) REFERENCES [HousesBase] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230405165910_RenameDBTables')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230405165910_RenameDBTables', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230428232720_AddPropertyTypeInAdvertisementTable')
BEGIN
    ALTER TABLE [HousesBase] ADD [IsForRent] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230428232720_AddPropertyTypeInAdvertisementTable')
BEGIN
    ALTER TABLE [Advertisements] ADD [PropertyType] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230428232720_AddPropertyTypeInAdvertisementTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230428232720_AddPropertyTypeInAdvertisementTable', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230505113935_AddNamePropForEnterprise')
BEGIN
    ALTER TABLE [Enterprises] ADD [Name] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230505113935_AddNamePropForEnterprise')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230505113935_AddNamePropForEnterprise', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    ALTER TABLE [Advertisements] DROP CONSTRAINT [FK_Advertisements_AspNetUsers_UserId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    ALTER TABLE [HouseBaseImagePath] DROP CONSTRAINT [FK_HouseBaseImagePath_HousesBase_HouseBaseId];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    DROP INDEX [IX_HouseBaseImagePath_HouseBaseId] ON [HouseBaseImagePath];
    DECLARE @var7 sysname;
    SELECT @var7 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[HouseBaseImagePath]') AND [c].[name] = N'HouseBaseId');
    IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [HouseBaseImagePath] DROP CONSTRAINT [' + @var7 + '];');
    EXEC(N'UPDATE [HouseBaseImagePath] SET [HouseBaseId] = 0 WHERE [HouseBaseId] IS NULL');
    ALTER TABLE [HouseBaseImagePath] ALTER COLUMN [HouseBaseId] int NOT NULL;
    ALTER TABLE [HouseBaseImagePath] ADD DEFAULT 0 FOR [HouseBaseId];
    CREATE INDEX [IX_HouseBaseImagePath_HouseBaseId] ON [HouseBaseImagePath] ([HouseBaseId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    ALTER TABLE [Enterprises] ADD [BrandLogoPath] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    DROP INDEX [IX_Advertisements_UserId] ON [Advertisements];
    DECLARE @var8 sysname;
    SELECT @var8 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Advertisements]') AND [c].[name] = N'UserId');
    IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [Advertisements] DROP CONSTRAINT [' + @var8 + '];');
    EXEC(N'UPDATE [Advertisements] SET [UserId] = N'''' WHERE [UserId] IS NULL');
    ALTER TABLE [Advertisements] ALTER COLUMN [UserId] nvarchar(450) NOT NULL;
    ALTER TABLE [Advertisements] ADD DEFAULT N'' FOR [UserId];
    CREATE INDEX [IX_Advertisements_UserId] ON [Advertisements] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    ALTER TABLE [Advertisements] ADD CONSTRAINT [FK_Advertisements_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    ALTER TABLE [HouseBaseImagePath] ADD CONSTRAINT [FK_HouseBaseImagePath_HousesBase_HouseBaseId] FOREIGN KEY ([HouseBaseId]) REFERENCES [HousesBase] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230512150132_FixingHouseBasePathTableAndSetConstrainOnAddingAdvertisement', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512155356_AddingHasElevatorProperty')
BEGIN
    ALTER TABLE [Apartments] ADD [HasElevator] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230512155356_AddingHasElevatorProperty')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230512155356_AddingHasElevatorProperty', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230520054228_AddFavoritePropsTable')
BEGIN
    CREATE TABLE [FavoriteProperties] (
        [UserId] nvarchar(450) NULL,
        [AdvertisementId] int NULL,
        CONSTRAINT [FK_FavoriteProperties_Advertisements_AdvertisementId] FOREIGN KEY ([AdvertisementId]) REFERENCES [Advertisements] ([Id]),
        CONSTRAINT [FK_FavoriteProperties_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230520054228_AddFavoritePropsTable')
BEGIN
    CREATE INDEX [IX_FavoriteProperties_AdvertisementId] ON [FavoriteProperties] ([AdvertisementId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230520054228_AddFavoritePropsTable')
BEGIN
    CREATE INDEX [IX_FavoriteProperties_UserId] ON [FavoriteProperties] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230520054228_AddFavoritePropsTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230520054228_AddFavoritePropsTable', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230601113511_AddAgePropToUserTable')
BEGIN
    ALTER TABLE [AspNetUsers] ADD [Age] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230601113511_AddAgePropToUserTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230601113511_AddAgePropToUserTable', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230604163821_AddRelationEnterpriseAgentWithUserAndEnterprise')
BEGIN
    CREATE TABLE [EnterpriseAgent] (
        [UserId] nvarchar(450) NOT NULL,
        [EnterpriseId] int NOT NULL,
        CONSTRAINT [PK_EnterpriseAgent] PRIMARY KEY ([UserId], [EnterpriseId]),
        CONSTRAINT [FK_EnterpriseAgent_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]),
        CONSTRAINT [FK_EnterpriseAgent_Enterprises_EnterpriseId] FOREIGN KEY ([EnterpriseId]) REFERENCES [Enterprises] ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230604163821_AddRelationEnterpriseAgentWithUserAndEnterprise')
BEGIN
    CREATE INDEX [IX_EnterpriseAgent_EnterpriseId] ON [EnterpriseAgent] ([EnterpriseId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230604163821_AddRelationEnterpriseAgentWithUserAndEnterprise')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230604163821_AddRelationEnterpriseAgentWithUserAndEnterprise', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230607173731_AddPropAreaToHouseBaseAndDateTimeToMessage')
BEGIN
    ALTER TABLE [HousesBase] ADD [Area] float NOT NULL DEFAULT 0.0E0;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230607173731_AddPropAreaToHouseBaseAndDateTimeToMessage')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230607173731_AddPropAreaToHouseBaseAndDateTimeToMessage', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230607174150_AddTimeToMessageTable')
BEGIN
    ALTER TABLE [Messages] ADD [DateTime] datetime2 NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230607174150_AddTimeToMessageTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230607174150_AddTimeToMessageTable', N'7.0.4');
END;
GO

COMMIT;
GO

