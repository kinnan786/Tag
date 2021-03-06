/****** Object:  StoredProcedure [tallal78_8].[spAddUserTag]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spAddUserTag]
GO
/****** Object:  StoredProcedure [tallal78_8].[spAddUserTag]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spAddUserTag]
    @TagName VARCHAR(MAX) ,
    @LoggedInUserId BIGINT ,
    @ProfileUserId BIGINT
AS
    BEGIN
        DECLARE @TagID BIGINT = 0
        DECLARE @ReturnValue BIGINT = 0

        IF NOT EXISTS ( SELECT  *
                        FROM    Tag
                        WHERE   Name = @TagName )
            BEGIN
                INSERT  INTO [Tag]
                        ( [Name], Date )
                VALUES  ( @TagName, GETDATE() )
			
                SET @TagID = SCOPE_IDENTITY()

            END
        ELSE
            BEGIN
            
                SELECT  @TagId = id
                FROM    Tag
                WHERE   Name = @TagName
			
            END

        IF NOT EXISTS ( SELECT  *
                        FROM    TaggedUsers
                        WHERE   TagID = @TagID
                                AND UserID = @ProfileUserId
                                AND TaggedBy = @LoggedInUserId )
            BEGIN

                INSERT  INTO [TaggedUsers]
                        ( [UserID] ,
                          [TagID] ,
                          [TaggedBy] ,
                          [Date]
                        )
                VALUES  ( @ProfileUserId ,
                          @TagID ,
                          @LoggedInUserId ,
                          GETDATE()
                        )

                INSERT  INTO [TaggedUsers_Votes]
                        ( [Upvote] ,
                          [Downvote] ,
                          [TotalVote] ,
                          [Date] ,
                          [TaggedByUserId] ,
                          [UserID] ,
                          [TagId]
                        )
                VALUES  ( 1 ,
                          0 ,
                          1 ,
                          GETDATE() ,
                          @LoggedInUserId ,
                          @ProfileUserId ,
                          @TagId
                        )
                SET @ReturnValue = 1

            END
        ELSE
            SET @ReturnValue = 2

        SELECT  @ReturnValue
    END

GO
