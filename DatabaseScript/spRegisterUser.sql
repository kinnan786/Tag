
ALTER PROCEDURE [spRegisterUser]
    @Email VARCHAR(MAX) ,
    @Password VARCHAR(MAX) ,
    @VerificationCode VARCHAR(MAX),
	@isUser BIT
AS
    BEGIN
        DECLARE @returnvalue INT = 0

        IF NOT EXISTS ( SELECT  *
                        FROM    [User]
                        WHERE   Email = @Email )
            BEGIN
                INSERT  INTO [User]
                        ( [Email] ,
                          [Password] ,
                          [VerificationCode] ,
                          EmailVerified,
						  isUser
                        )
                VALUES  ( @Email ,
                          @Password ,
                          @VerificationCode ,
                          0,
						  @isUser
                        )
                SET @returnvalue = SCOPE_IDENTITY()
            END
        ELSE
            BEGIN
                SET @returnvalue = -1
            END

        SELECT  @returnvalue
    END


GO
