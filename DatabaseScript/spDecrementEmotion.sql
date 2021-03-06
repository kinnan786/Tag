ALTER PROCEDURE [spDecrementEmotion]
    @Premalink VARCHAR(MAX) ,
    @EmotionId INT ,
    @UserId BIGINT
AS 
    BEGIN

        DECLARE @Premalink_Emotions_Id BIGINT
        DECLARE @PremalinkId BIGINT
        DECLARE @Reurnvalue INT

        SELECT  @PremalinkId = Id
        FROM    Premalink
        WHERE   Link = @Premalink

        SELECT  @Premalink_Emotions_Id = Id
        FROM    Premalink_Emotions
        WHERE   PremalinkId = @PremalinkId
                AND EmotionId = @EmotionId

        IF EXISTS ( SELECT  *
                    FROM    Premalink_Emotions_User
                    WHERE   Premalink_Emotions_Id = @Premalink_Emotions_Id
                            AND UserId = @UserId ) 
            BEGIN

                DELETE  FROM [Premalink_Emotions_User]
                WHERE   Premalink_Emotions_Id = @Premalink_Emotions_Id
                        AND UserId = @UserId

                SELECT  @Reurnvalue = @Premalink_Emotions_Id
            END
        ELSE 
            SET @Reurnvalue = 0

        SELECT  @Reurnvalue
    END
GO