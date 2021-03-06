/****** Object:  StoredProcedure [tallal78_8].[spAddUserTagSubscription]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spAddUserTagSubscription]
GO
/****** Object:  StoredProcedure [tallal78_8].[spAddUserTagSubscription]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spAddUserTagSubscription] @TagID INT, @UserID INT
AS
    BEGIN
        DECLARE @return INT = 0

        IF NOT EXISTS ( SELECT  *
                        FROM    User_Tag_Follow
                        WHERE   TagId = @TagID
                                AND UserId = @UserID )
            BEGIN
                INSERT  INTO [User_Tag_Follow]
                        ( [TagId], [UserId] )
                VALUES  ( @TagID, @UserID )
                SET @return = SCOPE_IDENTITY()
	
            END
        SELECT  @return
    END
GO
