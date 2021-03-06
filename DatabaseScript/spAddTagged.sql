/****** Object:  StoredProcedure [tallal78_8].[spAddTagged]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spAddTagged]
GO
/****** Object:  StoredProcedure [tallal78_8].[spAddTagged]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spAddTagged]
    @TagId BIGINT ,
    @TagName VARCHAR(50) ,
    @UserId BIGINT
AS
    BEGIN

        DECLARE @TaggedId BIGINT = 0
        DECLARE @Id BIGINT = 0 

        IF NOT EXISTS ( SELECT  *
                        FROM    Tag
                        WHERE   Name = @TagName )
            BEGIN
			
                INSERT  INTO [Tag]
                        ( [Name], [Date] )
                VALUES  ( @TagName, GETDATE() )

                SET @TaggedId = SCOPE_IDENTITY()

            END
        ELSE
            SELECT  @TaggedId = Id
            FROM    Tag
            WHERE   Name = @TagName

        INSERT  INTO [Tagged]
                ( [TagId], [TaggedoneId], [Date] )
        VALUES  ( @TagId, @TaggedId, GETDATE() )

        SET @Id = SCOPE_IDENTITY()

        INSERT  INTO [Tagged_Tag_User]
                ( [TaggedId] ,
                  [UserId] ,
                  [UpVote] ,
                  [DownVote] ,
                  [Date]
                )
        VALUES  ( @Id ,
                  @UserId ,
                  1 ,
                  0 ,
                  GETDATE()
                )
    END
GO
