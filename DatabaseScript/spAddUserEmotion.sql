/****** Object:  StoredProcedure [tallal78_8].[spAddUserEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spAddUserEmotion]
GO
/****** Object:  StoredProcedure [tallal78_8].[spAddUserEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spAddUserEmotion]
    @EmotionName VARCHAR(MAX) ,
    @ProfileuserId BIGINT ,
    @UserId BIGINT
AS
    BEGIN

        DECLARE @ReturnVal INT = 0
        DECLARE @EmotionId INT

        IF NOT EXISTS ( SELECT  Id
                        FROM    Emotions
                        WHERE   Name = @EmotionName )
            BEGIN
                INSERT  INTO [Emotions]
                        ( [Name] )
                VALUES  ( @EmotionName )

                SELECT  @EmotionId = SCOPE_IDENTITY()

                INSERT  INTO [EmotionUser]
                        ( [UserID] ,
                          [EmotionId] ,
                          [EmotionUserId] ,
                          [Date]
                        )
                VALUES  ( @ProfileuserId ,
                          @EmotionId ,
                          @UserId ,
                          GETDATE()
                        )
                SET @ReturnVal = 1
            END
        ELSE
            BEGIN
		
                SELECT  @EmotionId = Id
                FROM    Emotions
                WHERE   Name = @EmotionName

                INSERT  INTO [EmotionUser]
                        ( [UserID] ,
                          [EmotionId] ,
                          [EmotionUserId] ,
                          [Date]
                        )
                VALUES  ( @ProfileuserId ,
                          @EmotionId ,
                          @UserId ,
                          GETDATE()
                        )
                SET @ReturnVal = 2
            END

        SELECT  @ReturnVal
    END

GO
