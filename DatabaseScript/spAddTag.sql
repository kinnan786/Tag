
Alter PROCEDURE [tallal78_8].[spAddTag]
    @TagName VARCHAR(MAX) ,
    @UserId BIGINT ,
    @Link VARCHAR(MAX)
AS
    BEGIN

        DECLARE @PremalinkID BIGINT = 0
        DECLARE @TagIDs BIGINT = 0
        DECLARE @PremalinkTagId BIGINT = 0

        SELECT  @PremalinkID = ISNULL(Id, 0)
        FROM    premalink
        WHERE   Link = @Link

        SELECT  @TagIDs = ISNULL(Id, 0)
        FROM    Tag
        WHERE   Name = @TagName

        IF @TagIDs = 0
            BEGIN
                INSERT  INTO Tag
                        ( Name, Date )
                VALUES  ( @TagName, GETDATE() )

                SET @TagIDs = SCOPE_IDENTITY()
            END

        IF @PremalinkID = 0
            BEGIN        
                INSERT  INTO [Premalink]
                        ( [Link] ,
                          [Website_Id] ,
                          [MetaTagCheck] ,
                          CreatedOn
                        )
                VALUES  ( @Link ,
                          2 ,
                          0 ,
                          GETDATE()
                        )

                SET @PremalinkID = SCOPE_IDENTITY()
            END

        INSERT  INTO [PremalinkTags]
                ( [Premalink_Id], [Tag_Id], [Date] )
        VALUES  ( @PremalinkID, @TagIDs, GETDATE() )

        SET @PremalinkTagId = SCOPE_IDENTITY()

        INSERT  INTO [PremalinkTag_User]
                ( [UserId] ,
                  [UpVote] ,
                  [DownVote] ,
                  [PremalinkTagId] ,
                  [Date]
                )
        VALUES  ( @userID ,
                  1 ,
                  0 ,
                  @PremalinkTagId ,
                  GETDATE()
                )
    END

GO
