/****** Object:  StoredProcedure [tallal78_8].[spIncrementTaggedEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spIncrementTaggedEmotion]
GO
/****** Object:  StoredProcedure [tallal78_8].[spIncrementTaggedEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spIncrementTaggedEmotion]
    @EmotionId INT ,
    @TagId BIGINT ,
    @UserId BIGINT
AS
    BEGIN

        DECLARE @Reurnvalue INT
        DECLARE @TaggedEmotionId BIGINT
		
        SELECT  @TaggedEmotionId = TE.Id
        FROM    TaggedEmotion TE
        WHERE   TE.EmotionId = @EmotionId
                AND TE.TagId = @TagId

        IF NOT EXISTS ( SELECT  *
                        FROM    Tag_Emotion_User
                        WHERE   UserId = @UserId
                                AND TaggedEmotionId = @TaggedEmotionId )
            BEGIN

                INSERT  INTO [Tag_Emotion_User]
                        ( [UserId] ,
                          [TaggedEmotionId] ,
                          [Date]
                        )
                VALUES  ( @UserId ,
                          @TaggedEmotionId ,
                          GETDATE()
                        )

                SELECT  @Reurnvalue = SCOPE_IDENTITY()
            END
        ELSE
            SET @Reurnvalue = 0

        SELECT  @Reurnvalue
    END
GO
