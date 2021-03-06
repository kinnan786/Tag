
alter PROCEDURE [spGetWebsiteById] @WebsiteID INT
AS
    BEGIN

        SELECT  [Id] AS WebsiteID ,
                [Name] AS WebSiteName ,
                [URL] AS WebsiteURL ,
                [Description] ,
                [UserId] AS UserID ,
                ISNULL([AddTag], 'false') AS AddTag ,
                ISNULL([RateTag], 'false') AS RateTag ,
                ISNULL([AddEmotion], 'false') AS AddEmotion ,
                ISNULL(Emotion, 'false') AS Emotion ,
                ISNULL(Tag, 'false') AS Tag ,
                ISNULL([Type], 0) AS Type ,
                ISNULL([Image], '') AS [Image]
        FROM    [Website]
        WHERE   Id = @WebsiteID

    END
GO
