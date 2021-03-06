/****** Object:  StoredProcedure [tallal78_8].[spAddEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spAddEmotion]
GO
/****** Object:  StoredProcedure [tallal78_8].[spAddEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spAddEmotion]
    @EmotionName VARCHAR(MAX) ,
    @Link VARCHAR(MAX) ,
    @UserId BIGINT ,
    @EmotionId INT
AS
    BEGIN

        DECLARE @PremalinkEmotionId BIGINT = 0
        DECLARE @PremalinkId BIGINT = 0
        DECLARE @ReturnVal INT = 1

        IF NOT EXISTS ( SELECT  *
                        FROM    Premalink
                        WHERE   Link = @Link )
            BEGIN
        
                INSERT  INTO [Premalink]
                        ( [Link] ,
                          [CreatedOn] ,
                          Website_Id ,
                          MetaTagCheck 
                        )
                VALUES  ( @Link ,
                          GETDATE() ,
                          2 ,
                          0 
                        )
                SELECT  @PremalinkId = SCOPE_IDENTITY()
            END
        ELSE
            BEGIN

                SELECT  @PremalinkId = id
                FROM    Premalink
                WHERE   Link = @Link
            
            END

        IF NOT EXISTS ( SELECT  *
                        FROM    Emotions
                        WHERE   Name = @EmotionName )
            BEGIN
                INSERT  INTO [Emotions]
                        ( [Name] )
                VALUES  ( @EmotionName )

                SELECT  @EmotionId = SCOPE_IDENTITY()
            END
        ELSE
            BEGIN
            
                SELECT  @EmotionId = id
                FROM    Emotions
                WHERE   Name = @EmotionName
            
            END

        --BEGIN TRANSACTION tran1;

        IF NOT EXISTS ( SELECT  *
                        FROM    Premalink_Emotions
                        WHERE   PremalinkId = @PremalinkId
                                AND EmotionId = @EmotionId )
            BEGIN
                INSERT  INTO [Premalink_Emotions]
                        ( [PremalinkId], [EmotionId] )
                VALUES  ( @PremalinkId, @EmotionId )

                SELECT  @PremalinkEmotionId = SCOPE_IDENTITY()
            END
        ELSE
            BEGIN
                SELECT  @PremalinkEmotionId = Id
                FROM    Premalink_Emotions
                WHERE   PremalinkId = @PremalinkId
                        AND EmotionId = @EmotionId
            
            END

        IF NOT EXISTS ( SELECT  *
                        FROM    Premalink_Emotions_User
                        WHERE   Premalink_Emotions_Id = @PremalinkEmotionId
                                AND UserId = @UserId )
            BEGIN

                INSERT  INTO [Premalink_Emotions_User]
                        ( [Premalink_Emotions_Id] ,
                          [UserId]
                        )
                VALUES  ( @PremalinkEmotionId ,
                          @UserId
                        )

            END
        ELSE
            BEGIN
                SET @ReturnVal = -4
            END
	
        --IF @ReturnVal = -3
        --    OR @ReturnVal = -4
        --    ROLLBACK TRANSACTION tran1
        --ELSE
        --    COMMIT TRANSACTION tran1

        SELECT  @ReturnVal

    END

GO
