ALTER PROCEDURE [spUpdateWebsite]
    @WebSiteName VARCHAR(MAX) ,
    @WebsiteURL VARCHAR(MAX) ,
    @WebsiteID VARCHAR(MAX) ,
    @WebsiteType INT ,
    @UserID INT ,
    @AddTag BIT ,
    @RateTag BIT ,
    @AddEmotion BIT ,
    @Tag BIT ,
    @Emotion BIT ,
    @Image VARCHAR(MAX) = ''
AS
    BEGIN
        DECLARE @return INT = 0

        IF EXISTS ( SELECT  Name
                    FROM    Website
                    WHERE   Name = @WebSiteName
                            AND Id <> @WebsiteID )
            SET @return = -1
        
        IF EXISTS ( SELECT  Name
                    FROM    Website
                    WHERE   URL = @WebsiteURL
                            AND Id <> @WebsiteID )
            SET @return = -2
        

        IF EXISTS ( SELECT  *
                    FROM    Website
                    WHERE   Id = @WebsiteID )
            BEGIN
                IF ( @return = 0 )
                    BEGIN
                        UPDATE  [Website]
                        SET     [Name] = @WebSiteName ,
                                [URL] = @WebsiteURL ,
                                [AddTag] = @AddTag ,
                                [AddEmotion] = @AddEmotion ,
                                [RateTag] = @RateTag ,
                                [Tag] = @Tag ,
                                [Emotion] = @Emotion ,
                                [Type] = @WebsiteType ,
                                [Image] = CASE WHEN @Image = '' THEN [Image]
                                               ELSE @Image
                                          END
                        WHERE   Id = @WebsiteID
                                AND userid = @UserID
                        SET @return = @WebsiteID
                    END
            END
        SELECT  @return
    END
GO
