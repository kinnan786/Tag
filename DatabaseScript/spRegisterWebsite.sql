
ALTER PROCEDURE [spRegisterWebsite]
    @WebSiteName VARCHAR(MAX) ,
    @WebsiteURL VARCHAR(MAX) ,
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
        DECLARE @return BIGINT
        SET @return = 0

        IF EXISTS ( SELECT  *
                    FROM    Website
                    WHERE   URL = @WebsiteURL )
            SET @return = -1
        ELSE
            IF EXISTS ( SELECT  *
                        FROM    Website
                        WHERE   Name = @WebSiteName )
                SET @return = -2
         
        IF ( @return = 0 )
            BEGIN

                INSERT  INTO [Website]
                        ( [Name] ,
                          [URL] ,
                          [UserId] ,
                          [Type] ,
                          AddTag ,
                          RateTag ,
                          AddEmotion ,
                          Tag ,
                          Emotion ,
                          [Image]
			            )
                VALUES  ( @WebSiteName ,
                          @WebsiteURL ,
                          @UserID ,
                          @WebsiteType ,
                          @AddTag ,
                          @RateTag ,
                          @AddEmotion ,
                          @Tag ,
                          @Emotion ,
                          @Image
                        )
                SET @return = SCOPE_IDENTITY()

            END
        SELECT  @return

    END


GO
